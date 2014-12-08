package iv247.iv;


@:access(iv247.iv.Injectable)
enum Injection {

    Value (v:Dynamic);

    DynamicObject (
    	t:iv247.iv.Injectable<Enum<Dynamic>,Class<Dynamic>>,
    	?ctor:Null<String>
    );

    Singleton (
    	t:Injectable<Enum<Dynamic>,Class<Dynamic>>, 
    	it:Injectable<Enum<Dynamic>,Class<Dynamic>>,
    	?ctor:Null<String> 
    );

}
 