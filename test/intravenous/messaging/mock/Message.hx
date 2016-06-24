package intravenous.messaging.mock;

class Message 
{
	public var interceptCalled : Bool;
	public var commandCalled : Bool;
	public var commandCompleteCalled : Bool;
	public var asyncResume : Bool;

	public var commandStack : Array<String>;
	public var injectedValue:Dynamic;

	public function new(){
		commandStack = [];
	}

}