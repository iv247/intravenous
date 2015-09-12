
package intravenous.messaging.mock;

import intravenous.messaging.MessageProcessor;

class MockController 
{

	public function new(){
	}

	@command
	public function intercept(object:Message, processor : MessageProcessor) : Void {
		object.interceptCalled = true;
	}

	@command
	public function commandHandler(object:Message) : Void {
		object.commandCalled = true;

	}

	@commandComplete
	public function commandResult(object:Message) : Void {
		object.commandCompleteCalled = true;
	}	


}