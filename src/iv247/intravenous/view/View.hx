
package iv247.intravenous.view;

interface View 
{
	var parent(default,null):View;

	function add(view:View):Void;
	function remove(view:View):Void;
	function children():Array<View>;
}