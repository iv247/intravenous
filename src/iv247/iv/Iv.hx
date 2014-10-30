package iv247.iv;

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
                                     ?id : String) : Void {
    }

    public function hasMapping<T> (type : Class<T>, ?id : String = "") : Bool {
        return classMap.exists( Type.getClassName( type ) + id );
    }

    public function unmap (type : Class<Dynamic>, ?id : String = "") : Void {
        classMap.remove( Type.getClassName( type ) + id );
    }

    public function getInstance<T> (type : Class<T>, ?id : String = "") : T {
        var injection = Type.getClassName( type ) + id,
            instance;

        instance =
        switch(classMap.get(injection)) {
            case Injection.Value(object) :
                object;

            case Injection.DynamicObject(type) :
                Type.createEmptyInstance(type);

            case Injection.Singleton(type,object) :
                if(object != null){
                   object;
                }else{
                   object =Type.createEmptyInstance(type);
                   mapValue(type,object,id);
                }
                object;
        }

        return instance;
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