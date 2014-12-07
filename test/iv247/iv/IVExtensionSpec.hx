package iv247.iv;

import iv247.iv.mock.MockExtensionObject;
import iv247.iv.ExtensionDef;

using buddy.Should;

class IVExtensionSpec extends buddy.BuddySuite {
	public function new(){
		@include
		describe("IV extension functionality",{
			var iv,
				extensionDefinition,
				callCount = 0,
				extFn = function (extDef:iv247.iv.ExtensionDef){
					callCount++;
					extensionDefinition = extDef;
				};

			IV.extendIocTo("extension",extFn);
			IV.extendIocTo("extensionMethod",extFn);
			
			iv = new IV();
			// iv.test(iv247.iv.mock.InjectionMock,new iv247.iv.mock.InjectionMock());	
			// iv.test(ExtensionType,ExtensionType.Property);

			before({
				callCount = 0;
				extensionDefinition =null;
				iv = new IV();
			});

			it("should call the extension's method for each annotated property of an instance",{
				var mock = new MockExtensionObject();

				iv.injectInto(mock);
				callCount.should.be(2);
				extensionDefinition.metaname.should.be("extension");
				extensionDefinition.type.should.be(ExtensionType.Property);
			});

			it("should call the extension's method if method being called is annotated", {
				var mock = new MockExtensionObject();
				var methodDef;

				iv.call("mockMethod",mock);
				extensionDefinition.metaname.should.be("extensionMethod");
			 	extensionDefinition.type.should.be(ExtensionType.Method);
			});

			it("should call the extensions's method if the constructor is annotated",{
				iv.instantiate(MockCtorExtensionObject);
				extensionDefinition.type.should.be(ExtensionType.Constructor);
			});

		});
	}
}