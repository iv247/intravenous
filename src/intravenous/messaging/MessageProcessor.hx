package intravenous.messaging;


interface MessageProcessor {
	function dispatch(o:Dynamic):Void;
	function mapCommand(commandClass:Class<Dynamic>):MessageProcessor;
}