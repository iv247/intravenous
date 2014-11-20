package iv247.iv.mock;

class InjectionMock {
	
	@inject public var injectedObject : InjectedObject;

	@inject("injectedObjectId") public var injectedObjectWithId : InjectedObject;

	public var nonInjectedObject : InjectedObject;

	@inject public function new(){

	}

	@inject public function injectableMethod(injectedObject : InjectedObject) : InjectedObject {
		return injectedObject;
	}
}

class InjectedObject {
	public function new(){};
}