
package intravenous.messaging;

typedef CommandDef = {
	o:Dynamic,
	f:String,
	i:Int,
	t:Type.ValueType,
	sequenceController:Bool,
	?async : Bool,
	?skip : Bool,
}