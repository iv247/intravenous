package iv247.intravenous.ioc.mock;

class MockExtensionObject 
{



	@extension
	@inject
	public var extension : iv247.intravenous.ioc.mock.InjectionMock.InjectedObject;

	@extension
	public var extension2 : iv247.intravenous.ioc.mock.InjectionMock.InjectedObject;

	@extensionMethod
	public function mockMethod(value : iv247.intravenous.ioc.mock.InjectionMock.InjectedObject) : iv247.intravenous.ioc.mock.InjectionMock.InjectedObject {
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

