package iv247.iv;
enum Injection {

    Value (v:Dynamic);

    DynamicObject (
    	t:Injectable<Enum<Dynamic>,Class<Dynamic>>,
    	?ctor:String
    );

    Singleton (
    	t:Injectable<Enum<Dynamic>,Class<Dynamic>>, 
    	it:Injectable<Enum<Dynamic>,Class<Dynamic>>,
    	?ctor:String
    );

}

abstract Injectable <T1 : (Enum<Dynamic>), T2 : (Class<Dynamic>)> (Dynamic) from T1 from T2 to T1 to T2 {
                
    public inline function new(i:Dynamic){ 
    	this = i;
    }                        

	public function getName():String {
	 	if(Std.is(this,Class)){
	    	return Type.getClassName(this);
		}else{
	        return Type.getEnumName(this);
		}
	}

	public function isEnum():Bool {
		return Std.is(this,Enum);
	}

	public function isClass():Bool{
		return Std.is(this,Class);
	}


}