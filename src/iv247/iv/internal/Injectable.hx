package iv247.iv.internal;

abstract Injectable <T1 : (Enum<Dynamic>), T2 : (Class<Dynamic>)> (Dynamic) from T1 from T2  to T1 to T2 {
                
    @:from 
    public static function fromString(path:String) {
        var classType = Type.resolveClass(path);
        var type : Injectable<Enum<Dynamic>,Class<Dynamic>>;
        
        if(classType != null){
            type = classType;
        }else{
            type = Type.resolveEnum(path);
        } 

        return type;    
    }

    @:from 
    public static function fromDynamic(v:Dynamic){
        var inj:Injectable<Enum<Dynamic>,Class<Dynamic>> = null;
        
        if(isClass(v)) {
            inj = Type.resolveClass(Type.getClassName(v));
        }
        else if(isEnum(v)){
            inj = Type.resolveEnum(Type.getEnumName(v));
        }
        else if(Std.is(v,String)) {
            inj = cast(v,String);
            
            if(inj == null){
              trace('assigned invalid path');
            }

        }else{
            trace('assined invalid type');
        }
        return inj; 
    }

    public function getName():String {
        if(isClass(this)){
            return Type.getClassName(this);
        }else{
            return Type.getEnumName(this);
        }
    }

    public function instantiate(args,?ctor) {
        if(isClass(this)){
            return Type.createInstance(this,args);
        }else{
            return Type.createEnum(this,ctor,args);
        }
    }
    static
    public function isEnum(v:Dynamic):Bool {
        #if flash
            return untyped v.__constructs__ != null;
        #else
            return Std.is(v,Enum);
        #end
    }

    static
    public function isClass(v:Dynamic):Bool {
        #if flash
            return untyped v.__constructs__ == null;
        #else
            return Std.is(v,Class);
        #end
    }
}
