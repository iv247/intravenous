package intravenous;

import intravenous.configuration.Configuration;
import intravenous.ioc.IInjector;
import intravenous.messaging.MessageProcessor;
import intravenous.view.View;

@:allow(intravenous.configuration.Configuration)
class Context {

	public var injector(default, null):IInjector;
	public var initialized(default, set):Bool;
	public var messageProcessor(default, null):MessageProcessor;
	public var app(default, null):View;

	var configuration:Configuration;

	/**
		Creates a new context, optionally initializing on instantiation.
	**/

	public function new(appConfig:Configuration, ?mainView:View, ?autostart:Bool = true) {
		app = mainView;

		configuration = appConfig;

		if (autostart) {
			initialize();
		}
	}

	/**
		Initializes context by:

		 * Creating and injector if one has not been defined;
		 * Settting the default configuration if one has not been defined;
		 * Sets initialized to true;
	**/

	public function initialize() {
		if (initialized) {
			throw 'Context has already been initialized';
		}
		configuration.configure(this);
		injector.injectInto(app);
		initialized = true;
		messageProcessor.dispatch(new ContextInitialized());
	}

	public function set_initialized(v:Bool) {
		initialized = v;

		return initialized;
	}

	/**
		Map a command to be created an executed when the commands message type is dispatched
	**/

	public function mapCommand<T>(commandClass:Class<T>) {
		messageProcessor.mapCommand(commandClass);
	}

	// public function mapView(view : Class<View<Dynamic>>, mediator : Class<Dynamic>) {

	// }
}

class ContextInitialized {public function new() {}
}
