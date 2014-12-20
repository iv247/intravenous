package iv247.intravenous.ioc;

import iv247.intravenous.ioc.internal.Injectable;

enum Injection {

    Value (v:Dynamic);

    DynamicObject (
    	t:Injectable<Enum<Dynamic>,Class<Dynamic>>,
    	?ctor:Null<String>
    );

    Singleton (
    	t:Injectable<Enum<Dynamic>,Class<Dynamic>>, 
    	it:Injectable<Enum<Dynamic>,Class<Dynamic>>,
    	?ctor:Null<String> 
    );

}