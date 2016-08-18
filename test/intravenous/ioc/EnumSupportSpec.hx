 package intravenous.ioc;

import buddy.BuddySuite;
import intravenous.ioc.mock.MockEnum;
import intravenous.ioc.mock.InjectionMock;
import intravenous.ioc.mock.InjectionMockWEnum;
import intravenous.ioc.IV;

using buddy.Should;
class EnumSupportSpec extends BuddySuite
{
	public function new(){
		var iv;

		beforeEach({
			iv = new IV();
		});
		
		describe("Enums",{
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
	        	var mockEnum:MockEnum = iv.instantiate(MockEnum,"MockEnumValue");
	        	mockEnum.should.equal( MockEnum.MockEnumValue );
	        });

	        it("should create enum and inject constructor values",{
	        	var obj1 = new InjectedObject(),
	        		mockEnum;

	        	iv.mapValue(InjectedObject,obj1,"injectedObjectId");
	        	iv.mapTransient(InjectedObject,InjectedObject);

	        	mockEnum = iv.instantiate(MockEnum,"MockEnumCtor");
	        	
	        	switch(mockEnum){
	        		case MockEnum.MockEnumCtor(i1,i2,i3):
	        			i1.should.be(obj1);
	        			Std.is(i2,InjectedObject).should.be(true);
	        			i3.should.equal(null);
	        		default: throw "enum not matched";
	        	}
	        });

	        it("should be injected into objects that have enum anotated with inject",{
	        	var mockEnum, injectionMockWithEnum:InjectionMockWEnum, mockEnumWCtor;

	        	iv.mapValue(MockEnum, MockEnum.MockEnumValue);
	        	iv.mapTransient(InjectionMockWEnum,InjectionMockWEnum);

	        	iv.mapPersistent(MockEnum,MockEnum,"injectEnumCtorId","MockEnumCtor");
	        	
	        	injectionMockWithEnum = iv.getInstance(InjectionMockWEnum);

	        	mockEnumWCtor = iv.getInstance(MockEnum,"injectEnumCtorId");

	        	injectionMockWithEnum.enumCtor.should.equal(mockEnumWCtor);
	        	Std.is(injectionMockWithEnum.enumValue,MockEnum).should.be(true);
	        });

	        it("should inject enums into class constructors",{
	        	var injectionMockWithEnum:InjectionMockWEnum, mockEnumWCtor;

	        	iv.mapTransient(InjectionMockWEnum,InjectionMockWEnum);
	        	iv.mapPersistent(MockEnum,MockEnum,"injectEnumCtorId","MockEnumCtor");

	        	injectionMockWithEnum = iv.getInstance(InjectionMockWEnum);
	        	mockEnumWCtor = iv.getInstance(MockEnum,"injectEnumCtorId");

	        	injectionMockWithEnum.enumCtor.should.equal(mockEnumWCtor);
	        });

		});

	}
	

}