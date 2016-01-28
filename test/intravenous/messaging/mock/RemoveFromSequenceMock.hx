package intravenous.messaging.mock;

import intravenous.messaging.*;
import intravenous.messaging.MessageProcessor;

class RemoveFromSequenceMock {
	
	public var commandToBeRemovedCalled:Bool = false;
	public var commandCalled:Bool = false;
	public var controllerCalled:Bool = false;
	public var controllerToBeRemovedCalled:Bool = false;
	
	public function new(){}
}


@command(0)
class Command {
	@inject
	public var processor:IVMessageProcessor;

	public function new(){}

	public function execute(msg:RemoveFromSequenceMock){
		msg.commandCalled = true;
		processor.removeCommand(CommandToBeRemoved);
	}
}


@command(1)
class CommandToBeRemoved {
	public function new(){}
	public function execute(msg:RemoveFromSequenceMock){
		msg.commandToBeRemovedCalled = true;
	};
}

class Controller {

	@inject
	public var processor:IVMessageProcessor;

	@inject 
	public var controllerToBeRemoved:ControllerToBeRemoved;

	public function new(){}

	@command(2)
	public function run(msg:RemoveFromSequenceMock):Void{
		msg.controllerCalled = true;
		processor.deregister(controllerToBeRemoved);
	}
}


class ControllerToBeRemoved {
	public function new(){}
	@command(3)
	public function run2(msg:RemoveFromSequenceMock):Void{
		msg.controllerToBeRemovedCalled = true;
	}
}


