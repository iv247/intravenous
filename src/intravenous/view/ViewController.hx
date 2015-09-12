package intravenous.view;
import intravenous.messaging.MessageProcessor;
import intravenous.ioc.IInjector;

class ViewController
{

	@inject public var processor:MessageProcessor;

	public function new(){}

	@command
	public function execute(message:ViewMessage):Void{

		switch(message.type){

			case ViewMessage.Types.ADDING:
				addingView(message);
			case ViewMessage.Types.ADDED : //do nothing to do;
				viewAdded(message);
			case ViewMessage.Types.REMOVED:
				viewRemoved(message);
		}

	}

	private function viewAdded(message):Void {
		//nothing to do for now
	}

	private function addingView(message):Void {
		processor.injector.injectInto(message.view);
	}

	private function viewRemoved(message:ViewMessage):Void {
		processor.deregister(message.view);
	}

}