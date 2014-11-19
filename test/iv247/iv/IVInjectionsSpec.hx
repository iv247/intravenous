package iv247.iv;

import buddy.BuddySuite;
import iv247.iv.mock.*;
import iv247.iv.mock.MockConstructorArg;
import iv247.iv.mock.InjectionMock;

using buddy.Should;
class IVInjectionsTest extends BuddySuite {
    public function new() {
        describe("IV", {
            var iv;

            before({
                iv = new IV();
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

            it("should use injections id's if available for constructor args", {
                var mock1, mock2, object;

                iv.mapSingleton(MockObject,MockObject,"mockId");
                iv.mapSingleton(MockObject,MockObject,"mockId2");

                mock1 = iv.getInstance(iv247.iv.mock.MockObject,"mockId");
                mock2 = iv.getInstance(iv247.iv.mock.MockObject,"mockId2");

                object = iv.instantiate(WithId);

                object.mockWithId.should.be(mock1);
                object.mockWithId2.should.be(mock2);
                object.noId.should.be(null);
            });

            it("should inject 'inject' annotated properties on an object if mapping exists",{
                var object = new InjectionMock();

                iv.mapDynamic(InjectedObject,InjectedObject);
                iv.injectInto(object);

                object.injectedObject.should.not.be(null);
                //mapping not created
                object.injectedObjectWithId.should.be(null);
            });

            it("should inject 'inject' annotated properties with an id", {
                var object = new InjectionMock();

                iv.mapDynamic(InjectedObject,InjectedObject,"injectedObjectId");
                iv.injectInto(object);

                object.injectedObjectWithId.should.not.be(null);
            });

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
