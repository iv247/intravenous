
package iv247.intravenous;

import iv247.IV;

class Context 
{
	public var injector(default,null) : IV;
	public var initialized(default,null) : Bool;
	public var messageProcessor(default,null):Bool;

	/**
		Creates a new context
		optionally initializing on instantiation
	**/
	public function new (?autostart : Bool = true) {
		if(autostart){
			initialize();
		}
	}

	/**
		Initializes context by:
		
		 Creating and injector if one has not been defined;
		 Settting the default configuration if one has not been defined;
		 Sets initialized to true;
	**/
	public function initialize() : Void {
		if(injector == null){
			injector = new IV();
		}

		initialized = true;
	}


}