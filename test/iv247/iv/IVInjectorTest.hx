package iv247.iv;
import buddy.BuddySuite;

import iv247.iv.mock.*;

using buddy.Should;

class IVInjectorTest extends BuddySuite {
    public function new ( )
    {

        describe( 'Iv', {

            var iv;

            before({
                iv = new IV();
            });

            it ("should be able to tell if a mapping exists", {
                iv.hasMapping(MockObject).should.be(false);

                iv.mapValue(MockObject, new MockObject());

                iv.hasMapping(MockObject).should.be(true);
            });

            it ("should be able to tell if a mapping with an id exists", {
                var id = "mockId";

                iv.mapValue(MockObject, new MockObject(),id);

                iv.hasMapping(MockObject).should.be(false);
                iv.hasMapping(MockObject,id).should.be(true);
            });

            it ("should be able to remove mappings", {
                iv.mapValue(MockObject, new MockObject());
                iv.unmap(MockObject);

                iv.hasMapping(MockObject).should.be(false);
            });

            it ("should be able to remove mappings with an id", {
                var id = "mockId";

                iv.mapValue(MockObject, new MockObject());
                iv.mapValue(MockObject, new MockObject(),id);

                iv.unmap(MockObject,id);

                iv.hasMapping(MockObject).should.be(true);
                iv.hasMapping(MockObject,id).should.be(false);
            });

            it ("should inject values as arguments for a method");

            it ("should inject values into a constructor");

            describe ("values", {
                it ("should be able to be mapped to a type", {
                    var mock = new MockObject();

                    iv.mapValue(MockObject, mock);

                    iv.getInstance(MockObject).should.be(mock);
                });

                it ("should be able to be mapped to a type based on an id", {
                     var mock = new MockObject(),
                         mockNoId = new MockObject();

                     iv.mapValue(MockObject,mock,"mymock");
                     iv.mapValue(MockObject,mockNoId);

                     mock.should.be( iv.getInstance(MockObject,"mymock") );
                     mockNoId.should.not.be( iv.getInstance(MockObject,"mymock") );
                });
            });

            describe ("dynamic types", {
                it ("should be able to be mapped to a compatible type", {
                    var mock;

                    iv.mapDynamic(IMockObject,MockObject);
                    mock = iv.getInstance(IMockObject);

                    Std.is(mock,IMockObject).should.be( true );
                });

                it ("should be able to be mapped to a compatible type based on an id", {
                    var mock, foo;

                    iv.mapDynamic(IMockObject,Foo);
                    iv.mapDynamic(IMockObject,MockObject,"mockId");

                    mock = iv.getInstance(IMockObject,"mockId");
                    foo = iv.getInstance(IMockObject);

                    Std.is(mock,MockObject).should.be( true );
                    Std.is(foo,Foo).should.be( true );
                });

                it ("should be able to be instantiated on every request", {
                    var mock, mock2, foo, foo2;

                    iv.mapDynamic(IMockObject,Foo);
                    iv.mapDynamic(IMockObject,MockObject,"mockId");

                    mock = iv.getInstance(IMockObject,"mockId");
                    mock2 = iv.getInstance(IMockObject,"mockId");
                    foo = iv.getInstance(IMockObject);
                    foo2 = iv.getInstance(IMockObject);

                    mock.should.not.be(mock2);
                    foo.should.not.be(foo2);
                });

                it ("should have their inject annotated properties injected");
            });

            describe ("singleton types", {
                it ("should map to a compatible type",{
                     var mock;
                     iv.mapSingleton(IMockObject, MockObject);
                     mock = iv.getInstance(IMockObject);
                     Std.is(mock,IMockObject).should.be(true);
                });

                it ("should map to a compatible type based on an id", {
                    var mock, foo;
                    iv.mapSingleton(IMockObject, MockObject,"mock");
                    iv.mapSingleton(IMockObject, Foo,"foo");
                    mock = iv.getInstance(IMockObject,"mock");
                    foo = iv.getInstance(IMockObject,"foo");

                    Std.is(mock,MockObject).should.be(true);
                    Std.is(foo,Foo).should.be(true);
                });
                it ("should be lazy loaded");
                it ("should be the same instance on every request");
                it ("should have their properties injected only once");
            });

        });

    }
}
