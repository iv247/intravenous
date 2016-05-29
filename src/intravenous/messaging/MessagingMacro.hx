package intravenous.messaging;

#if macro
class MessagingMacro
{
	public static var messageTypes : Array<String>;

	static var onGenerateAdded : Bool = false;

	public static function buildCommand():Array<haxe.macro.Expr.Field> {

		if(!onGenerateAdded){
			haxe.macro.Context.onGenerate(onGenerate);
			onGenerateAdded = true;
		}

		return null;
	}

	static function onGenerate(types : Array<haxe.macro.Type>){
		for(type in types){
			switch type {
				case TInst(ref, params):
					addTypeMetaToClass ( ref.get() );
				default:
			}
		}
	}

	static function addTypeMetaToClass(type : haxe.macro.Type.ClassType){
		if(type.isInterface || type.meta.has('iv')){
			return;
		}

		if(type.meta.has('command')){
			addCommandClassTypes(type);
		}

		addMetaToClassFields(type);
	}

	static function addCommandClassTypes(type : haxe.macro.Type.ClassType){
		var types;
		if(!type.meta.has('messageTypes')){
			for(field in type.fields.get()){
				if(field.name == 'execute'){
					switch(field.type){
						case TFun(args,_):
							types = iv247.util.macro.TypeInfo.getTFunArgs(args);

							 if(isAsync(args)){
								type.meta.add('async',[],type.pos);
							 }

							 if(isSequenceController(args)){
							 	type.meta.add("controlSequence",[],type.pos);
							 }

							 type.meta.add('messageTypes', [types[0]], type.pos );
							return;
						case _:
					}
				}
			}
		}
	}

	static function isAsync(args) : Bool {
		return iv247.util.macro.TypeInfo.hasType(args, "intravenous.messaging.CallbackFunction");
	}

	static function isSequenceController(args) : Bool {
		var typeName = Type.getClassName(intravenous.messaging.CommandSequencer);
		return iv247.util.macro.TypeInfo.hasType(args,typeName);
	}

	static function addMetaToClassFields(type : haxe.macro.Type.ClassType){
		var types;

		for(field in type.fields.get()){
			if(field.meta.has("command")){
				switch(field.type){
						case TFun(args,ret) :
								if(!field.meta.has("controlSequence") && isSequenceController(args)){
							   		field.meta.add('controlSequence',[],field.pos);
								}
								if(!field.meta.has("async") && isAsync(args)){
									field.meta.add('async',[],field.pos);
								}
						default: null;
				}
			}

		}
	}
}
#end
