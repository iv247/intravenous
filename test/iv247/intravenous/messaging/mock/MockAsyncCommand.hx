
package iv247.intravenous.messaging.mock;

import iv247.intravenous.messaging.CallbackFunction;

@command
class MockAsyncCommand 
{

	public function new (){

	}

	public function execute(msg:Message,cb:CallbackFunction):Void {
		untyped cb(false);
	}

}