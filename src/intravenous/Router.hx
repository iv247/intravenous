package intravenous;

typedef RouteMeta = {
	url : String,
	?data:Dynamic
};
typedef Route = {
	urlExp : EReg,
	paramNames : Array<String>,
	params:Map<String,String>,
	meta: {}
};

class Router {

	private var _routes:Array<Route>;

	public function new(){
		_routes = [];
	}

	public function add( meta:RouteMeta ):Router{
		var route:Route;

		route = createRoute(meta);

		_routes.push(route);

		return this;
	}

	public function matchRoute(url:String):Route{
		var params =  new Map<String,String>();
		var matchedRoute = null;
		
		//add a trailing slash if one doesn't exist
		url = ~/([^\/])$/.replace(url,'$1/');

		for(route in _routes){
			if(route.urlExp.match(url)){
				matchedRoute = Reflect.copy(route);
				for(i in 0...route.paramNames.length){
        			params[route.paramNames[i]] = route.urlExp.matched(i+1);
        		}
        		break;
			}
		}
		if(matchedRoute != null){
			matchedRoute.params = params;
		}

		return matchedRoute;
	}

	private function createRoute(meta:RouteMeta):Route {
		var varMatch = ~/:\w*/g;
		var content  = meta.url;
		var stringForRegEx = meta.url;
		var paramNames = new Array<String>();

		while(varMatch.match(content)){
            var param =  varMatch.matched(0);
            var left = varMatch.matchedLeft();
            
            stringForRegEx = StringTools.replace(stringForRegEx,param,'([ \\w|()_"+`~%20-\\[ \\]{}!#$^&*,.]*/?)');
            
            paramNames.push(param.substr(1));
            
            content = varMatch.matchedRight();
           
            if(content==''){
            	stringForRegEx+="/$";
            }
        }

		return { 
			urlExp:  new EReg(stringForRegEx,'g'),
			paramNames: paramNames,
			meta: Reflect.copy(meta),
			params: null
		};
	}
}