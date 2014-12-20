package iv247.intravenous.ioc.mock;

import iv247.intravenous.ioc.mock.InjectionMock;

enum MockEnum 
{

	@inject
	MockEnumValue;
	
	@inject("injectedObjectId")
	MockEnumCtor(i:InjectedObject,i2:InjectedObject,?i3:MockEnum);

}