package iv247.intravenous.messaging;

import iv247.iv.IInjector;
import iv247.iv.ExtensionDef;
import iv247.IV;
import haxe.rtti.Meta;

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
	private var dynamicCommandMap : Map<String, Class<Dynamic>>;

	public function new(injector : IInjector) {
		this.injector = injector;
	}

	/**
	 Procesess extension definiton sent from the injector 
	 after object instantiationg
	**/
	public function processMeta(def : ExtensionDef):Void {
		switch(def.type){
			case iv247.iv.ExtensionType.Constructor :
				trace('command handler injected');
			default: 
		}
	}

	/**
		Maps a class to instantiate when an object respective of the class execute method
		is dispatched using the message processors dispatch method
	**/
	public function mapCommand(commandClass:Class<Dynamic>):Void {
		var className = Type.getClassName(commandClass),
			classMeta = Meta.getType(commandClass),
			message = classMeta.messageType,
			order = classMeta.command == null ? -1 : classMeta.command[0];

		//processCommandMeta(metaParams,commandClass, 'execute');
	}

	private function processCommandMeta(m:haxe.rtti.CType.MetaData,o:Dynamic,f:String):Void{
		var messageType = Reflect.field(m[0],'command'),
			order = Std.parseInt(Reflect.field(m[0],'order') ),
			isInterceptor = (Reflect.field(m[0],'intercept') != null),
			map = (isInterceptor) ? interceptMap : commandMap,
			ref = {o:o,f:f, i:order, t:Type.typeof(o)};

		insertCommandRef(map,messageType,ref);			
	}

	private function insertCommandRef(map,messageType:String,def:CommandDef):Void{
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
                    instance = (injector != null) ? injector.getInstance(ref.o) : Type.createInstance(ref.o ,[]);
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