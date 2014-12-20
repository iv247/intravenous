package iv247.intravenous.ioc;

import haxe.rtti.Meta;
import iv247.intravenous.ioc.internal.Injectable;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import iv247.intravenous.ioc.macros.IVMacro;
#end

#if !macro
@:build(iv247.intravenous.ioc.macros.IVMacro.buildMeta(["inject","post"]))
#end
class IV implements IInjector {

    private static var extensionMap : Map<String, ExtensionDef->Void>;

    private var injectionMap : Map<String, Injection>;

    public var parent(default,set) : IInjector;
    
    /**
        Create a new IV instance
        optionally assign a parentInjector
    **/
    public function new (?parentInjector : IInjector) {
        injectionMap = new Map();
        parent = parentInjector;
    }

 
    private function set_parent(value:IInjector):IInjector{
        if(value == null){
            parent = value;
        }
        else if(value.parent == this || this == value){
            throw("Circular reference");
        }
        else{
            parent = value;
        }
        return value;
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

    /**
        The given Class or Enum will be instantiated with any previously mapped contructor arguments.
        The resulting instance will have its properties injected using injectInto.
        Any applicable extensions with be called directly after instantiation and before property injection; 
    **/
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

    /**
        Extensions will be called after injection.
        Any method annotated with @post, including in herited will be called after 
        property injection and extensions are called.
    **/
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
                }else{
                    targetType = Std.string( metaField.types[0] ) ;

                    instanceId = metaField.inject != null ? metaField.inject[0] : "";
                    instance = getInstance(targetType, instanceId);

                    Reflect.setField(object,field,instance);
                }
       
                callExtensions(metaField,object,ExtensionType.Property,field); 
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

    /**
        Any applicable extensions will be called after method is called but
        before the result of the method is returned.
    **/
    public function call (methodName : String, object: Dynamic) : Dynamic {
        var fields = Meta.getFields( Type.getClass(object)  ),
            metaList = Reflect.field(fields,methodName),
            types : Array<Dynamic> = metaList.types,
            result;

            
        result = callMethod(metaList,methodName,object);

        callExtensions(metaList,object,ExtensionType.Method,methodName);

        return  result;
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

    /**
        Extend the IOC Container to add type information to other annotations used in your project.
        Returns an expression calling IV.addExtension with the meta name to look for.
    **/
    macro static public function extendIocTo ( expr : ExprOf<String>, 
                                               ?extension : ExprOf<ExtensionDef->Void>) : Expr 
    {
        var name = ExprTools.getValue(expr);

        iv247.intravenous.ioc.macros.IVMacro.metaNames.push(name);

        return macro  IV.addExtension(${expr}, ${extension});
    }

    /**
        Adds metadata that should be processed by the Injector.
    **/
    @:noCompletion
    public static function addExtension (metaname : String, func : ExtensionDef -> Void){
        if(extensionMap == null){
            extensionMap = new Map();
        }

        extensionMap.set(metaname,func);
    }

    /**
       Removes an extension from being processed for all IV instances
    **/
    public static function removeExtension (metaname : String) : Void {
        extensionMap.remove(metaname);
    }

    private function callExtensions(meta:Dynamic<Array<Dynamic>>, object:Dynamic, extensionType:ExtensionType,?fieldName:String) : Void {

        for(key in extensionMap.keys()){
            if(Reflect.hasField(meta,key)){
                extensionMap.get(key)({
                    meta : meta,
                    injector : this,
                    metaname : key,
                    object : object,
                    type : extensionType,
                    field : fieldName
                });
            }
        }  
    }   
}