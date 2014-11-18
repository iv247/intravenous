package iv247.iv.mock;

class MockConstructorArg {

	public var mock : MockObject;
	
	@inject public function new(value : MockObject){
		mock = value;
	}
}

class WithId {
	public var mockWithId : MockObject;
	public var mockWithId2 : MockObject;

	@inject("mockId","mockId2") public function new(v1 : MockObject, v2 : MockObject) {
		mockWithId = v1;
		mockWithId2 = v2;
	}
}