
package iv247.util.macro;

import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.ExprTools;

class TypeInfo 
{
	#if macro
	static public function getTFunArgs(args:Array<{t:Type,opt : Bool, name : String}>) : Array<haxe.macro.Expr> {
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

	static public function hasType(args:Array<{t:Type,opt : Bool, name : String}>, typeName:String) : Bool {
		
		return Lambda.exists(args, function(item) : Bool{
			var paramTypeName = Std.string(item.t.getParameters()[0]);
			return (paramTypeName == typeName);

		});		
	}
	#end

}