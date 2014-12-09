package iv247.iv;

import buddy.BuddySuite;
import iv247.iv.mock.MockEnum;
import iv247.iv.mock.InjectionMock;
import iv247.iv.mock.InjectionMockWEnum;
import iv247.IV;

using buddy.Should;
class IVEnumSupportSpec extends BuddySuite
{
	public function new(){
		var iv;

		before({
			iv = new IV();
		});
		
		describe("IV Enums",{
			it("should be mapped by type",{
	           iv.mapValue(MockEnum, MockEnum.MockEnumValue);
	           iv.hasMapping(MockEnum).should.be(true);
	        });

	        it("should umap enums", {
	        	iv.mapValue(MockEnum, MockEnum.MockEnumValue);
	        	iv.unmap(MockEnum);
	            iv.hasMapping(MockEnum).should.be(false);
	        });

	        it("should create an enum value without constructor", {
	        	var mockEnum = iv.instantiate(MockEnum,"MockEnumValue");
	        	mockEnum.should.be( MockEnum.MockEnumValue );
	        });

	        it("should create enum and inject constructor values",{
	        	var obj1 = new InjectedObject(),
	        		mockEnum;

	        	iv.mapValue(InjectedObject,obj1,"injectedObjectId");
	        	iv.mapDynamic(InjectedObject,InjectedObject);

	        	mockEnum = iv.instantiate(MockEnum,"MockEnumCtor");

	        	switch(mockEnum){
	        		case MockEnum.MockEnumCtor(i1,i2,i3):
	        			i1.should.be(obj1);
	        			Std.is(i2,InjectedObject).should.be(true);
	        			i3.should.be(null);
	        		default:
	        	}
	        });

	        it("should be injected into objects that have enum anotated with inject",{
	        	var mockEnum, injectionMockWithEnum, mockEnumWCtor;

	        	iv.mapValue(MockEnum, MockEnum.MockEnumValue);
	        	iv.mapDynamic(InjectionMockWEnum,InjectionMockWEnum);

	        	iv.mapSingleton(MockEnum,MockEnum,"injectEnumCtorId","MockEnumCtor");
	        	
	        	injectionMockWithEnum = iv.getInstance(InjectionMockWEnum);

	        	mockEnumWCtor = iv.getInstance(MockEnum,"injectEnumCtorId");

	        	injectionMockWithEnum.enumCtor.should.be(mockEnumWCtor);
	        	Std.is(injectionMockWithEnum.enumValue,MockEnum).should.be(true);
	        });

	        it("should inject enums into class constructors",{
	        	var injectionMockWithEnum, mockEnumWCtor;

	        	iv.mapDynamic(InjectionMockWEnum,InjectionMockWEnum);
	        	iv.mapSingleton(MockEnum,MockEnum,"injectEnumCtorId","MockEnumCtor");

	        	injectionMockWithEnum = iv.getInstance(InjectionMockWEnum);
	        	mockEnumWCtor = iv.getInstance(MockEnum,"injectEnumCtorId");

	        	injectionMockWithEnum.enumCtor.should.be(mockEnumWCtor);
	        });

		});

	}
	

}