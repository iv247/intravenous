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
                instantiate(type);

            case Injection.Singleton(type,instanceType) :
                newInstance = instantiate(instanceType);
                mapValue(type,newInstance,id);
                newInstance;
        }

        return instance;
    }

    public function instantiate<T> (type : Class<T>) : T {
        var ctorMeta = Meta.getFields(type)._,
            args = [],
            injectIds,
            instance;

        if(ctorMeta != null && ctorMeta.types !=null){
            injectIds = (ctorMeta == null || ctorMeta.inject == null) ? [] : ctorMeta.inject;

            for(type in ctorMeta.types){
                var id = injectIds[args.length];
                var instanceType = Type.resolveClass(type.type);
                var instance = getInstance( instanceType, id );
                args.push( instance ); 
            }
        }

        instance = Type.createInstance(type,args);
        injectInto(instance);

        return instance;
    }


    public function injectInto (object : Dynamic) : Void {
        var type = Type.getClass(object),
            fields,
            targetType,
            metaField,
            instanceId,
            instance;

        while(type != null){
         
            fields = Meta.getFields(type);        

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

            type = Type.getSuperClass(type);  
        }
    }

    public function call (methodName : String, object: Dynamic) : Dynamic {
        var fields = Meta.getFields( Type.getClass(object)  ),
            metaList = Reflect.getProperty(fields,methodName),
            types : Array<Dynamic> = metaList.types,
            args = [],
            newInstance,
            id;

            if(metaList != null){

                for(meta in types){
                    id = metaList.inject != null ? metaList.inject[args.length] : "";
                    newInstance = getInstance( 
                        Type.resolveClass(meta.type),
                        id
                    );

                    args.push(newInstance);     
                }
            }

        return  Reflect.callMethod( 
                    object, 
                    Reflect.field( object , methodName ), 
                    args 
                );
    }

}
