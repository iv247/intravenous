
package iv247.intravenous.messaging;

import iv247.intravenous.messaging.MessageProcessor;
import iv247.IV;
import iv247.iv.IInjector;
import iv247.intravenous.messaging.mock.MockCommand;
import iv247.intravenous.messaging.mock.Message;

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
				MockCommand.count = 0;
				IV.extendIocTo('command',processor.processMeta);
				IV.extendIocTo('commandResult',processor.processMeta);
			});

			describe("command classes",{
				it("should be instantiated on each dispatch",{
					var message = new Message();
					processor.mapCommand(MockCommand);
					processor.dispatch(message);
					processor.dispatch(message);
					MockCommand.count.should.be(2);
				});

				it("should call the execute method",{
					var message = new Message();
					processor.mapCommand(MockCommand);
					processor.dispatch(message);
					MockCommand.message.should.be(message);
				});

				it("should remove command class",{
					var message = new Message();
					processor.mapCommand(MockCommand);
					processor.removeCommand(MockCommand);
					processor.dispatch(message);
					MockCommand.count.should.be(0);
					MockCommand.message.should.not.be(message);
				});

				it("should call methods annotated with command", {
					var message = new Message();
					injector.mapDynamic(iv247.intravenous.messaging.mock.MockController,iv247.intravenous.messaging.mock.MockController );
					var mock = injector.instantiate( iv247.intravenous.messaging.mock.MockController  );
					processor.dispatch(message);
					message.commandCalled.should.be(true);
				});

				it("should remove objects waiting for dispatched objects",{
					var message = new Message(),
						mock; 

					injector.mapDynamic(iv247.intravenous.messaging.mock.MockController,iv247.intravenous.messaging.mock.MockController );
					mock = injector.instantiate( iv247.intravenous.messaging.mock.MockController  );					
					processor.deregister(mock);
					processor.dispatch(message);

					message.commandCalled.should.not.be(true);
				});

 				it("should be asynchonous if execute method returns a promise");	
				it("should be asynchonous if execute method returns a value");	
			});

			describe("intercepts", {
				it("should be executed before commands");
				it("should be executed before commandResults");
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