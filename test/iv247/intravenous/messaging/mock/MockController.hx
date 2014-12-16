
package iv247.intravenous.messaging.mock;

import iv247.intravenous.messaging.MessageProcessor;

class MockController 
{

	public function new(){

	}

	@command
	public function intercept(object:Message, processor : MessageProcessor) : Void {

	}

	@command
	public function commandHandlerTest(object:Message) : Void {

	}

	@commandResult
	public function commandResult(object:Message) : Void {

	}

	@message 
	public function message(object:Message) : Void {

	}

	

}