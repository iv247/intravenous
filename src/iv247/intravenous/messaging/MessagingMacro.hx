
package iv247.intravenous.messaging;

#if macro
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
			addCommandClassTypes(type);
		}

	}

	static function addCommandClassTypes(type : haxe.macro.Type.ClassType) : Void {
		var types;
		for(field in type.fields.get()){
			if(field.name == 'execute'){
				switch(field.type){
					case TFun(args,_): 						
						types = iv247.util.macro.TypeInfo.getTFunArgs(args);
						if(isAsync(args)){
							type.meta.add('async',[],type.pos);
						}

						if(isIntercept(args)){
							type.meta.add("intercept",types,type.pos);
						}

						type.meta.add('messageTypes', types, type.pos );
						return;
					default:
				}
			}
		}
	}

	static function isAsync(args) : Bool {
		return iv247.util.macro.TypeInfo.hasType(args, "iv247.intravenous.messaging.CallbackFunction");
	}

	static function isIntercept(args) : Bool {
		var typeName = Type.getClassName(iv247.intravenous.messaging.CommandSequencer);
		return iv247.util.macro.TypeInfo.hasType(args,typeName);
	}

	static function addInterceptToClassFields(type : haxe.macro.Type.ClassType) : Void {
		var types;
		for(field in type.fields.get()){	
			if(field.meta.has("command")){
				types =
				switch(field.type){						
						case TFun(args,ret) :
							  	iv247.util.macro.TypeInfo.getTFunArgs(args);
						default: null;
				}
			}
			
			if(types != null && types.length > 1){
				field.meta.add('intercept',[],field.pos);
			}				
		}
	}
}
#end