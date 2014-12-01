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

	public function new() {

	}

}

class MockCtorExtensionObject {

	@extension
	public function new() {

	}
}