package intravenous.messaging.mock;

@command
class MockCommand 
{
	public static var message : Message;
	public static var count : Int = 0;

	@inject
	public var testInjection:String;

	public function new(){
		count++;
	}

	public function execute(msg:Message):Void{
		message = msg;	
		message.injectedValue = testInjection;
	}

}

@intercept
@command
class CommandInterceptor
{
	public function new(){}

	public function execute(msg:Message,sequencer:intravenous.messaging.CommandSequencer):Void{
		 sequencer.stop();	
	}
}