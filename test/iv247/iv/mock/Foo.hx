package iv247.iv.mock;

class Foo implements IMockObject {

    public static var instantiated : Bool;

    public var post : String;

    public function new(){

        Foo.instantiated = true;
    }
}