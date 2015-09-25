package intravenous.ioc.internal;

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

        if(isAnEnum(v)){
             inj = Type.resolveEnum(Type.getEnumName(v));
        }
        else if(isAClass(v) ) {
            inj = Type.resolveClass(Type.getClassName(v));
        }

        else if(Std.is(v,String)) {
            inj = cast(v,String);
            
            if(inj == null){
              trace('assigned invalid path');
            }

        }else{
            trace('assigned invalid type');
        }
        return inj; 
    }

    public function getName():String {
        if(isAClass(this) && !isAnEnum(this)){
            return Type.getClassName(this);
        }else{
            return Type.getEnumName(this);
        }
    }

    public function instantiate(args,?ctor) {
        if(isAClass(this)){
            return Type.createInstance(this,args);
        }else{
            return Type.createEnum(this,ctor,args);
        }
    }

    public function isClass():Bool {
        #if cpp
            return !isEnum();
        #elseif flash
            return untyped this.__constructs__ == null;
        #else
            return Std.is(this,Class);
        #end
    }

    public function isEnum():Bool {
        #if cpp
           return Type.allEnums(this).length > 0;
        #elseif flash
            return untyped this.__constructs__ != null;
        #else
            return Std.is(this,Enum);
        #end
    }

    static
    public function isAnEnum(v:Dynamic):Bool {
        #if cpp
           return Type.allEnums(v).length > 0;
        #elseif flash
            return untyped v.__constructs__ != null;
        #else
            return Std.is(v,Enum);
        #end
    }


    static
    public function isAClass(v:Dynamic):Bool {
         #if cpp
            return Type.allEnums(v).length == 0;
        #elseif flash
            return untyped v.__constructs__ == null;
        #else
            return Std.is(v,Class);
        #end
    }
}
