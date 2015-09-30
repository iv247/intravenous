
package intravenous.messaging.mock;

import intravenous.messaging.*;

class FullMessageFlow 
{
	public var interceptors:Array<String>;
	public var commands:Array<String>;
	public var completeMethods:Array<String>;

	public function new(){
		interceptors = [];
		commands = [];
		completeMethods = [];
	}

}

class FullMessageFlowController {	
	public function new(){};

	@intercept
	@command(0) public function firstInterceptor(msg:FullMessageFlow,sequence:CommandSequencer):Void{
		msg.interceptors.push("firstInterceptor");
	}

	@intercept
	@command(1) public function secondInterceptor(msg:FullMessageFlow,sequence:CommandSequencer):Void{
		msg.interceptors.push("secondInterceptor");
	}

	@intercept
	@command(3) public function fourthInterceptor(msg:FullMessageFlow,sequence:CommandSequencer):Void{
		msg.interceptors.push("fourthInterceptor");
	}

	@command public function firstCommand(msg:FullMessageFlow):Void{
		msg.commands.push("firstCommand");
	}

	@command(1) public function secondCommand(msg:FullMessageFlow,cb:CallbackFunction):Void{
		msg.commands.push("secondCommand");
		cb(true);
	}
	
	@command(3) public function fourthCommand(msg:FullMessageFlow):Void{
		msg.commands.push("fourthCommand");
	}

	@commandComplete(0) public function fistComplete(msg:FullMessageFlow):Void{
		msg.completeMethods.push("firstComplete");
	}
	@commandComplete(1) public function secondComplete(msg:FullMessageFlow):Void{
		msg.completeMethods.push("secondComplete");
	}
	@commandComplete(2) public function thirdComplete(msg:FullMessageFlow):Void{
		msg.completeMethods.push("thirdComplete");
	}

}

@intercept
@command(2)
 class FullMessageFlowInterceptor {
	public function new(){};

	public function execute(msg:FullMessageFlow,sequence:CommandSequencer):Void{
		msg.interceptors.push("thirdInterceptor");
	}
}

@command(2)
 class FullMessageFlowCommand {
	public function new(){};

	public function execute(msg:FullMessageFlow):Void{
		msg.commands.push("thirdCommand");
	}

}

@command(4)
class FullMessageFlowCommand2 {
	public function new(){};

	public function execute(msg:FullMessageFlow,cb:CallbackFunction):Void{
		msg.commands.push("fifthCommand");
		cb(false);
	}

}

@command(5)
class FullMessageFlowCommand3 {
	public function new(){};

	public function execute(msg:FullMessageFlow,cb:CallbackFunction):Void{
		msg.commands.push("sixthCommand");
		cb(true);
	}
}

