package iv247;

import haxe.rtti.Meta;
import iv247.iv.*;
import iv247.iv.Injection;
import iv247.iv.internal.Injectable;
import iv247.iv.IInjector;

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

    public var parent(default,set) : IInjector;
    
    private static var extensionMap : Map<String, ExtensionDef->Void>;

    public function new (?parentInjector : IInjector) {
        injectionMap = new Map();
        parent = parentInjector;
    }

    public function set_parent(value:IInjector):IInjector{
        if(value == null){
            parent = value;
        }
        else if(value.parent == this || this == value){
            throw("Circular reference");
        }else{
            parent = value;
        }
        return value;
    }

    macro static public function extendIocTo (expr : ExprOf<String>, ?extension : Expr) : Expr {
        iv247.iv.macros.IVMacro.metaNames.push(ExprTools.getValue(expr));
        return macro  IV.addExtension(${expr}, ${extension});
    }

    @:noCompletion
    public static function addExtension (metaname : String, func : ExtensionDef -> Void){
        if(extensionMap == null){
            extensionMap = new Map();
        }

        extensionMap.set(metaname,func);
    }

    public function removeExtension (metaname : String) : Void {
        extensionMap.remove(metaname);
    }

    public function mapValue<T> (whenType : Injectable< Enum<T>,Class<T>>,
                                 value : T,
                                 ?id : String = "") : Void {
        injectionMap.set( whenType.getName() + id, Value(value) );       
    } 

    public function mapDynamic<T> (whenType :  Injectable< Enum<T>,Class<T>>,
                                   createType : Injectable< Enum<T>,Class<T>>,
                                   ?id : String = "",
                                   ?constr : String) : Void {
        var key =  whenType.getName() + id,
            value = Injection.DynamicObject(createType,constr);

        injectionMap.set( key, value );
    }

    public function mapSingleton<T> (whenType : Injectable<Enum<T>,Class<T>>,
                                     getInstance : Injectable<Enum<T>,Class<T>>,
                                     ?id : String = "",
                                     ?constr : String) : Void {
        var key =  whenType.getName() + id,
            value = Injection.Singleton(whenType, getInstance,constr);

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
           return parent != null ? parent.getInstance(type,id) : null;
        }

        instance =
        switch(injectionMap.get(injection)) {
            case Injection.Value(object) :
                object;

            case Injection.DynamicObject(type,ctor) :
                instantiate(type,ctor);

            case Injection.Singleton(type,instanceType,ctor) :
                newInstance = instantiate(instanceType,ctor);   
                mapValue(type,newInstance,id);
                newInstance;
        }

        return instance;
    }

    public function instantiate<T> (type : Injectable<Enum<T>,Class<T>>,?constr : String) : T {
        var meta = Meta.getFields(type),
            ctorMeta = null,
            args,
            injectIds,
            instance,
            instanceType,
            enumInstanceType,
            id;

        if(type.isClass()){
            ctorMeta = meta._;
        }else {
            ctorMeta = getFieldMeta(meta, constr);
        }

        args = getMethodArgInstances(ctorMeta);
       
        instance = type.instantiate(args,constr);

        if(ctorMeta != null){
            callExtensions(ctorMeta,instance,ExtensionType.Constructor);  
        }

        if(type.isClass()){
           injectInto(instance); 
        }

        return instance;
    }

    public function injectInto (object : Dynamic) : Void {
        var targetType : Injectable<Enum<Dynamic>,Class<Dynamic>>,
            type = Type.getClass(object),
            fields,
            metaField : Dynamic<Array<Dynamic>>,
            instanceId,
            instance,
            isFunction,
            postMethods = new Map<String,Dynamic>();

        while(type != null){
         
            fields = Meta.getFields(type);        

            for(field in Reflect.fields(fields)){

                if(field == "_"){
                    continue;
                };

                isFunction = Reflect.isFunction(Reflect.field(object,field));
                metaField = getFieldMeta(fields,field);
                targetType = Std.string( metaField.types[0] ) ;
                
                if(isFunction) {
                    if( Reflect.hasField(metaField,'post') 
                        && !postMethods.exists(field) ) 
                    {
                                postMethods.set( field, {
                                    methodName : field,
                                    metaList : metaField,
                                    ids : metaField.post
                                });
                    }
                    continue;
                }

                instanceId = metaField.inject != null ? metaField.inject[0] : "";
                instance = getInstance(targetType, instanceId);

                Reflect.setField(object,field,instance);
                callExtensions(metaField,object,ExtensionType.Property); 
            }

            type = Type.getSuperClass(type); 
        }

        for(postMethod in postMethods){
            callMethod(  postMethod.metaList,  postMethod.methodName,object,  postMethod.ids);
        }

    }

    private function getFieldMeta(meta,fieldName) : Dynamic<Array<Dynamic>> {
        return  Reflect.field(meta,fieldName);
    }

    private function callMethod(metaList:Dynamic<Array<Dynamic>>, methodName : String, object: Dynamic,?ids:Array<Dynamic>) : Dynamic {
        var types : Array<Dynamic> = metaList.types,
            args,
            newInstance,
            id,
            result;

        args = getMethodArgInstances(metaList,ids);
        
        result = Reflect.callMethod( 
                    object, 
                    Reflect.field( object , methodName ), 
                    args 
                );

        callExtensions(metaList,object,ExtensionType.Method);

        return  result;
    }

    public function call (methodName : String, object: Dynamic) : Dynamic {
        var fields = Meta.getFields( Type.getClass(object)  ),
            metaList = Reflect.field(fields,methodName),
            types : Array<Dynamic> = metaList.types,
            result;

            
        result = callMethod(metaList,methodName,object);

        callExtensions(metaList,object,ExtensionType.Method);

        return  result;
    }
   
    private function getMethodArgInstances(meta:Dynamic<Array<Dynamic>>,?ids:Array<Dynamic>):Array<Dynamic> {
        var id,
            args = [],
            instanceType : Injectable<Enum<Dynamic>,Class<Dynamic>>,
            instance;

        if(meta != null && meta.types != null){
            if(ids == null){
                ids = (meta.inject == null) ? [] : meta.inject;
            }
            
            for(type in meta.types){
                id = ids[args.length];
                instanceType = Std.string( type.type );
                instance = getInstance( instanceType, id );
                args.push( instance ); 
            }
        }

        return args;
    }

    private function callExtensions(metaList:Dynamic<Array<Dynamic>>, object:Dynamic, extensionType:ExtensionType) : Void {
        for(key in extensionMap.keys()){
            if(Reflect.hasField(metaList,key)){
                extensionMap.get(key)({
                    injector : this,
                    metaname : key,
                    object : object,
                    type : extensionType
                });
            }
        }  
    }   
}