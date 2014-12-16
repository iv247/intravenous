
package iv247.intravenous.messaging;


class MessagingMacro 
{
	public static var messageTypes : Array<String>;

	private static var onGenerateAdded : Bool = false;

	public static function buildCommand():Array<haxe.macro.Expr.Field> {

		if(!onGenerateAdded){
			haxe.macro.Context.onGenerate(onGenerate);
			onGenerateAdded = true;
		}

		return null;
	}

	static function onGenerate(types : Array<haxe.macro.Type>) : Void {
		for(type in types){
			switch type {
				case TInst(ref, params): 
					addTypeMetaToClass ( ref.get() );
				default:
			}
		}
	}

	static function addTypeMetaToClass(type : haxe.macro.Type.ClassType) : Void {
		var types;

		if(type.isInterface){			
			return;
		}
		
		if(type.meta.has('command')){
			for(field in type.fields.get()){
				if(field.name == 'execute'){

					switch(field.type){
						case TFun(args,_): 						
							types = iv247.util.macro.TypeInfo.getTFunArgs(args);
							type.meta.add('messageType', types, type.pos );
							return;
						default:
					}
				}
			}
		}

	}

}