
package intravenous;

import intravenous.ioc.IV;
import intravenous.view.View;
import intravenous.messaging.MessageProcessor;
import intravenous.view.ViewController;

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
		configureViewHandling();
		initialized = true;
	}
	/**
		Sets up Command/Messaging feature set
	**/
	public function configureMessaging() : Void {
		messageProcessor = new MessageProcessor(injector);
		IV.addExtension(MessageProcessor.DISPATCHER_META,MessageProcessor.getDispatcher);
		IV.extendIocTo("command",messageProcessor.processMeta);
		IV.extendIocTo("commandComplete",messageProcessor.processMeta);
		injector.mapValue(MessageProcessor,messageProcessor);
	}

	public function configureViewHandling() : Void {
		var viewController;
		viewController = injector.instantiate(ViewController);
		injector.mapValue(ViewController,viewController);
		injector.injectInto(app);
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
