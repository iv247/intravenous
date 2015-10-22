package intravenous.messaging;

import intravenous.task.TaskDef;

typedef CommandDef = {
	> TaskDef,
	i:Int,
	sequenceController:Bool,
	?async : Bool,
	?skip : Bool,
}