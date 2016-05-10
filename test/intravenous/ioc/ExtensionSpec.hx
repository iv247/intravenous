package intravenous.ioc;

import intravenous.ioc.mock.MockExtensionObject;
import intravenous.ioc.ExtensionDef;
import intravenous.ioc.IV;


using buddy.Should;

class ExtensionSpec extends buddy.BuddySuite {
	public function new(){
		describe("Extension functionality",{
			var iv,
				extensionDef,
				extensionMethodDef,
				callCount = 0,
				extFn = function (extDef:intravenous.ioc.ExtensionDef){
					callCount++;
					extensionDef = extDef;
				},
				extFn2 = function (extDef:intravenous.ioc.ExtensionDef){
					extensionMethodDef = extDef;
				}

			IV.extendIocTo("extension",extFn);
			IV.extendIocTo("extensionMethod",extFn2);

			beforeEach({
				callCount = 0;
				extensionDef = null;
				extensionMethodDef = null;
				iv = new IV();
			});

			it("should call the extension's method for each annotated property of an instance",{
				var mock = new MockExtensionObject();

				iv.injectInto(mock);
				extensionDef.metaname.should.be("extension");
				extensionDef.type.should.equal(ExtensionType.Property);
				extensionMethodDef.metaname.should.be("extensionMethod");
				extensionMethodDef.type.should.equal(ExtensionType.Property);
				callCount.should.be(2);
			});

			it("should call the extension's method if method being called is annotated", {
				var mock = new MockExtensionObject();
				var methodDef;

				iv.call("mockMethod",mock);
				extensionMethodDef.metaname.should.be("extensionMethod");
			 	extensionMethodDef.type.should.equal(ExtensionType.Method);
			});

			it("should call the extensions's method if the constructor is annotated",{
				iv.instantiate(MockCtorExtensionObject);
				extensionDef.metaname.should.be("extension");
				extensionDef.type.should.equal(ExtensionType.Constructor);
			});

		});
	}
}