package iv247.iv;

import haxe.rtti.Meta;
import iv247.iv.ExtensionDef;
import iv247.iv.Injection;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import iv247.iv.macros.IVMacro;
#end

#if !macro
@:build(iv247.iv.macros.IVMacro.buildMeta(["inject","post"]))
#end

class IV implements IInjector {

    private var injectionMap : Map<String, Injection>;
    
    private static var extensionMap : Map<String, ExtensionDef->Void>;

    public function new () {
        injectionMap = new Map();
        test(Injection);
    }


    public function test<T>( inj:Injectable<Enum<T>,Class<T>> ):Void {
        trace(inj.isEnum());
    }

    public function mapValue<T> (whenType : Injectable< Enum<T>,Class<T>>,
                                 value : T,
                                 ?id : String = "") : Void {
        
        injectionMap.set( whenType.getName() + id, Value(value) );       
    } 

    public function mapDynamic<T> (whenType :  Injectable< Enum<T>,Class<T>>,
                                   createType : Injectable< Enum<T>,Class<T>>,
                                   ?id : String = "") : Void {
        var key =  whenType.getName() + id,
            value = Injection.DynamicObject(createType);

        injectionMap.set( key, value );

    }

    public function mapSingleton<T> (whenType : Injectable<Enum<T>,Class<T>>,
                                     getInstance : Injectable<Enum<T>,Class<T>>,
                                     ?id : String = "") : Void {
        var key =  whenType.getName() + id,
            value = Injection.Singleton(whenType, getInstance);

        injectionMap.set( key, value );
    }

    public function hasMapping<T> (type : Injectable<Enum<T>,Class<T>>, ?id : String = "") : Bool {        
        return injectionMap.exists( type.getName() + id );       
    }

    public function unmap (type : Injectable<Enum<Dynamic>,Class<Dynamic>>, ?id : String = "") : Void {
        injectionMap.remove( type.getName() + id );
    }

    public function getInstance<T> (type : Injectable<Enum<T>,Class<T>>, ?id : String = "") : T {

        var injection = type.getName() + id,
            instance, newInstance;

        if(!injectionMap.exists(injection)){
            return null;
        }

        instance =
        switch(injectionMap.get(injection)) {
            case Injection.Value(object) :
                object;

            case Injection.DynamicObject(type) :
                instantiate(type);

            case Injection.Singleton(type,instanceType) :
                newInstance = instantiate(instanceType);
                mapValue(type,newInstance,id);
                newInstance;

            case Enumeration(i) :
                i;
        }

        return cast instance;
    }

    // public function getEnumInstance<T> (type : Enum<T>,?id:String = "") : EnumValue {
    //     var injection = Type.getEnumName(type) + id,
    //         instance;

    //     if(!injectionMap.exists(injection)){
    //         return null;
    //     }

    //     instance = 
    //     switch(injectionMap.get(injection)) {
    //         case Enumeration(v) :
    //         v;
    //         default :
    //         null;
    //     }

    //     return instance;
    // }

    public function instantateEnum<T> (type : Enum<T>, ctor : String) : T {

         var meta = Meta.getFields(type),
             ctorMeta = null,
             metaField,
             injectIds,
             args = [],
             typeName,
             instanceType,
             enumInstanceType,
             instance,
             id;

            for(fieldName in Reflect.fields(type)){
                if(fieldName == ctor){
                    ctorMeta = getFieldMeta(meta, fieldName);
                    break;
                }
            }

           if(ctorMeta != null && ctorMeta.types !=null){
                injectIds = (ctorMeta.inject == null) ? [] : ctorMeta.inject;

                for(type in ctorMeta.types){
                    id = injectIds[args.length] != null ? injectIds[args.length] : "";
                    
                    instanceType = Type.resolveClass(type.type);
                    if(instanceType == null){
                        enumInstanceType = Type.resolveEnum(type.type);
                        instance = cast getInstance( enumInstanceType,id);
                    }else{
                        instance = getInstance( instanceType, id );
                    }
                   
                    args.push( instance ); 
                }
            }

         return Type.createEnum(type,ctor,args);
    }


    private function getFieldMeta(meta,fieldName) : Dynamic<Array<Dynamic>> {
        return  Reflect.field(meta,fieldName);
    }


    public function instantiate<T> (type : Class<T>) : T {
        var ctorMeta = Meta.getFields(type)._,
            args = [],
            injectIds,
            instance,
            instanceType,
            enumInstanceType,
            id;

        if(ctorMeta != null && ctorMeta.types !=null){
            injectIds = (ctorMeta.inject == null) ? [] : ctorMeta.inject;

            for(type in ctorMeta.types){
                id = injectIds[args.length];
                instanceType = Type.resolveClass(type.type);
                instance = getInstance( instanceType, id );
                args.push( instance ); 
            }
        }

        instance = Type.createInstance(type,args);

        if(ctorMeta != null){
            for(key in extensionMap.keys()){
                if(Reflect.hasField(ctorMeta,key)){
                    extensionMap.get(key)({
                        injector : this,
                        metaname : key,
                        object : instance,
                        type : ExtensionType.Constructor
                    });
                }
            }
        }

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

                for(key in extensionMap.keys()){
                    if(Reflect.hasField(metaField,key)){
                        extensionMap.get(key)({
                            injector : this,
                            metaname : key,
                            object : object,
                            type : ExtensionType.Property
                        });
                    }
                 }    
            }

            type = Type.getSuperClass(type);  
        }
    }


    public function call (methodName : String, object: Dynamic) : Dynamic {
        var fields = Meta.getFields( Type.getClass(object)  ),
            metaList = Reflect.field(fields,methodName),
            types : Array<Dynamic> = metaList.types,
            args = [],
            newInstance,
            id,
            result;

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

        result = Reflect.callMethod( 
                    object, 
                    Reflect.field( object , methodName ), 
                    args 
                );

        for(key in extensionMap.keys()){
            if(Reflect.hasField(metaList,key)){
                    extensionMap.get(key)({
                        injector : this,
                        metaname : key,
                        object : object,
                        type : ExtensionType.Method
                    });
            }
        }    

        return  result;
    }
    
    #if !display
    public static function addExtension (metaname : String, func : ExtensionDef -> Void){
        if(extensionMap == null){
            extensionMap = new Map();
        }

        extensionMap.set(metaname,func);
    }
    #end

    public function removeExtension (metaname : String) : Void {
        extensionMap.remove(metaname);
    }

    macro static public function extendIocTo (expr : ExprOf<String>, ?extension : Expr) : Expr {
        iv247.iv.macros.IVMacro.metaNames.push(ExprTools.getValue(expr));
        return macro  IV.addExtension(${expr}, ${extension});
    }

}

