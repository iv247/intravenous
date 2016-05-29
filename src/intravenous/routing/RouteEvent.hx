package intravenous.routing;

import intravenous.Router.Route;

enum RouteEvent {
	INIT(r:Route);
	GO(r:Route);
	REPLACE(r:Route);
	CHANGED(r:Route,o:Route,replaced:Bool);
}
