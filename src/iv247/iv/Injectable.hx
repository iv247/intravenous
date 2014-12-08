package iv247.iv;

abstract Injectable <T1 : (Enum<Dynamic>), T2 : (Class<Dynamic>)> (Dynamic) from T1 from T2  to T1 to T2 {
                
    // public inline function new(i:Dynamic){ 
    // 	this = i;
    // }                        

    @:from 
    public static function fromString(path:String){
    	var classType = Type.resolveClass(path);
    	var type : iv247.iv.Injectable<Enum<Dynamic>,Class<Dynamic>>;
    	
    	if(classType != null){
    		type = classType;
    	}else{
    		type= Type.resolveEnum(path);
    	} 

    	return type;	
    }

	public function getName():String {
	 	if(Std.is(this,Class)){
	    	return Type.getClassName(this);
		}else{
	        return Type.getEnumName(this);
		}
	}

	public function instantiate(args,?ctor) {
		if(isClass()){
			return Type.createInstance(this,args);
		}else{
			return Type.createEnum(this,ctor,args);
		}
	}

	public function isEnum():Bool {
		return Std.is(this,Enum);
	}

	public function isClass():Bool{
		return Std.is(this,Class);
	}
}