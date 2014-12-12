package iv247.iv;

using buddy.Should;

class NestedInjectionSpec extends buddy.BuddySuite
{	
	public var iv:IInjector;

	public function new(){
		describe("Nested injectors",{
			var iv;
			before({
				iv = new IV();
			});
			it("should optionally be added through the constructor");
			it("should be added from the injector's api");
			it("should be removable");
			it("should be retrievable");
			it("should return unmapped objects from their parents");		
		});
	}
}