
package iv247.intravenous.messaging.mock;

import iv247.intravenous.messaging.MessageProcessor;

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

	@commandResult
	public function commandResult(object:Message) : Void {
		object.commandResultCalled = true;
	}	


}