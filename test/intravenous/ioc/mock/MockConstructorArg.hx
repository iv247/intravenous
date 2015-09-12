package intravenous.ioc.mock;

class MockConstructorArg {

	public var mock : MockObject;
	
	@inject public function new(value : MockObject){
		mock = value;
	}
}

class WithId {
	public var mockWithId : MockObject;
	public var mockWithId2 : MockObject;
	public var noId : MockObject;

	@inject("mockId","mockId2",null) public function new(v1 : MockObject, v2 : MockObject, ?v3: MockObject) {
		mockWithId = v1;
		mockWithId2 = v2;
		noId = v3;
	}
}