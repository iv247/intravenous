package intravenous;

typedef RouteMeta = {
	url : String,
	?data:Dynamic
};
typedef Route = {
	urlExp : EReg,
	paramNames : Array<String>,
	params:Map<String,String>,
	?query:Map<String,String>,
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

	public function getRoute(url:String):Route{
		var params =  new Map<String,String>();
		var matchedRoute = null;
		var ex = ~/(\?.*)/;
		var path;
		
		//remove query
		path = ~/(\?.*)/.replace(url,'');
		//add a trailing slash if one doesn't exist
		path = ~/([^\/])$/.replace(path,'$1/');
 
		for(route in _routes){
			if(route.urlExp.match(path)){
				matchedRoute = Reflect.copy(route);
				for(i in 0...route.paramNames.length){
        			params[route.paramNames[i]] = route.urlExp.matched(i+1);
        		}
        		break;
			}
		}
		if(matchedRoute != null){
			matchedRoute.params = params;
			matchedRoute.query = getQuery(url);
		}

		return matchedRoute;
	}

	public function getQuery(url:String) {
		var query = new Map<String,String>();
		var regEx = ~/(.*\?)/;
		var pairRegEx =  ~/(=)/;
		var pairs = regEx.replace(url,'').split('&');

		for(pair in pairs){
			if(pairRegEx.match(pair)){
				query[pairRegEx.matchedLeft()] = pairRegEx.matchedRight();
			}else{
				query[pair] = null;
			}
		}

		return query;
	}

	private function createRoute(meta:RouteMeta):Route {
		var varMatch = ~/:\w*/g;
		var content  = meta.url;
		var stringForRegEx = meta.url;
		var paramNames = new Array<String>();

		while(varMatch.match(content)){
            var param =  varMatch.matched(0);
            var left = varMatch.matchedLeft();
            
            stringForRegEx = StringTools.replace(stringForRegEx,param,'([ \\w|()_"+`~%20-\\[ \\]{}!$^&*,.]*/?)');
            
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