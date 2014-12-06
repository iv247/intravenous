package iv247.iv.mock;

import iv247.iv.mock.MockEnum;

class InjectionMockWEnum 
{

	@inject
	public var injectedEnum:MockEnum;

	@inject("injectEnumCtorId")
	public var injectedEnumCtor:MockEnum;

	public var enumCtor:MockEnum;

	public var enumValue:MockEnum;
	
	@inject("injectEnumCtorId")
	public function new(enumCtor:MockEnum,enumValue:MockEnum) : Void {

	}

}