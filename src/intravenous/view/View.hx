package intravenous.view;

@:keepInit
interface View
{
	// var viewElement(get,null) : Dynamic;
	
	// var parent(default,null):View;
	
	// var children(get,null):Dynamic;
	
	// public function addView(view:Dynamic):Dynamic;

	// public function removeView():Dynamic;

	function create():Void;
	function added():Void;
	function removed():Void;
	function render():Void;
	function onRenderComplete():Void;
}