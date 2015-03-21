
package iv247.intravenous.messaging.mock;

import iv247.intravenous.messaging.*;

class MockCommandOrder 
{
	public function new(){};

	@command
	public function intercept(msg:Message,process:CommandSequencer){
		msg.commandStack.push("intercept");
	}

	@command
	public function command(msg:Message){
		msg.commandStack.push("command");
	}

	@commandResult
	public function commandResult(msg:Message){
		msg.commandStack.push("result");
	}
}


@command 
class MockCommandOrderInterceptor 
{
	public function new(){}
	public function execute(msg:Message, process:CommandSequencer):Void{
		msg.commandStack.push("intercept");
	}
}

@command 
class MockCommandOrderCommand 
{
	public function new(){}

	public function execute(msg:Message):Void{
		msg.commandStack.push("command");

	}
}