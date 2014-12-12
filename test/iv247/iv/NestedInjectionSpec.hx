package iv247.iv;

using buddy.Should;

class NestedInjectionSpec extends buddy.BuddySuite
{	
	public var iv:IInjector;

	public function new(){
		describe("Child injectors",{
			var iv;
			before({
				iv = new IV();
			});
			it("should optionally add a parent injector through it's constructor");
			it("should add a parent through it's api");
			it("should remove there parent");
			it("should make their parent accessible");
			it("should return unmapped objects from their parents");		
		});
	}
}