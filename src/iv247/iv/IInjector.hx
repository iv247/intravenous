package iv247.iv;

import iv247.iv.internal.Injectable;

interface IInjector {
    
    /**
        IInjector to be referenced as a parent instance to the current instance of an IInjector
    **/
    var parent (default,set) : IInjector;

    /**
        Map a type of class or enum to be created each time it's type is requested for injection 
    **/
    function mapDynamic<T> ( 
    	whenType:Injectable<Enum<T>, Class<T>>, 
    	typeToCreate:Injectable<Enum<T>, Class<T>>, 
    	?id:String, 
    	?enumCtor:String 
    ):Void;

    /**
        Map a type of class or enum to be created and persisted  after the first request for injection
    **/
    function mapSingleton<T> (
    	whenType:Injectable<Enum<T>, Class<T>>, 
    	instanceType:Injectable<Enum<T>, Class<T>>, 
    	?id : String, 
    	?enumCtor : String
    ):Void;

    /**
        Map an Object or Enum Value to a compatible type
    **/
    function mapValue<T> ( whenType:Injectable<Enum<T>, Class<T>>, value:T, ?id:String ):Void;

    /**
        Unmap a Class or Enum type in the Injector
    **/
    function unmap<T> ( type : Injectable<Enum<T>, Class<T>>, ?id:String ):Void;

    /**
        Retrive and instance of a Class or Enum that has been mapped
    **/
    function getInstance<T> ( type:Injectable<Enum<T>, Class<T>>,?id:String ):T;

    /**
        Instantiate a Class or Enum not mapped in a IInjector implementation
    **/
    function instantiate<T> ( type:Injectable<Enum<T>, Class<T>>,?constr:String ):T;

    /**
        Inject values into an object with properties annotated with @inject
    **/
    function injectInto ( object:Dynamic ):Void;

    /**
        Call a method  annotated with inject that will retrieve the arguments from
        the injector.
    **/
    function call ( methodName:String, object:Dynamic ): Dynamic;

}
