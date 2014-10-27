package iv247.iv;
interface IInjector {

    function mapDynamic<T> ( whenType : Class<T>, typeToCreate : Class<T>, ?id : String) : Void;

    function mapSingleton<T> ( whenType : Class<T>, instanceType : Class<T>, ?id : String ) : Void;

    function mapValue<T> ( whenType : Class<T>, value : T, ?id : String ) : Void;

    function getInstance<T> (  object : Class<T> ) : T;

    function getInstanceById ( id : String ) : Dynamic;

    function injectInto ( object : Dynamic ) : Void;

    function call ( methodName : String, object : Dynamic ) : Dynamic;
}
