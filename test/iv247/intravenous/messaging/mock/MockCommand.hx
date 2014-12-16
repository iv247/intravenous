
package iv247.intravenous.messaging.mock;

@command(1)
class MockCommand 
{

	public function new(){}

	public function execute(message:Message):Void{
		trace('executed');
	}

}