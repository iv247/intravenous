package iv247.iv;
import buddy.BuddySuite;

import iv247.iv.mock.TestObject;

using buddy.Should;

class IVInjectorTest extends BuddySuite {
    public function new ( )
    {

        describe( 'IVInjector', {

            var iv;

            before({
                iv = new IVInjector();
            });

            it ("should be able to tell if a mapping exists", {
                iv.hasMapping(TestObject).should.be(false);

                iv.mapValue(TestObject, new TestObject());

                iv.hasMapping(TestObject).should.be(true);
            });

            it ("should be able to remove mappings", {
                iv.mapValue(TestObject, new TestObject());
                iv.unmap(TestObject);

                iv.hasMapping(TestObject).should.be(false);
            });

            it ("should inject values as arguments for a method");

            it ("should inject values into a constructor");

            describe ("values", {
                it ("should be mapped to a type", {
                    var testObject = new TestObject();

                    iv.mapValue(TestObject, testObject);

                    iv.getInstance(TestObject).should.be(testObject);
                });

                it ("should be mapped to a type based on an id", {

                });
            });

            describe ("types", {
                it ("should be mapped to a compatible type");
                it ("should be mapped to a compatible type based on an id");
                it ("should have their properties injected");
            });

            describe ("singleton types", {
                it ("should be mapped to a compatible type");
                it ("should be mapped to a compatible type based on an id");
                it ("should be lazy loaded");
                it ("should be the same instance on every request");
                it ("should have their properties injected only once");
            });

        });

    }
}
