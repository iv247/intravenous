
package iv247.intravenous.messaging;

import iv247.intravenous.messaging.MessageProcessor;
import iv247.IV;
import iv247.iv.IInjector;
import iv247.intravenous.messaging.mock.MockCommand;

using buddy.Should;
class MessagingSpec extends buddy.BuddySuite
{

	public var processor:MessageProcessor;
	public var injector : IInjector;

	public function new(){
		describe("Messaging", {
			

			before({
				injector = new IV();
				processor = new MessageProcessor(injector);
			});

			describe("command classes",{
				it("should be instantiated for each request",{
					processor.mapCommand(MockCommand);
				});

				it("should the method annotated with @execute");	
				it("should be asynchonous if execute method returns a promise");	
				it("should be asynchonous if execute method returns a value");	
			});

			describe("intercepts", {
				it("should be executed before commands");
				it("should be executed before messages");
				it("should be able to be asynchronous");
				it("should be able to stop notification flow");
			});
			
			
			describe("asynchronous commands",{

			});
			describe("command results",{
			});
		});
	}

}