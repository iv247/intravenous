package iv247.iv;

import iv247.iv.mock.MockExtensionObject;
import iv247.iv.ExtensionDef;

using buddy.Should;

class IVExtensionSpec extends buddy.BuddySuite {
	public function new(){
		describe("IV Extensions",{
			var iv,
				def,
				callCount = 0,
				extFn = function (extDef:iv247.iv.ExtensionDef){
					callCount++;
					def = extDef;
				}; 

			IV.addTypeMetaTo("extension",extFn);

			before({
				callCount = 0;
				iv = new IV();
			});

			it("should call the extensions method for each annotated property of an instance",{
				var mock = new MockExtensionObject();

				iv.injectInto(mock);
				callCount.should.be(2);
			});

			it("should call the extension's method if method being called is annotated", {
				
			});

			it("should call the extensions's method if the constructor is annotated",{
				iv.instantiate(MockCtorExtensionObject);
				def.type.should.be(ExtensionType.Constructor);
			});

			it("should add type meta to custom meta names");

		});
	}
}