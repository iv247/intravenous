
package iv247.intravenous.messaging.mock;


@command(1)
class MockCommand 
{
	public static var message : Message;
	public static var count : Int = 0;

	public function new(){
		count++;
	}

	public function execute(msg:Message):Void{
		message = msg;
	}

}