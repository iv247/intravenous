package intravenous.ioc.internal;

abstract Injectable <T1 : (Enum<Dynamic>), T2 : (Class<Dynamic>)> (Dynamic) from T1 from T2  to T1 to T2 {

	static inline public function IS_AN_ENUM(v:Dynamic):Bool {
		#if cpp
			var isEnum = false;
			try{
		   		isEnum = Type.allEnums(v).length > 0;
			}catch(e:Dynamic){}

			return isEnum;
		#elseif flash
			return untyped v.__constructs__ != null;
		#else
			return Std.is(v,Enum);
		#end
	}

	static inline public function IS_A_CLASS(v:Dynamic):Bool {
		return !IS_AN_ENUM(v) && Std.is(v,Class);
	}

	@:from 
	public static function fromString(path:String) {
		var classType = Type.resolveClass(path);
		var type : Injectable<Enum<Dynamic>,Class<Dynamic>>;
		
		if(classType != null){
			type = classType;
		}
		else{
			type = Type.resolveEnum(path);
		} 

		return type;    
	}

	@:from 
	public static function fromDynamic(v:Dynamic){
		var inj:Injectable<Enum<Dynamic>,Class<Dynamic>> = null;

		if(IS_AN_ENUM(v)){
			inj = Type.resolveEnum(Type.getEnumName(v));
		}
		else if (IS_A_CLASS(v)) {
			inj = Type.resolveClass(Type.getClassName(v));
		}
		
		if(inj == null && Std.is(v,String)) {
			inj = Std.is(v,String) ? fromString(v) : null;
		}else if(inj == null){
			trace('assigned invalid type');
		}

		return inj; 
	}

	public function isClass():Bool {
		return IS_A_CLASS(this);
	}

	public function isEnum():Bool {
		return IS_AN_ENUM(this);
	}

	public function getName():String {
		return isEnum() ? Type.getEnumName(this) : Type.getClassName(this);
	}

	public function instantiate(args,?ctor) {
		return isEnum() ? Type.createEnum(this,ctor,args) : Type.createInstance(this,args); 
	}
}
