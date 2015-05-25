
package iv247.intravenous.view;

interface View 
{

	#if js
	var viewElement(default,null) : js.html.Element;
	#elseif flash
	var viewElement(default,null) : flash.display.Sprite;
	#else
	var viewElement(default,null) : Dynamic;
	#end

	var parent(default,null):View;
	
	var children(default,null) : Array<View>;
	
	public function add(view:View):Void;

	public function remove(view:View):Void;

	function create():Void;
	function render():Void;
	function onRenderComplete():Void;
}