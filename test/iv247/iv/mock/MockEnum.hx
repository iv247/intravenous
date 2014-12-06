package iv247.iv.mock;

import iv247.iv.mock.InjectionMock;

enum MockEnum 
{

	@inject
	MockEnumValue;
	
	@inject("injectedObjectId")
	MockEnumCtor(i:InjectedObject,i2:InjectedObject,?i3:MockEnum);

}