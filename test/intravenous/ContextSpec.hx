package intravenous;

import intravenous.configuration.DefaultConfiguration;

using buddy.Should;

class ContextSpec extends buddy.BuddySuite
{

	public function new(){
		var context;
		var config;

		describe("Context",{
			beforeEach({
				context = null;
				config = new DefaultConfiguration();
			});

			it('should initialize on instantiation by default',{
				context = new Context(config);
				context.initialized.should.be(true);
			});

			it("should not initialize on instantiation", {
				context = new Context(config,false);
				context.initialized.should.not.be(true); 
			});
		});
	}
}
