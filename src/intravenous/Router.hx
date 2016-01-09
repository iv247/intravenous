package intravenous;

typedef RouteMeta = {
	path : String,
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

	var routes:Array<Route>;

	public function new(){
		routes = [];
	}

	public function add(meta:RouteMeta):Router{
		var route = createRoute(meta);
		routes.push(route);
		return this;
	}

	/*
		return a instance of Route
		@param absPath - an absolute path to match list of added Routes against
	*/
	public function getRoute(absPath:String):Route{
		var params =  new Map<String,String>();
		var matchedRoute = null;
		var ex = ~/(\?.*)/;
		var path;
		
		//remove query
		path = ~/(\?.*)/.replace(absPath,'');
		//add a trailing slash if one doesn't exist
		path = ~/([^\/])$/.replace(path,'$1/');
 
		for(route in routes){
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
			matchedRoute.query = getQuery(absPath);
		}

		return matchedRoute;
	}

	/*
		Returns a Map of name value pairs from a standard query string
	*/
	public function getQuery(url:String):Map<String,String> {
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

	function createRoute(meta:RouteMeta):Route {
		var varMatch = ~/:\w*/g;
		var content  = meta.path;
		var stringForRegEx = meta.path;
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
			urlExp: new EReg(stringForRegEx,'g'),
			paramNames: paramNames,
			meta: Reflect.copy(meta),
			params: null
		};
	}
}