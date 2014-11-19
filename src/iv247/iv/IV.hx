package iv247.iv;

import haxe.rtti.Meta;

#if !macro
@:build(iv247.iv.macros.IVMacro.buildMeta(["inject","post"]))
#end
class IV implements IInjector {

    private var classMap : Map<String, Injection>;

    public function new () {
        classMap = new Map();

    }

    public function mapValue<T> (whenType : Class<T>,
                                 value : T,
                                 ?id : String = "") : Void {
        classMap.set( Type.getClassName( whenType ) + id, Value(value) );
    }

    public function mapDynamic<T> (whenType : Class<T>,
                                   createType : Class<T>,
                                   ?id : String = "") : Void {
        var key =  Type.getClassName( whenType ) + id,
            value = Injection.DynamicObject(createType);

        classMap.set( key, value );
    }

    public function mapSingleton<T> (whenType : Class<T>,
                                     getInstance : Class<T>,
                                     ?id : String = "") : Void {
        var key =  Type.getClassName( whenType ) + id,
            value = Injection.Singleton(whenType, getInstance);

        classMap.set( key, value );
    }

    public function hasMapping<T> (type : Class<T>, ?id : String = "") : Bool {
        return classMap.exists( Type.getClassName( type ) + id );
    }

    public function unmap (type : Class<Dynamic>, ?id : String = "") : Void {
        classMap.remove( Type.getClassName( type ) + id );
    }

    public function getInstance<T> (type : Class<T>, ?id : String = "") : T {
        var injection = Type.getClassName( type ) + id,
            instance, newInstance;

            if(!classMap.exists(injection)){
            return null;
        }

        instance =
        switch(classMap.get(injection)) {
            case Injection.Value(object) :
                object;

            case Injection.DynamicObject(type) :
                Type.createEmptyInstance(type);

            case Injection.Singleton(type,instanceType) :
                newInstance = Type.createInstance(instanceType,[]);
                mapValue(type,newInstance,id);
                newInstance;
        }

        return instance;
    }

    public function instantiate<T> (type : Class<T>) : T {
        var ctorMeta = Meta.getFields(type)._,
            args = [],
            injectIds;

        if(ctorMeta != null){
            injectIds = (ctorMeta == null || ctorMeta.inject == null) ? [] : ctorMeta.inject;

            for(type in ctorMeta.types){
                var id = injectIds[args.length];
                var instanceType = Type.resolveClass(type.type);
                var instance = getInstance( instanceType, id );
                args.push( instance ); 
            }
        }

        return Type.createInstance( type, args );
    }

    public function injectInto (object : Dynamic) : Void {
        var type = Type.getClass(object),
            fields = Meta.getFields(type),
            targetType,
            metaField,
            instanceId,
            instance;

        for(field in Reflect.fields(fields)){

            if(field == "_" || Reflect.isFunction(Reflect.field(object,field)) ){
                continue;
            };
           
            metaField =  Reflect.field(fields,field);
            targetType = Type.resolveClass( metaField.types[0] );

            instanceId = metaField.inject != null ? metaField.inject[0] : "";         

            instance = getInstance(targetType, instanceId);

            Reflect.setField(object,field,instance);
        }
    }

    public function call (methodName : String, object : Dynamic) : Dynamic {
        Reflect.callMethod(object,Reflect.field(object,methodName),[]);
        return null;
    }

}