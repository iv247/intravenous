package iv247.intravenous.ioc.mock;

import iv247.intravenous.ioc.mock.MockEnum;

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
		this.enumCtor = enumCtor;
		this.enumValue = enumValue;
	}

}