package iv247.iv.mock;

class MockConstructorArg {

	public var mock : MockObject;
	public var test : String = "test";
	
	@inject public function new(?value : MockObject){
		mock = value;
	}
}