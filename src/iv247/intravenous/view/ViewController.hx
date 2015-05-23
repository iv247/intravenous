package iv247.intravenous.view;


@command
class ViewController 
{

	public function new(){}

	public function execute(message:ViewMessage):Void{
		switch(message.type){
			case ViewMessage.Types.ADDED : trace('added');
			case ViewMessage.Types.REMOVED: trace('removed');
		}
	}

}