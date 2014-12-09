package iv247.iv;

import iv247.iv.internal.Injectable;

interface IInjector {

    function mapDynamic<T> ( 
    	whenType:Injectable<Enum<T>, Class<T>>, 
    	typeToCreate:Injectable<Enum<T>, Class<T>>, 
    	?id:String, 
    	?enumCtor:String 
    ):Void;

    function mapSingleton<T> (
    	whenType:Injectable<Enum<T>, Class<T>>, 
    	instanceType:Injectable<Enum<T>, Class<T>>, 
    	?id : String, 
    	?enumCtor : String
    ):Void;

    function mapValue<T> ( whenType:Class<T>, value:T, ?id:String ):Void;

    function unmap<T> ( type : Injectable<Enum<T>, Class<T>>, ?id:String ):Void;

    function getInstance<T> ( type:Injectable<Enum<T>, Class<T>>,?id:String ):T;

    function instantiate<T> ( type:Injectable<Enum<T>, Class<T>>,?constr:String ):T;

    function injectInto ( object:Dynamic ):Void;

    function call ( methodName:String, object:Dynamic ): Dynamic;
}
