
package intravenous.messaging.mock;

import intravenous.messaging.CallbackFunction;

@command(0)
class MockAsyncCommand 
{

	public function new (){}

	public function execute(msg:Message,cb:CallbackFunction):Void {
		untyped cb(msg.asyncResume);
	}

}