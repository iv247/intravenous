package intravenous.task;

import intravenous.ioc.IInjector;
import intravenous.task.TaskDef;


@:enum
abstract Execution(String) {
	var PARALLEL = 'parallel';
	var SEQUENTIAL  = 'sequential';
}

@:forward
abstract Parallel(TaskRunner) to TaskRunner to Task   {
	public function new(onComplete:Void->Void,?injector:IInjector){
		this = new TaskRunner(Execution.PARALLEL,onComplete,injector);
	}
}
@:forward
abstract Sequential(TaskRunner) to TaskRunner to Task {
	public function new(onComplete:Void->Void,?injector:IInjector){
		this = new TaskRunner(Execution.SEQUENTIAL,onComplete,injector);
	}
}

class TaskRunner {
	public var stopped(default,null):Bool;
	public var running(default,null):Bool;
	public var execution(default,null):Execution;
	public var done:Void->Void;

	var taskDefs:Array<TaskRef>;
	var injector:IInjector;
	var onComplete:Void->Void;
	var openTaskRefs:Array<TaskRef>;
	var data:Dynamic;

	public function new(type:Execution,?completeHandler:Void->Void,?inj:IInjector){
		taskDefs = [];
		injector = inj;
		onComplete = completeHandler;
		openTaskRefs = [];
		execution = type;
	}

	public function execute(model:Dynamic){
		data = model;
		start(data);
	}

	public function add(task:Task):TaskRunner{
		taskDefs.push({ o:task, fn:'execute'});
		return this;
	}

	public function stop(){
		stopped = true;
		running = false;
	}

	function start(model:Dynamic){
		if(!running){
			stopped = false;
			running = true;
			executeTasks([model]);
		}

		if(!stopped && openTaskRefs.length == 0){
			stopped = true;
			if(onComplete != null){
				onComplete();
			}
			if(done != null){
				done();
			}
		}
	}

	function executeTasks(args:Array<Dynamic>){
		var instance:Dynamic,
			result,
			currentArgs,
			ref;

		while(taskDefs.length > 0){
			var isAsync;
			var type;

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
					(injector != null) ? injector.instantiate(ref.o) : Type.createInstance(ref.o ,[]);
				case TClass(c):
					 ref.o;
				case _: //todo: throw error
					// errorHandler('callCommands',ref);
					null;
			}

			type = Type.getClass(instance);

			isAsync = isTaskAsync(type,'done');

			result =
			switch(execution){
				case Execution.SEQUENTIAL:
					if(isAsync){
						instance.done = onTaskComplete;
						stop();
					}

					Reflect.callMethod(instance, Reflect.field(instance, ref.fn), currentArgs);

				case Execution.PARALLEL:
					if(isAsync){
						instance.done = onParallelAsyncTaskComplete.bind(ref);
						openTaskRefs.push(ref);
					}
					
					Reflect.callMethod(instance, Reflect.field(instance, ref.fn), currentArgs);
			}

		}
	}

	function onTaskComplete():Void {
		start(this.data);
	}

	function onParallelAsyncTaskComplete(ref:TaskRef):Void {
		openTaskRefs.remove(ref);
		onTaskComplete();
	}

	function isTaskAsync(type:Class<Dynamic>,fn:String){
		return Lambda.has(Type.getInstanceFields(type),fn);
	}
}
