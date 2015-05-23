package iv247.intravenous.view;

class ViewMessage 
{

	public var type:Types;

	public function new(messageType:Types){
		type = messageType;
	}
	
}

enum Types {
	ADDED;
	REMOVED;
}