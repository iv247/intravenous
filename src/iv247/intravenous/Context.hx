
package iv247.intravenous;

import iv247.intravenous.ioc.IV;
import iv247.intravenous.view.View;
import iv247.intravenous.messaging.MessageProcessor;

@:access(iv247.intravenous.messaging.MessageProcessor)
class Context 
{
	public var injector(default,null) : IV;
	public var initialized(default,null) : Bool;
	public var messageProcessor(default,null):MessageProcessor;
	public var app(default,null):View;

	/**
		Creates a new context, optionally initializing on instantiation.
	**/
	public function new (?mainView : View, ?autostart : Bool = true) {
		app = mainView;
		
		if(autostart){
			initialize();
		}
	}
	/**
		Initializes context by:	

		 * Creating and injector if one has not been defined;
		 * Settting the default configuration if one has not been defined;
		 * Sets initialized to true;
	**/
	public function initialize() : Void {
		if(injector == null){
			injector = new IV();
		}
		configureMessaging();
		initialized = true;
	}	
	/**
		Sets up Command/Messaging feature set
	**/
	public function configureMessaging() : Void {
		messageProcessor = new MessageProcessor(injector);
		injector.mapValue(MessageProcessor,messageProcessor);	
		IV.addExtension(MessageProcessor.DISPATCHER_META,MessageProcessor.getDispatcher);
		IV.extendIocTo("command",messageProcessor.processMeta);
	}

	/**
		Map a command to be created an executed when the commands message type is dispatched
	**/
	public function mapCommand(commandClass : Class<Dynamic>) : Void {
		messageProcessor.mapCommand(commandClass);

	}

	public function mapView(view : Class<View>, mediator : Class<Dynamic>) : Void {
		
	}



}