package intravenous.view;

import intravenous.messaging.IVMessageProcessor;
import intravenous.view.ViewMessage;

class ViewController
{

	@inject 
	public var processor:IVMessageProcessor;

	public function new(){}

	@command 
	public function execute(message:ViewMessage){

		switch(message.type){

			case ViewMessage.Types.ADDING:
				addingView(message);
			case ViewMessage.Types.ADDED : //do nothing to do;
				viewAdded(message);
			case ViewMessage.Types.REMOVED:
				viewRemoved(message);
		}

	}

	function viewAdded(message) {
		//nothing to do for now
	}

	function addingView(message) {
		processor.injector.injectInto(message.view);
	}

	function viewRemoved(message:ViewMessage) {
		processor.deregister(message.view);
	}

}