
package intravenous.view;

interface View
{
	var viewElement(get,null) : Dynamic;
	
	var parent(default,null):View;
	
	var children(get,null):Dynamic;
	
	public function addView(view:Dynamic):Dynamic;

	public function removeView(view:Dynamic):Dynamic;

	function create():Void;
	function render():Void;
	function onRenderComplete():Void;
}