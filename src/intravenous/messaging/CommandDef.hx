package intravenous.messaging;

import intravenous.task.TaskDef;

typedef CommandDef = {
	> TaskRef,
	f:String,
	i:Int,
	sequenceController:Bool,
	?async : Bool,
	?skip : Bool,
}