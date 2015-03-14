
package iv247.intravenous.messaging;

import iv247.intravenous.messaging.MessageProcessor;
import iv247.intravenous.ioc.IV;
import iv247.intravenous.ioc.IInjector;
import iv247.intravenous.messaging.mock.MockCommand;
import iv247.intravenous.messaging.mock.Message;
import iv247.intravenous.messaging.mock.*;

using buddy.Should;
@:access(iv247.intravenous.messaging.MessageProcessor)
class MessagingSpec extends buddy.BuddySuite
{

	public var processor: MessageProcessor;
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

			describe("objects with command methods", {
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
			});

			describe("command classes",{
				var message;

				before({
					message = new Message();
					processor.mapCommand(MockCommand);
				});

				it("should be instantiated on each dispatch",{
					processor.dispatch(message);
					processor.dispatch(message);
					MockCommand.count.should.be(2);
				});

				it("should call the execute method",{
					processor.dispatch(message);
					MockCommand.message.should.be(message);
				});

				it("should remove command class",{
					processor.removeCommand(MockCommand);
					processor.dispatch(message);
					MockCommand.count.should.be(0);
					MockCommand.message.should.not.be(message);
				});				

 				it("should be asynchonous if execute method returns a promise");	
				it("should be asynchonous if execute method returns a value");	
			});

			describe("interceptor", {
				it("should be executed before commands");
				it("should be executed before commandResults");
				it("should be able to be asynchronous");
				it("should be able to stop notification flow", {
					var message = new Message();
					processor.mapCommand(CommandInterceptor);
					processor.mapCommand(MockCommand);
					processor.dispatch(message);
					MockCommand.message.should.not.be(message);
				});
				it("should be able to resume notification flow", {
					var message = new Message();
					processor.mapCommand(CommandInterceptor);
					processor.mapCommand(MockCommand);
					processor.dispatch(message);
					MockCommand.message.should.not.be(message);
					processor.openSequencers[0].continueSequence();
					MockCommand.message.should.be(message);
				});
			});
			
			
			describe("asynchronous commands",{

			});
			
			describe("result command",{
				it("should be executed after commands");
				it("should be executed after interceptors");
			});
		});
	}

}