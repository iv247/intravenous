package iv247.intravenous;

using buddy.Should;

class ContextSpec extends buddy.BuddySuite
{

	public function new(){
		var context;

		describe("Context",{
			before({
				context = null;

			});

			it('should initialize on instantiation by default',{
				context = new Context();
				context.initialized.should.be(true);
							});

			it("should not initialize on instantiation", {
				context = new Context(false);
				context.initialized.should.not.be(true);

			});

		});
	}


}
