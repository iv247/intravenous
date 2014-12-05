package iv247.iv;

import buddy.BuddySuite;
import iv247.iv.mock.MockEnum;

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
	           iv.mapEnum(MockEnum, MockEnum.MockEnumValue);
	           iv.hasMapping(MockEnum).should.be(true);
	           MockEnum.MockEnumCtor(null,null);
	        });

	        it("should be injected into objects that have enum anotated with inject");

	        it("should inject constructor values",{
	        	//iv.createEnum(MockEnum.MockEnumCtor);
	        });

		});

	}
	

}