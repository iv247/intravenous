package intravenous.ioc.mock;

import intravenous.ioc.mock.InjectionMock;

enum MockEnum 
{

	@inject
	MockEnumValue;
	
	@inject("injectedObjectId")
	MockEnumCtor(i:InjectedObject,i2:InjectedObject,?i3:MockEnum);

}