package intravenous.ioc.mock;

class MockExtensionObject 
{



	@extension
	@inject
	public var extension : intravenous.ioc.mock.InjectionMock.InjectedObject;

	@extension
	public var extension2 : intravenous.ioc.mock.InjectionMock.InjectedObject;

	@extensionMethod
	public function mockMethod(value : intravenous.ioc.mock.InjectionMock.InjectedObject) : intravenous.ioc.mock.InjectionMock.InjectedObject {
		return value;
	}

	public function new() {

	}

}

class MockCtorExtensionObject {

	@extension
	public function new() {

	}

	
}

