package iv247.intravenous.messaging;

import iv247.intravenous.ioc.IInjector;
import iv247.intravenous.ioc.ExtensionDef;
import iv247.intravenous.ioc.IV;
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
    private var completeMap : Map<String, Array<CommandDef>>;
    private var openSequencers : Array<CommandSequencer>;

    public function new(injector : IInjector) {
        this.injector = injector;
        commandMap = new Map();
        interceptMap = new Map();
        completeMap = new Map();
    }


    public static inline function getDispatcher(ext : ExtensionDef) : Void {
        var processor = ext.injector.getInstance(MessageProcessor);
        Reflect.setField(ext.object,ext.field,processor.dispatch);
    }

    /**
     Procesess extension definiton sent from the injector
     after object instantiationg
    **/
    public function processMeta(def : ExtensionDef):Void {
        switch(def.type){
            case iv247.intravenous.ioc.ExtensionType.Constructor : return;

            case iv247.intravenous.ioc.ExtensionType.Property :

                var metaValue = Reflect.field(def.meta,def.metaname),
                    order = (metaValue == null) ? 0 : metaValue[0],
                    isAsync =  Reflect.hasField(def.meta,'async'),
                    map = Reflect.hasField(def.meta,'intercept') ? interceptMap :
                            Reflect.hasField(def.meta,'commandComplete') ? completeMap : commandMap,
                    messageType =  Reflect.field(def.meta,'types')[0].type,
                    ref : CommandDef;


                    if(!Std.is(order,Int)){
                        order = 0;
                    }
                    ref = {
                        o:def.object,
                        f: def.field,
                        i:order,
                        t:Type.typeof(def.object),
                        async : isAsync
                    };

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
            map;

        for(field in fields){

            fieldMeta = Reflect.field(meta,field);

            if(Reflect.hasField(fieldMeta,"intercept")){
                map = interceptMap;
            }else if( Reflect.hasField(fieldMeta,"command")){
                map = commandMap;
            }else if(Reflect.hasField(fieldMeta,"commandComplete")){
                map = completeMap;
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
            order = (classMeta.command == null) ? -1 : classMeta.command[0],
            isInterceptor = Reflect.hasField(classMeta,"intercept"),
            isAsync = Reflect.hasField(classMeta,"async"),
            map = (isInterceptor) ? interceptMap : commandMap,
            ref = {
                o:commandClass,
                f:'execute',
                i:order,
                t:Type.typeof(commandClass),
                async: isAsync
            };

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

    private function insertCommandRef(map:Map<String, Array<CommandDef>>,messageType:String,def:CommandDef):Void{
        var mapArray = map.get(messageType),
            newArray;

        if(mapArray == null){
            mapArray = new Array<CommandDef>();
            map.set(messageType,mapArray);
        }

        mapArray.push(def);

        mapArray.sort(function(ref,ref2):Int{
            if(ref.i < ref2.i){
                return -1;
            }
            else if(ref.i > ref2.i){
                return 1;
            }else{
                return 0;
            }
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
    //Consider returning the sequencer
    public function dispatch(o:Dynamic):Void{
        var messageType = Type.getClassName(Type.getClass(o)),
            interceptors = interceptMap.get(messageType),
            commands = commandMap.get(messageType),
            completeMethods = completeMap.get(messageType),
            sequencer = new CommandSequencer({
                interceptors : interceptors,
                commands : commands,
                completeMethods : completeMethods,
                message: o,
                processor : this
            },
            injector);

        if(openSequencers == null){
            openSequencers = new Array<CommandSequencer>();
        }
        openSequencers.push(sequencer);
        sequencer.start();
    }

    private function removeSequence(sequencer:CommandSequencer){
        if(openSequencers != null){
            openSequencers.remove(sequencer);
        }
    }
}
