package iv247.intravenous.messaging;

import iv247.iv.IInjector;
import iv247.iv.ExtensionDef;
import iv247.IV;
import haxe.rtti.Meta;
import iv247.intravenous.messaging.CommandDef;

#if !macro
@:build(iv247.intravenous.messaging.MessagingMacro.buildCommand())
#end
class MessageProcessor 
{
	public static inline var DISPATCHER_META = "dispatcher";
	public var injector(default,null): IInjector;

	private var commandMap : Map<String, Array<CommandDef>>;
	private var interceptMap : Map<String, Array<CommandDef>>;
	private var resultMap : Map<String, Array<CommandDef>>;

	public function new(injector : IInjector) {
		this.injector = injector;
		commandMap = new Map();
		interceptMap = new Map();
		resultMap = new Map();
	}

	/**
	 Procesess extension definiton sent from the injector 
	 after object instantiationg
	**/
	public function processMeta(def : ExtensionDef):Void {
		switch(def.type){
			case iv247.iv.ExtensionType.Constructor : return;

			case iv247.iv.ExtensionType.Property : 

				var order = Reflect.field(def.meta,def.metaname),
					map = Reflect.hasField(def.meta,'intercept') ? interceptMap : 
						  Reflect.hasField(def.meta,'commandResult') ? resultMap : commandMap,
					messageType =  Reflect.field(def.meta,'types')[0].type,
					ref : CommandDef;
					
					if(order == null){
						order = 0;
					}

					ref = {o:def.object, f: def.field, i:order, t:Type.typeof(def.object)}

				insertCommandRef(map,messageType,ref);

			default:  return;
		}
	}

	/**
		Deregister an object with registered command, commandResult, or intercept methods.
		Calling this method is necessary for any objects that need to be removed from memory
		(ie. Prestionation Models/View Controllers)
	**/
	public function deregister(o:Dynamic):Void{
		var type = Type.getClass(o),
			fields = Type.getClassFields(type),
			meta = Meta.getFields(type),
			fields = Reflect.fields(meta),
			fieldMeta,
			map,
			interceptorsRemoved = false,
			commandsRemoved = false,
			commandResultsRemoved = false;

		for(field in fields){

			fieldMeta = Reflect.field(meta,field);
			
			if(Reflect.hasField(fieldMeta,"intercept") && !interceptorsRemoved){
				map = interceptMap;
				interceptorsRemoved = true;
			}else if( Reflect.hasField(fieldMeta,"command") && !commandsRemoved){
				map = commandMap;
				commandsRemoved = true;
			}else if(Reflect.hasField(fieldMeta,"commandResult") && !commandResultsRemoved){
				map = resultMap;
				commandResultsRemoved = true;
			}else{
				map = null;
			}

			if(map != null){
				removeFromMap(o,type,map);		
			}
		}
	}

	/**
		Removed all references to object from map
	**/
	private function removeFromMap(object: Dynamic, type : Class<Dynamic>, map : Map<String,Array<CommandDef>>):Void {
		for(defArray in map){
			for(def in defArray){
				if(def.o == object){
					defArray.remove(def);
				}
			}
		}
	}


	/**
		Maps a class to instantiate when an object respective of the class execute method
		is dispatched using the message processors dispatch method
	**/
	public function mapCommand(commandClass:Class<Dynamic>):Void {
		var className = Type.getClassName(commandClass),
			classMeta = Meta.getType(commandClass),
			messageType = classMeta.messageTypes[0].type,
			order = classMeta.command == null ? -1 : classMeta.command[0],
			isInterceptor = Reflect.hasField(classMeta,"intercept"),
			map = (isInterceptor) ? interceptMap : commandMap,
			ref = {o:commandClass, f:'execute', i:order, t:Type.typeof(commandClass)};

		insertCommandRef(map,messageType,ref);	
	}

	/**
		Removes a mapped class from list of commands to be instansiated and executed
		when the associated dispatch object is dispatched
	**/
	public function removeCommand(commandClass:Class<Dynamic>):Void {
		var className = Type.getClassName(commandClass),
			classMeta = Meta.getType(commandClass),
			messageType = classMeta.messageTypes[0].type,
			order = classMeta.command == null ? -1 : classMeta.command[0],
			isInterceptor = Reflect.hasField(classMeta,"intercept"),
			map = (isInterceptor) ? interceptMap : commandMap,
			ref = {o:commandClass, f:'execute', i:order, t:Type.typeof(commandClass)};

		removeCommandRef(map,messageType,ref);	
	}

	private function processCommandMeta(m:haxe.rtti.CType.MetaData,o:Dynamic,f:String):Void{
		var messageType = Reflect.field(m[0],'command'),
			order = Std.parseInt(Reflect.field(m[0],'order') ),
			isInterceptor = (Reflect.field(m[0],'intercept') != null),
			map = (isInterceptor) ? interceptMap : commandMap,
			ref = {o:o,f:f, i:order, t:Type.typeof(o)};

		insertCommandRef(map,messageType,ref);			
	}

	private function insertCommandRef(map:Map<String, Array<CommandDef>>,messageType:String,def:CommandDef):Void{
		var mapArray = map.get(messageType);
	
		if(mapArray == null){
			mapArray = new Array<CommandDef>();
			map.set(messageType,mapArray);
		}

        mapArray.insert(def.i,def);
        mapArray.sort(function(ref,ref2):Int{
            return (ref == ref2) ? 0 : (ref.i < ref2.i) ? -1 : 1;
        });
	}

	private function removeCommandRef(map:Map<String,Array<CommandDef>>,messageType:String, def:CommandDef):Void{
		var mapArray = map.get(messageType);

		if(mapArray != null){
			for(commandDef in mapArray){
				if(commandDef.o == def.o){
					mapArray.remove(commandDef);
				}
			}
		}
	}


	/**
		Method used to dispatch an object as a message to be handled by commands
		This method can be injected into class property of type Dynamic->Void annotated
		with @dispatcher
	**/
	public function dispatch(o:Dynamic):Void{
		var messageType = Type.getClassName(Type.getClass(o)),
			interceptors = interceptMap.get(messageType),
			commands = commandMap.get(messageType),
			resultCommands = resultMap.get(messageType);

		if(interceptors != null){
			callCommands(interceptors,[o,this]);
		}

		if(commands != null){
			callCommands(commands,[o]);
		}

		if(resultCommands != null){
			callCommands(resultCommands,[o]);
		}
	}

	private function callCommands(commandDefs:Array<CommandDef>,args:Array<Dynamic>):Void{
		var ref,
            instance;
		for(i in 0...commandDefs.length){
			ref = commandDefs[i];
			switch(ref.t){
				case TObject:
                    //ref.o is a class in this case
                    instance = (injector != null) ? injector.instantiate(ref.o) : Type.createInstance(ref.o ,[]);
                    Reflect.callMethod( instance , Reflect.field(instance,ref.f), args);
				case TClass(c):
					Reflect.callMethod(ref.o, Reflect.field(ref.o, ref.f), args);
				case _: //todo: throw error
						//errorHandler('callCommands',ref);
						null;
			}
		}
	}

	private static function getDispatcher(ext : ExtensionDef) : Void {
		var processor = ext.injector.getInstance(MessageProcessor);
		Reflect.setField(ext.object,ext.field,processor.dispatch);
	}
}