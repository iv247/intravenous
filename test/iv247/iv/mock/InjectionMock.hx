package iv247.iv.mock;

class InjectionMock {
	
	@inject public var injectedObject : InjectedObject;

	@inject("injectedObjectId") public var injectedObjectWithId : InjectedObject;

	public var nonInjectedObject : InjectedObject;

	@inject public function new(){

	}

	@inject 
	public function injectableMethod(injectedObject : InjectedObject) : InjectedObject {
		return injectedObject;
	}

	@inject(null,"injectedObjectId") 
	public function injectableMethodWithId(v1:InjectedObject,v2:InjectedObject) : Dynamic {
		
		return {
			injectedObject : v1,
			injectedObjectWithId : v2
		}
	}

	@inject("injectedObjectId")
	public function injectableMethodWithOptionalArg(v1:InjectedObject,?v2:InjectedObject) : Dynamic {
		
		trace("optional");
		trace(v2);
		return {
			injectedObjectWithId : v1,
			injectedObject : v2
		}
	}
}

class InjectedObject {
	public function new(){};
}