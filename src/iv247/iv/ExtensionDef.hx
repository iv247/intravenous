package iv247.iv;

typedef ExtensionDef = {	
	var metaname : String;
	var object : Dynamic;
	var injector : IInjector;
	var type : ExtensionType;
}

enum ExtensionType {
	Constructor;
	Method;
	Property;
}