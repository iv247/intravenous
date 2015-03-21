 
package iv247.intravenous.messaging;

interface Sequencer 
{

	function start():Void;
	function resume():Void;
	function stop():Void;
	function cancel():Void;

}