
package iv247.intravenous.messaging.mock;


class Message 
{


	public var interceptCalled : Bool;
	public var commandCalled : Bool;
	public var commandCompleteCalled : Bool;
	public var asyncResume : Bool;

	public var commandStack : Array<String>;

	public function new(){
		commandStack = new Array<String>();
	}

}