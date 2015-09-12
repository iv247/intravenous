
package intravenous.messaging;

typedef CommandDef = {
	o:Dynamic,
	f:String,
	i:Int,
	t:Type.ValueType,
	?async : Bool
}