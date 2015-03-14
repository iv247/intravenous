
package iv247.intravenous.messaging.mock;


@command(1)
class MockCommand 
{
	public static var message : Message;
	public static var count : Int = 0;

	public function new(){
		count++;
	}

	public function execute(msg:Message):haxe.Http{
		message = msg;
		
		return null;
	}

	public function complete(data):Void {
		// messageProcessor.complete();
	}

	public function onError(data):Void {
		// messageProcessor.cancel();
	}

}

@command
class CommandInterceptor
{
	public function new(){}

	public function execute(msg:Message,sequencer:iv247.intravenous.messaging.CommandSequencer):Void{
		 sequencer.stop();
	}
}