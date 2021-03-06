package intravenous.routing; 

import intravenous.messaging.MessageProcessor;
import intravenous.Router;
import intravenous.routing.RouteEvent;

class RouteController {
	
	@inject public var router:Router;
	@inject public var dispatcher:MessageProcessor;

	var currentRoute(default,null):Route;

	public function new(){};

	#if (js && !nodejs)
		var history = js.Browser.window.history;
	#else
		var history:Dynamic = null;
	#end

	@post
	public function init() {
		#if (js && !nodejs)
			var location = js.Browser.window.location;
			history = js.Browser.window.history;
			js.Browser.document.addEventListener('click', handleAnchorClick);
			js.Browser.window.addEventListener('popstate', function(e){
				var route = router.getRoute( location.pathname + location.search);
				dispatcher.dispatch( new RouteChanged(route,currentRoute) );
			},false);
			untyped history.pushState = pushState.bind(_,_,_,history.pushState);
			untyped history.replaceState = pushState.bind(_,_,_,history.replaceState);
		#end
	}

	@command
	public function onRouteChange(message:RouteChanged) {
		currentRoute = message.newRoute;
	}

	@command 
	public function onRouteTo(message:RouteTo){
		var oldRoute = currentRoute;
		var newRoute = router.getRoute(message.path);
	
		if(history != null){
			history.pushState(router.getRoute(message.path),null,message.path);
		}else{
			dispatcher.dispatch( new RouteChanged(newRoute,oldRoute) );
		}
	}

	#if (js && !nodejs)
		function pushState (state:Dynamic,something:String,path:String,fn:Dynamic->String->String->Void) {
			var route = router.getRoute(path);
			var oldRoute = currentRoute;
			currentRoute = route;
			
			if(oldRoute !=null && oldRoute.meta.path == currentRoute.meta.path){
				return;
			}
			
			fn(null,something,path);
			dispatcher.dispatch( new RouteChanged(currentRoute,oldRoute) );
		}

		function handleAnchorClick(event) {
			var anchorTag:js.html.AnchorElement;
			var target:js.html.Element = event.target;
			var currentPath = js.Browser.window.location.href;
			
			if(event.defaultPrevented){
				return;
			}

			if(event.target.tagName == 'A'){
				anchorTag = cast event.target;
			}else{
				anchorTag = cast findParentByTagName(event.target,'A');
			}

			if(anchorTag != null){
				var href = anchorTag.getAttribute('href');
				if(!~/^(\w*:|\/\/)/.match(href)){
					event.preventDefault();
					js.Browser.window.history.pushState(router.getRoute(href),href,href);
				}
			}
		} 

		function findParentByTagName(element:js.html.Element, tagName) {
		    var parent = element;

		    while (parent != null && parent.tagName != tagName.toUpperCase()) {
		        parent = parent.parentElement;
		    }

		    return parent;
		}
	#end
}

class RouteTo { 
	public var replace(default,null):Bool;
	public var path(default,null):String;
	
	public function new(new_path:String,?replace_route:Bool) {
		path = new_path;
		replace = replace_route;
	} 
}

class RouteChanged {
	public var newRoute(default,null):Route;
	public var oldRoute(default,null):Route;
	public function new(new_route:Route,old_route:Route){
		newRoute = new_route;
		oldRoute = old_route;
	}
}