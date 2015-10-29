package intravenous.messaging;

import intravenous.task.TaskDef;

typedef CommandDef = {
	> TaskDef,
	f:String,
	i:Int,
	sequenceController:Bool,
	?async : Bool,
	?skip : Bool,
}