package iv247.iv.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.Tools;

class IVMacro {
	
	public static var metaNames : Array<String>;

	private static var onGenerateAdded : Bool; 
	macro public static function test(expr:Expr) : Expr {

		metaNames.push('testing');
		return macro '';
	}
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
		
	}
}