package iv247.iv;

import iv247.iv.mock.MockExtensionObject;
import iv247.iv.ExtensionDef;
import iv247.IV;


using buddy.Should;

class ExtensionSpec extends buddy.BuddySuite {
	public function new(){
		describe("Extension functionality",{
			var iv,
				extensionDef,
				callCount = 0,
				extFn = function (extDef:iv247.iv.ExtensionDef){
					callCount++;
					extensionDef = extDef;
				};

			IV.extendIocTo("extension",extFn);
			IV.extendIocTo("extensionMethod",extFn);
		
			iv = new IV();
		
			before({
				callCount = 0;
				extensionDef = null;
				iv = new IV();
			});

			it("should call the extension's method for each annotated property of an instance",{
				var mock = new MockExtensionObject();

				iv.injectInto(mock);
				extensionDef.metaname.should.be("extension");
				extensionDef.type.should.be(ExtensionType.Property);
				callCount.should.be(2);
			});

			it("should call the extension's method if method being called is annotated", {
				var mock = new MockExtensionObject();
				var methodDef;

				iv.call("mockMethod",mock);
				extensionDef.metaname.should.be("extensionMethod");
			 	extensionDef.type.should.be(ExtensionType.Method);
			});

			it("should call the extensions's method if the constructor is annotated",{
				iv.instantiate(MockCtorExtensionObject);
				extensionDef.metaname.should.be("extension");
				extensionDef.type.should.be(ExtensionType.Constructor);
			});

		});
	}
}