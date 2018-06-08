package intravenous;
using Lambda;

typedef RouteMeta = {
	path : String,
	?view:Class<Dynamic>,
	?splat: Bool,
	?data:Dynamic
};

class Route {
	public var urlExp(default,null) : EReg;
	public var paramNames(default,null) : Array<String>;
	public var params(default,null):Map<String,String>;
	public var query(default,null):Map<String,String>;
	public var meta(default,null): RouteMeta;
	public var urlExpString(default,null):String;

	public function new(expString, paramNamesArray, paramsMap, queryMap, metaData){
		urlExp = new EReg(expString,'g');
		urlExpString = expString; 
		paramNames = paramNamesArray;
		params = paramsMap;
		query = queryMap;
		meta = metaData;
	}

	@:keep
	public function hxSerialize(s:haxe.Serializer){
		s.serialize(urlExpString);
		s.serialize(urlExpString);
		s.serialize(paramNames);
		s.serialize(params);
		s.serialize(query);
		s.serialize(meta);
	}

	@:keep
	public function hxUnserialize(s:haxe.Unserializer){
		urlExp = new EReg(s.unserialize(),'g'); 
		urlExpString = s.unserialize();
		paramNames = s.unserialize();
		params = s.unserialize();
		query = s.unserialize();
		meta = s.unserialize();
	}
}



class Router {


	public var routes:Array<Route>;

	public function new(){
		routes = [];
	}

	public function add(meta:RouteMeta):Router{
		var route = createRoute(meta);
		routes.push(route);
		return this;
	}

	/*
		return an instance of Route
		@param absPath - an absolute path to match list of added Routes against
	*/
	public function getRoute(absPath:String):Route{
		var params =  new Map<String,String>();
		var matchedRoute = null;
		var path;
		
		//remove query
		path = ~/(\?.*)/.replace(absPath,'');
		//add a trailing slash if one doesn't exist
		path = ~/([^\/])$/.replace(path,'$1/');
 
		for(route in routes){
			if(route.urlExp.match(path)){
				matchedRoute = route;
				for(i in 0...route.paramNames.length){
        			params[route.paramNames[i]] = route.urlExp.matched(i+1);
        		}
        		break;
			}
		}

		if(matchedRoute != null){
			return new Route(
				matchedRoute.urlExpString,
				matchedRoute.paramNames,
				params,
				getQuery(absPath),
				Reflect.copy(matchedRoute.meta)
			);
		}else {
			return null;
		}
	}

	/*
		Returns a Map of name value pairs from a standard query string
	*/
	public function getQuery(url:String):Map<String,String> {
		var regEx = ~/(.*\?)/;
		var pairRegEx =  ~/(=)/;
		var pairs = regEx.replace(url,'').split('&');

		return 
		pairs.fold(
			function(pair, queryMap:Map<String,String>){
				if(pairRegEx.match(pair)){
					queryMap[pairRegEx.matchedLeft()] = pairRegEx.matchedRight();
				}else{
					queryMap[pair] = null;
				}
				return queryMap;
			},
			new Map<String,String>()
		);
	}

	function createRoute(meta:RouteMeta):Route {
		var varMatch = ~/:\w*/g;
		var content  = meta.path;
		var stringForRegEx = meta.path;
		var paramNames = new Array<String>();

		while(varMatch.match(content)){
            var param =  varMatch.matched(0);
        
            stringForRegEx = StringTools.replace(stringForRegEx,param,'([ \\w|()_"+`~%20-\\[ \\]{}!$^&*,.]*/?)');
            
            paramNames.push(param.substr(1));
            
            content = varMatch.matchedRight();
           
            if(content==''){
            	stringForRegEx+= meta.splat ? "/.*": "/$";
            }
        }

        if(meta.path == '/'){
        	stringForRegEx = '^/$';
        }

		return new Route(
			stringForRegEx,
			paramNames,
			null,
			null,
			meta
		);
	}
}