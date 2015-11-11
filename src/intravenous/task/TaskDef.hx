package intravenous.task;

typedef TaskDef = {
	@:optional var done:Void->Void;
	function execute(arg:Dynamic):Void;
}


typedef TaskRef = {
	o:Task,
	?fn:String
}

private abstract Either<T1:TaskDef,T2:Class<TaskDef>> (Dynamic) from TaskDef to TaskDef from Class<TaskDef> to Class<TaskDef> {}

abstract Task(Either<TaskDef,Class<TaskDef>>) from Either<TaskDef,Class<TaskDef>> to Either<TaskDef,Class<TaskDef>> {}