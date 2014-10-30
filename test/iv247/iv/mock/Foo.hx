package iv247.iv.mock;

class Foo implements IMockObject {

    public static var instantiated : Bool;

    public function new(){

        Foo.instantiated = true;
    }
}