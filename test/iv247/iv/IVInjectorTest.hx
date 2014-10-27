package iv247.iv;
import buddy.BuddySuite;

using buddy.Should;

class IVInjectorTest extends BuddySuite {
    public function new ( )
    {

        describe( 'IVInjector', {

            var iv:IVInjector = new IVInjector();

            before({
            iv = new IVInjector();
            });

            it ("should be able to tell if a mapping exists");

            it ("should be able to remove mappings");

            it ("should inject values as arguments for a method");

            it ("should inject values into a constructor");

            describe ("values", {
                it ("should be mapped to a type");
                it ("should be mapped to a type based on an id");
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
