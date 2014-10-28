package iv247.iv;

class IVInjector implements IInjector {

    private var classMap : Map<String, Dynamic>;

    public function new () {
        classMap = new Map();
    }

    public function mapValue<T> (whenType : Class<T>,
                                 value : T,
                                 ?id : String = "") : Void {
        classMap.set( Type.getClassName( whenType ) + id, value );
    }

    public function mapDynamic<T> (whenType : Class<T>,
                                   createType : Class<T>,
                                   ?id : String) : Void {

    }

    public function mapSingleton<T> (whenType : Class<T>,
                                     getInstance : Class<T>,
                                     ?id : String) : Void {

    }

    public function hasMapping<T> (type : Class<T>, ?id : String = "") : Bool {
        return classMap.exists( Type.getClassName( type ) + id );
    }

    public function unmap (type : Class<Dynamic>, ?id : String = "") : Void {
        classMap.remove( Type.getClassName( type ) + id );
    }

    public function getInstance<T> (type : Class<T>, ?id : String = "") : T {
        return classMap.get( Type.getClassName( type ) + id );
    }

    public function instantiate<T> (type : Class<T>) : T {
        return Type.createEmptyInstance( type );
    }

    public function injectInto (object : Dynamic) : Void {

    }

    public function call (methodName : String, object : Dynamic) : Dynamic {
        return null;
    }

}