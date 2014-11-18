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

		for(field in type.fields.get()){
			

			if(field.meta.has('type')){
				return;
			}

			for (name in metaNames) {
				if(field.meta.has(name)){
					trace('has inject',field.name);
					field.meta.add('types',[macro "String"],type.pos);
				}
			}
		}
	}
}
#end