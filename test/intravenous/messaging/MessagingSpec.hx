package intravenous.messaging;

import intravenous.messaging.MessageProcessor;
import intravenous.ioc.IV;
import intravenous.ioc.IInjector;
import intravenous.messaging.mock.MockCommand;
import intravenous.messaging.mock.Message;
import intravenous.messaging.mock.*;
import intravenous.messaging.mock.MockCommandOrder;
import intravenous.messaging.mock.FullMessageFlow;

using buddy.Should;
@:access(intravenous.messaging.MessageProcessor)
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
				IV.extendIocTo('commandComplete',processor.processMeta);
			});

			describe("objects with command methods", {
				it("should call methods annotated with command", {
					var message = new Message();
					injector.mapDynamic(intravenous.messaging.mock.MockController,intravenous.messaging.mock.MockController );
					var mock = injector.instantiate( intravenous.messaging.mock.MockController  );
					processor.dispatch(message);
					message.commandCalled.should.be(true);

				});

				it("should remove objects waiting for dispatched objects",{
					var message = new Message(),
						mock;

					injector.mapDynamic(intravenous.messaging.mock.MockController,intravenous.messaging.mock.MockController );
					mock = injector.instantiate( intravenous.messaging.mock.MockController  );
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

				describe("execution order",{
					before({
						var mock = injector.instantiate(MockCommandOrder);

						message = new Message();
						message.commandStack = [];
						injector.mapValue(MockCommandOrder,mock);

						processor.mapCommand(MockCommandOrderInterceptor);
						processor.mapCommand(MockCommandOrderCommand);

						processor.dispatch(message);
					});
					it("should execute interceptors first",{
						message.commandStack[0].should.be("intercept");
						message.commandStack[1].should.be("intercept");

					});

					it("should execute commands second",{
						message.commandStack[2].should.be("command");
						message.commandStack[3].should.be("command");
					});

					it("should execute command complete methods last",{
						message.commandStack[4].should.be("complete");
					});
				});

			});

			describe("asynchronous commands",{
				it("should stop notification flow",{
					var message = new Message(),
						sequencer;

					processor.mapCommand(MockAsyncCommand);
					message.asyncResume = false;
					processor.dispatch(message);

					sequencer = processor.openSequencers[0];

					sequencer.stopped.should.be(true);
				});
				it("should be able to resume the notification flow",{
					var message = new Message(),
						sequencer;

					processor.mapCommand(MockAsyncCommand);
					message.asyncResume = true;
					processor.dispatch(message);

					sequencer = processor.openSequencers[0];

					sequencer.stopped.should.be(false);
				});
			});

			describe("interceptors", {
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
					processor.openSequencers[0].resume();
					MockCommand.message.should.be(message);
				});
			});

			describe("command flow utilizing all features", {
				var message;
				before({
					var controller = injector.instantiate(FullMessageFlowController);

					message = new FullMessageFlow();

					injector.mapValue(FullMessageFlowController,controller);
					processor.mapCommand(FullMessageFlowCommand);
					processor.mapCommand(FullMessageFlowInterceptor);
					processor.dispatch(message);
				});

				it("should call intercepts in the correct order",function(){
					message.interceptors[0].should.be("firstInterceptor");
					message.interceptors[1].should.be("secondInterceptor");
					message.interceptors[2].should.be("thirdInterceptor");
					message.interceptors[3].should.be("fourthInterceptor");
				});

				it("should call commands in the correct order", function(){
					message.commands[0].should.be("firstCommand");
					message.commands[1].should.be("secondCommand");
					message.commands[2].should.be("thirdCommand");
					message.commands[3].should.be("fourthCommand");
				});

				it("should call complete methods in the correct order", function(){
					message.completeMethods[0].should.be("firstComplete");
					message.completeMethods[1].should.be("secondComplete");
					message.completeMethods[2].should.be("thirdComplete");
				});
			});

		});
	}

}
