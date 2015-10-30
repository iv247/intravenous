package intravenous.task;

import intravenous.ioc.IInjector;
import intravenous.messaging.CommandSequencer;
import intravenous.task.TaskDef;


class TaskRunner {
	public var stopped(default,null):Bool; 
	public var running(default,null):Bool; 
	public var execution(default,null):Execution;

	var taskDefs:Array<TaskRef>;
	var injector:IInjector;
	var onComplete:Void->Void;

	public function new(type:Execution,completeHandler:Void->Void,?inj:IInjector){
		taskDefs = [];
		injector = inj;
		onComplete = completeHandler;

		execution = type;
	}

	public function add(task:Task, ?fn:String='execute'):TaskRunner{
		taskDefs.push({ o:task, fn:fn });
		return this;
	}

	public function start(model:Dynamic){
		if(!running){
			executeTasks([model]);
		}
	}

	public function stop(){
		stopped = true;
		running = false;
	}

	function executeTasks(args:Array<Dynamic>){
		var instance, 
			result,
			currentArgs,
			ref;

		while(taskDefs.length > 0){
			currentArgs = args.copy();

			if(stopped){
				running = false;
				break;
			}

			ref = taskDefs.shift();

			instance =
			switch(Type.typeof(ref.o)){
				case TObject:
					//ref.o is a class in this case
					cast (injector != null) ? injector.instantiate(ref.o) : Type.createInstance(ref.o ,[]);
				case TClass(c):
					cast ref.o;		
				case _: //todo: throw error
					// errorHandler('callCommands',ref);
					null;
			}

			if(execution == Execution.SEQUENTIAL) {
				if(isTaskAsync(instance,ref.fn)){ 
					stop();
				}
				result = Reflect.callMethod(instance, Reflect.field(ref.o, ref.fn), currentArgs);

				if(result != null){
					stop();
				}
			}else{
				instance.callback = onComplete;
			}
		
		}
	}

	function isTaskAsync(obj:Dynamic,fn:String){		
		return Reflect.hasField(obj,'callback');
	}
}

@:enum
abstract Execution(String) {
	var PARALLEL = 'parallel';
	var SEQUENTIAL  = 'sequential';
}

@:forward
abstract Parallel(TaskRunner) to TaskRunner  {
	public function new(onComplete:Void->Void,?injector:IInjector){
		this = new TaskRunner(Execution.PARALLEL,onComplete,injector);
	}
}
@:forward
abstract Sequential(TaskRunner) to TaskRunner {
	public function new(onComplete:Void->Void,?injector:IInjector){
		this = new TaskRunner(Execution.SEQUENTIAL,onComplete,injector);
	}
}