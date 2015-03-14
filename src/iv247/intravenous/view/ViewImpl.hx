
package iv247.intravenous.view;

class ViewImpl implements View
{
	public var parent(default,null):View;

	public var viewElement(default,null) : Dynamic;

	@dispatcher
	public var dispatch:Void->Dynamic;
	


	public function new(){
		
	}
	
	public function add(view:View) : Void {
		// this.children().push(view);
		// viewElement.appendChild(view.viewElement);
		// dispatch({
		// 	name : "Added",
		// 	view : this
		// });
	}

	public function remove(view:View) : Void {
		// this.children().remove(view);
		// viewElement.remove(view.viewElement);
		// dispatch({
		// 	name : "Removed",
		// 	view : this
		// });
	}

	public function children():Array<View> {
		return [];
	}


}