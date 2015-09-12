package intravenous.ioc;

import buddy.BuddySuite;
import intravenous.ioc.mock.MockEnum;
import intravenous.ioc.IInjector;
import intravenous.ioc.IV;

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