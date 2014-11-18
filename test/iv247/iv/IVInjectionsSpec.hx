package iv247.iv;

import buddy.BuddySuite;
import iv247.iv.mock.*;

using buddy.Should;
class IVInjectionsTest extends BuddySuite {
    public function new() {
        describe("IV", {
            var iv = new IV();
            before({

            });

            it("should instantiate objects", {
                Foo.instantiated = false;
                iv.instantiate(Foo);
                Foo.instantiated.should.be(true);
            });

            it("should instantiate objects with constructor args when constructor is annotated with inject",{
                var object;

                iv.mapDynamic(MockObject,MockObject);
                
                object = iv.instantiate(MockConstructorArg);

                object.mock.should.not.be(null);
            });

            it("should use injections id's if available for constructor args");

            it("should inject properties into classes with properties annotated with inject");

            it("should use inject id on class properties if set");

            describe("calling inject annotated methods", {
                it("should have arguments injected");
                it("should use argument id's if set");
                it("should support optional arguments");
            });

            describe("mapped classes",{
                it("should have there 'inject' annoted properties injected");
                it("should use the property's inject id if set");
                it("should have constructor args injected when instantiated");
                it("should use constructor arg id's if set");
                it("should support optional arguments in the constructor");
            });
        });
    }
}
