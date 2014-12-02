package iv247.iv.mock;

class MockExtensionObject 
{

	@inject
	public var extension3 : iv247.iv.ExtensionDef.ExtensionType;

	@extension
	@inject
	public var extension : iv247.iv.mock.InjectionMock.InjectedObject;

	@extension
	public var extension2 : iv247.iv.mock.InjectionMock.InjectedObject;

	@extensionMethod
	public function mockMethod(value : iv247.iv.mock.InjectionMock.InjectedObject) : iv247.iv.mock.InjectionMock.InjectedObject {
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

