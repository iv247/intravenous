package iv247.iv.macros;
#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.Tools;
class IVMacro {
	
	public static var metaNames : Array<String>;

	private static var onGenerateAdded : Bool; 

	static public function buildMeta (names : Array<String>) : Array<Field> {

		var fields = Context.getBuildFields().copy(),
			newField;
		
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

	static private function addTFunArgs(args:Array<{t:Type,opt : Bool, name : String}>) : Array<haxe.macro.Expr> {
		var typeInfo = [],
			typeName; 
		for(arg in args){
			
			typeName = 
			switch (arg.t) {
				
				case TInst (t,parrms) :
					Std.string( arg.t.getParameters()[0] );

				case TEnum(t,params):
					Std.string( arg.t.getParameters()[0] );

				default :
					"Dynamic";

			};	

			var exp = macro {
					opt :  $v{untyped arg.opt},
					type : $v{typeName}
			};

			typeInfo.push(exp);
		}

		return typeInfo;
	}

	static function addTypeMetaToEnum(type : EnumType) : Void {
			
		for(field in type.constructs){
			if(field.meta.has('inject')){

				if(field.meta.has('types')){
					continue;
				}

				switch(field.type){
					case TFun(args,_): 						
						var types = addTFunArgs(args);

						field.meta.add('types',types,type.pos);

					default:
				}
			}
		}
	
	}

	static function	addTypeMetaToClass ( type : ClassType ) : Void {
		if(type.isInterface){			
			return;
		}

		if(type.constructor != null && type.constructor.get().meta.has("inject")){
			addConstructorTypes(type.constructor.get());
		}

		for(field in type.fields.get()){	

			for (name in metaNames) {
				
				if(field.meta.has("types")){
					continue;
				}	

				if(field.meta.has(name)){

					switch(field.type){
						
						case TFun(args,ret) :
							  addConstructorTypes(field);
					 	
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
			}
		}
	}

	static function addConstructorTypes(ctor:ClassField) : Void {
		var ctorParams : Array<TFunc> = ctor.type.getParameters()[0];
		var metaParams:Array<haxe.macro.Expr> = [],
			name,
			exp;
		
		for (param in ctorParams){
			name =  Std.string(param.t.getParameters()[0]);
			exp = macro {
				opt :  $v{untyped param.opt},
				type : $v{name}
			};

			metaParams.push(exp);
		}

		if(metaParams.length > 0){
			ctor.meta.add('types', metaParams, Context.currentPos());
		}
	}
}
#end