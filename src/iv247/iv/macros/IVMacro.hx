package iv247.iv.macros;
#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import iv247.util.macro.TypeInfo;
using haxe.macro.Tools;
class IVMacro {
	
	public static var metaNames : Array<String>;
	public static var extensionFns : Map<String, Void->Void>;

	private static var onGenerateAdded : Bool; 

	static public function buildMeta (names : Array<String>) : Array<Field> {

		var fields = Context.getBuildFields().copy(),
			newField;

		extensionFns = new Map();
		
		if(metaNames == null) {
			metaNames = [];
		}

		metaNames = metaNames.concat(names);

		if(!onGenerateAdded){
			Context.onGenerate(onGenerate);
			onGenerateAdded = true;
		}

		return null;
	}

	static function onGenerate(types : Array<haxe.macro.Type>) : Void {
		for(type in types){
			switch type {
				case TInst(ref, params): 
					addTypeMetaToClass ( ref.get() );
				case TEnum (ref, params):
					addTypeMetaToEnum(ref.get());
				default:
			}
		}
	}

	static function addTypeMetaToEnum(type : EnumType) : Void {
			
		for(field in type.constructs){
			if(field.meta.has('inject')){

				if(field.meta.has('types')){
					continue;
				}

				switch(field.type){
					case TFun(args,_): 						
						field.meta.add('types',TypeInfo.getTFunArgs(args),type.pos);
					default:
				}
			}
		}
	
	}

	static function	addTypeMetaToClass ( type : ClassType ) : Void {
		var ctor;

		if(type.isInterface){			
			return;
		}

		if(type.constructor != null){
			ctor = type.constructor.get();
			if(!ctor.meta.has('types')){

				for(name in metaNames){
				
					if(ctor.meta.has(name)){
						
						switch(ctor.type) {
							case TFun(args,ret) :
									 ctor.meta.add('types',TypeInfo.getTFunArgs(args),Context.currentPos());
							default : 
						}
						break;
					}
				}
			}		
		}

		for(field in type.fields.get()){	

			for (name in metaNames) {
				
				if(field.meta.has("types") ){
					continue;
				}	

				if(field.meta.has(name)){

					field.meta.add(":keep",[],type.pos);

					switch(field.type){
						
						case TFun(args,ret) :
							  	field.meta.add('types',TypeInfo.getTFunArgs(args),type.pos);
					 	
					 	case TInst(t,params) :
								var typeName = Std.string( field.type.getParameters()[0] );
								field.meta.add('types',[macro $v{typeName}],type.pos);
						
						case TAnonymous(a) : 
								field.meta.add('types',[macro "Dynamic"],type.pos);

						case TDynamic(t) :
								field.meta.add('types',[macro "Dynamic"],type.pos);

						case TEnum(t,params) :
								var typeName = Std.string( field.type.getParameters()[0] );
								field.meta.add('types',[macro $v{typeName}],type.pos);

						default:
					}
					
				}

				if(extensionFns.exists(name)){
					extensionFns.get(name)();
				}
			}
		}
	}
}
#end