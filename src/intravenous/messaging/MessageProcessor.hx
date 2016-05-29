package intravenous.messaging;


interface MessageProcessor {
	function dispatch(o:Dynamic):Void;
	function mapCommand<T>(commandClass:Class<T>):MessageProcessor;
}