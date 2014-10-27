package iv247.iv;

class IVInjector implements IInjector {

    private var classMap : Map<String, Class<Dynamic>>;

    public function new ()
    {
        classMap = new Map();
    }

    public function mapValue<T> (whenType : Class<T>, value : T, ?id : String) : Void
    {

    }

    public function mapDynamic<T> (whenType : Class<T>, createType : Class<T>, ?id : String) : Void
    {

    }

    public function mapSingleton<T> (whenType : Class<T>, getInstance : Class<T>, ?id : String) : Void
    {

    }

    public function getInstance<T> (type : Class<T>) : T
    {
        return Type.createEmptyInstance( type );
    }

    public function getInstanceById (id : String) : Dynamic
    {
        return null;
    }

    public function instantiate<T> (type : Class<T>) : T
    {
        return Type.createEmptyInstance( type );
    }

    public function injectInto (object : Dynamic) : Void
    {

    }

    public function call (methodName : String, object : Dynamic) : Dynamic
    {
        return null;
    }

}