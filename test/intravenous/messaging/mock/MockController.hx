
package intravenous.messaging.mock;

import intravenous.messaging.CommandSequencer;

class MockController
{

	public function new(){
	}

	@command
	public function intercept(object:Message, sequencer : CommandSequencer) : Void {
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