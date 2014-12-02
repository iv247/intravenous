package iv247.iv;

import iv247.iv.mock.MockExtensionObject;
import iv247.iv.ExtensionDef;

using buddy.Should;

class IVExtensionSpec extends buddy.BuddySuite {
	public function new(){
		describe("IV extension functionality",{
			var iv,
				def,
				callCount = 0,
				extFn = function (extDef:iv247.iv.ExtensionDef){
					callCount++;
					def = extDef;
				};

			IV.extendIocTo("extension",extFn);
			
			iv = new IV();
			// iv.test(iv247.iv.mock.InjectionMock,new iv247.iv.mock.InjectionMock());	
			// iv.test(ExtensionType,ExtensionType.Property);

			before({
				callCount = 0;
				iv = new IV();
			});

			it("should call the extension's method for each annotated property of an instance",{
			 IV.extendIocTo("extensionMethod",extFn);

				var mock = new MockExtensionObject();

				iv.injectInto(mock);
				callCount.should.be(2);
			});

			it("should call the extension's method if method being called is annotated", {
				var obj = new iv247.iv.mock.InjectionMock.InjectedObject();
				var mock = new MockExtensionObject();
				var methodDef;

				var method = function (extDef:iv247.iv.ExtensionDef){
					methodDef = extDef;
					trace(extDef);
				};

				IV.extendIocTo("extensionMethod",method);

				iv.injectInto(mock);
				iv.mapValue( iv247.iv.mock.InjectionMock.InjectedObject , obj );
				iv.call("mockMethod",mock);
				
			 	methodDef.type.should.be(ExtensionType.Method);

			});

			it("should call the extensions's method if the constructor is annotated",{
				iv.instantiate(MockCtorExtensionObject);
				def.type.should.be(ExtensionType.Constructor);
			});

		});
	}
}