
package intravenous.messaging.mock;

import intravenous.messaging.*;

class MockCommandOrder 
{
	public function new(){};

	@intercept
	@command
	public function intercept(msg:Message,process:CommandSequencer){
		msg.commandStack.push("intercept");
	}

	@command
	public function command(msg:Message){
		msg.commandStack.push("command");
	}

	@commandComplete
	public function commandResult(msg:Message){
		msg.commandStack.push("complete");
	}
}


@intercept
@command
class MockCommandOrderInterceptor 
{
	public function new(){}
	public function execute(msg:Message, process:CommandSequencer):Void{
		msg.commandStack.push("intercept");
	}
}

@command(1)
class MockCommandOrderCommand 
{
	public function new(){}

	public function execute(msg:Message):Void{
		msg.commandStack.push("command");
	}
}