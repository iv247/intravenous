package intravenous.ioc;

typedef ExtensionDef = {	
	var meta : Dynamic<Array<Dynamic>>;
	var metaname : String;
	var object : Dynamic;
	var injector : IInjector;
	var type : ExtensionType;
    var field : String;
}
