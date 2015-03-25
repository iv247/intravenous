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
			

			});
			
		});
	}

}