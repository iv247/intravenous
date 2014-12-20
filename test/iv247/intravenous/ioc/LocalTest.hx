package iv247.intravenous.ioc;

import buddy.BuddySuite;
import iv247.intravenous.ioc.mock.MockEnum;
import iv247.intravenous.ioc.IInjector;
import iv247.intravenous.ioc.IV;

using buddy.Should;

class SandboxTest extends buddy.BuddySuite
{

	public function new() {

	 	@exclude
		describe('test suite',{
			var iv;

			before({
				iv = new IV();

				var test = iv.instantiate(iv247.intravenous.ioc.mock.InjectionMock);
				//iv.mapValue( classOrEnum : Unknown<0> , value : Unknown<1> , ?id : String )

				//var inj:iv247.iv.internal.Injectable
//				iv.mapValue( whenType : iv247.iv.internal.Injectable<Enum<Unknown<0>>, Class<Unknown<0>>> , value : Unknown<0> , ?id : String )
						//iv.mapValue( whenType : Dynamic , value : Dynamic , ?id : String )
				// iv.mapValue( whenType : Dynamic , value : Dynamic , ?id : String )
			});
			
		});
	}

}