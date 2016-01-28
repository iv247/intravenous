package intravenous.configuration;

import intravenous.Context;
import intravenous.ioc.IInjector;
import intravenous.ioc.IV;
import intravenous.messaging.IVMessageProcessor;
import intravenous.messaging.MessageProcessor;
import intravenous.view.ViewController;

@:access(intravenous.Context)
class DefaultConfiguration implements Configuration{
	var messageProcessor:IVMessageProcessor;
	var injector:IInjector;

	public function new(){}

	public function configure(context:Context){
		injector = new IV();
		messageProcessor = new IVMessageProcessor(injector);
		context.injector = injector;
		context.messageProcessor = messageProcessor;
		configureMessaging();
		configureViewHandling();
	}

 	function configureMessaging() {
		IV.addExtension(IVMessageProcessor.DISPATCHER_META,IVMessageProcessor.getDispatcher);
		IV.extendIocTo("command",messageProcessor.processMeta);
		IV.extendIocTo("commandComplete",messageProcessor.processMeta);
		injector.mapValue(MessageProcessor,messageProcessor);
	}

	function configureViewHandling() {
		var viewController:ViewController;
		viewController = injector.instantiate(ViewController);
		injector.mapValue(ViewController,viewController);
	}
}