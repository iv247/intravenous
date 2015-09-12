package intravenous.view;

class ViewMessage 
{

	public var type(default,null):Types;
	public var view(default,null):View;

	public function new(messageType:Types,viewObject:View){
		type = messageType;
		view = viewObject;
	}
	
}

enum Types {
	ADDING;
	ADDED;
	REMOVED;
}