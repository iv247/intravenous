package intravenous.configuration;

import intravenous.Context;
import intravenous.ioc.IInjector;
import intravenous.ioc.IV;
import intravenous.messaging.IVMessageProcessor;
import intravenous.messaging.MessageProcessor;
import intravenous.Router.RouteMeta;
import intravenous.routing.RouteController;
import intravenous.view.ViewController;

@:access(intravenous.Context)
class DefaultConfiguration implements Configuration{
	var messageProcessor:IVMessageProcessor;
	var injector:IInjector;
	var routeMetas:Array<RouteMeta>;

	public function new(?routes:Array<RouteMeta>){
		routeMetas = routes;
	}

	public function configure(context:Context){
		injector = new IV();
		messageProcessor = new IVMessageProcessor(injector);
		context.injector = injector;
		context.messageProcessor = messageProcessor;
		configureExtensions();
		configureMessaging();
		configureViewHandling();
		configureRouter();
	}

	public function configureExtensions() {
		IV.addExtension(IVMessageProcessor.DISPATCHER_META,IVMessageProcessor.getDispatcher);
		IV.extendIocTo("command",messageProcessor.processMeta);
		IV.extendIocTo("commandComplete",messageProcessor.processMeta);
	}

	public function configureClient() {
		configureExtensions();
		injector.getInstance(RouteController).init();
	}

 	function configureMessaging() {
		injector.mapValue(MessageProcessor,messageProcessor);
	}

	function configureViewHandling() {
		var viewController:ViewController;
		viewController = injector.instantiate(ViewController);
		injector.mapValue(ViewController,viewController);
	}

	function configureRouter() {
		var router = new Router();
		if(routeMetas != null){
			for(i in 0...routeMetas.length){
				router.add(routeMetas[i]);
			}
		}
		injector.mapValue(Router,router);
		injector.mapValue(RouteController, injector.instantiate(RouteController));
	}
}