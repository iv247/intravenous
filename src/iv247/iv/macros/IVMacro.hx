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
		
		if(metaNames == null) {
			metaNames = [];
		}

		metaNames = metaNames.concat(names);

		if(!onGenerateAdded){
			Context.onGenerate(onGenerate);
			onGenerateAdded = true;
		}

		return Context.getBuildFields();
	}

	static function onGenerate(types : Array<haxe.macro.Type>) : Void {
		trace(metaNames);
		for(type in types){
			switch type {
				case TInst(ref, params): 
					addTypeMetaToClass ( ref.get() );	
				default:
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
			
			if(field.meta.has("types")){
				return;
			}			

			for (name in metaNames) {
				if(field.meta.has(name)){
					var typeName = Std.string( field.type.getParameters()[0] );
					field.meta.add('types',[macro $v{typeName}],type.pos);
				}
			}
		}
	}

	static function addConstructorTypes(ctor:ClassField) : Void {
		var ctorParams : Array<TFunc> = ctor.type.getParameters()[0];
		var metaParams:Array<haxe.macro.Expr> = [];
		
		for (param in ctorParams){
			var name =  Std.string(param.t.getParameters()[0]);
			var exp = macro {
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