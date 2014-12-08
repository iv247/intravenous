package iv247.iv;
interface IInjector {

    function mapDynamic<T> ( whenType:Class<T>, typeToCreate:Class<T>, ?id:String, ?enumCtor:String ):Void;

    function mapSingleton<T> (whenType:Class<T>, instanceType:Class<T>, ?id:String, ?enumCtor:String):Void;

    function mapValue<T>(whenType:Class<T>, value:T, ?id:String):Void;

    function unmap (type:Class<Dynamic>, ?id:String):Void;

    function getInstance<T>(type:Class<T>,?id:String):T;

    function instantiate<T>(type:Class<T>,?constr:String):T;

    function injectInto (object:Dynamic):Void;

    function call (methodName:String, object:Dynamic): Dynamic;
}
