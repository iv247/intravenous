package intravenous.ioc;
import buddy.BuddySuite;
import intravenous.ioc.mock.*;
import intravenous.ioc.IV;


using buddy.Should;

class MappingSpec extends BuddySuite {
    public function new ( )
    {

        describe("IInjector implementations", {

            var iv;

            beforeEach({
                iv = new IV();
            });

            it ("should tell if a mapping exists", {
                iv.hasMapping(MockObject).should.be(false);

                iv.mapValue(MockObject, new MockObject());

                iv.hasMapping(MockObject).should.be(true);
            });

            it ("should tell if a mapping with an id exists", {
                var id = "mockId";

                iv.mapValue(MockObject, new MockObject(),id);

                iv.hasMapping(MockObject).should.be(false);
                iv.hasMapping(MockObject,id).should.be(true);
            });

            it ("should remove mappings", {
                iv.mapValue(MockObject, new MockObject());
                iv.unmap(MockObject);

                iv.hasMapping(MockObject).should.be(false);
            });

            it ("should remove mappings with an id", {
                var id = "mockId";

                iv.mapValue(MockObject, new MockObject());
                iv.mapValue(MockObject, new MockObject(),id);

                iv.unmap(MockObject,id);

                iv.hasMapping(MockObject).should.be(true);
                iv.hasMapping(MockObject,id).should.be(false);
            });

            describe ("values", {
                it ("should be mapped to a type", {
                    var mock = new MockObject();

                    iv.mapValue(MockObject, mock);

                    mock.should.be(iv.getInstance(MockObject));
                });

                it ("should be mapped to a type based on an id", {
                     var mock = new MockObject(),
                         mockNoId = new MockObject();

                     iv.mapValue(MockObject,mock,"mymock");
                     iv.mapValue(MockObject,mockNoId);

                     mock.should.be( iv.getInstance(MockObject,"mymock") );
                     mockNoId.should.not.be( iv.getInstance(MockObject,"mymock") );
                });
            });

            describe ("transient types", {

                it ("should be mapped to a compatible type", {
                    var mock;

                    iv.mapTransient(IMockObject,MockObject);
                    mock = iv.getInstance(IMockObject);

                    Std.is(mock,IMockObject).should.be( true );
                });

                it ("should be mapped to a compatible type based on an id", {
                    var mock, foo;

                    iv.mapTransient(IMockObject,Foo);
                    iv.mapTransient(IMockObject,MockObject,"mockId");

                    mock = iv.getInstance(IMockObject,"mockId");
                    foo = iv.getInstance(IMockObject);

                    Std.is(mock,MockObject).should.be( true );
                    Std.is(foo,Foo).should.be( true );
                });

                it ("should be instantiated on every request", {
                    var mock, mock2, foo, foo2;

                    iv.mapTransient(IMockObject,Foo);
                    iv.mapTransient(IMockObject,MockObject,"mockId");

                    mock = iv.getInstance(IMockObject,"mockId");
                    mock2 = iv.getInstance(IMockObject,"mockId");
                    foo = iv.getInstance(IMockObject);
                    foo2 = iv.getInstance(IMockObject);

                    (mock == mock2).should.not.be(true);
                    (foo == foo2).should.be(false);
                });

            });

            describe ("persistent types", {
                it ("should map to a compatible type",{
                     var mock;
                     iv.mapPersistent(IMockObject, MockObject);
                     mock = iv.getInstance(IMockObject);
                     Std.is(mock,IMockObject).should.be(true);
                });

                it ("should map to a compatible type based on an id", {
                    var mock, foo;
                    iv.mapPersistent(IMockObject, MockObject,"mock");
                    iv.mapPersistent(IMockObject, Foo,"foo");
                    mock = iv.getInstance(IMockObject,"mock");
                    foo = iv.getInstance(IMockObject,"foo");

                    Std.is(mock,MockObject).should.be(true);
                    Std.is(foo,Foo).should.be(true);
                });

                it ("should be lazy loaded", {
                    var foo;

                    Foo.instantiated = false;

                    iv.mapPersistent(Foo, Foo);
                    foo = iv.getInstance(Foo);
                    Foo.instantiated.should.be(true);
                });

                it ("should be the same instance on every request", {
                    var foo:Foo;

                    iv.mapPersistent(Foo, Foo);
                    foo = iv.getInstance(Foo);
                    foo.should.be(iv.getInstance(Foo)); 
                });

            });

        });

    }
}
