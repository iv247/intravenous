package intravenous.task;

import intravenous.ioc.IInjector;
import intravenous.task.TaskDef;


@:enum
abstract Execution(String) {
	var PARALLEL = 'parallel';
	var SEQUENTIAL  = 'sequential';
}

@:forward
abstract Parallel<T>(TaskRunner<T>) to TaskRunner<T> to Task  {
	public function new(onComplete:TaskResult<T>->Void,?injector:IInjector){
		this = new TaskRunner<T>(Execution.PARALLEL,onComplete,injector);
	}
}
@:forward
abstract Sequential<T>(TaskRunner<T>) to TaskRunner<T> to Task{
	public function new<T>(onComplete:TaskResult<T>->Void,?injector:IInjector){
		this = new TaskRunner<T>(Execution.SEQUENTIAL,onComplete,injector);
	}
}

class TaskResult<T>  {
	public var resultData(default,null):T;
	public var faults(default,null):Array<TaskFault<T>>;

	public function new(data:T,taskFaults:Array<TaskFault<T>>){
		resultData = data;
		faults = taskFaults;
	}
}

typedef TaskFault<T> = {
	var fault:Dynamic;
	var data:T;
}

class TaskRunner<T> {
	public var stopped(default,null):Bool;
	public var running(default,null):Bool;
	public var execution(default,null):Execution;
	public var done:Dynamic->Void;

	var taskDefs:Array<TaskRef>;
	var injector:IInjector;
	var onComplete:TaskResult<T>->Void;
	var openTaskRefs:Array<TaskRef>;
	var data:Dynamic;
	var faults:Array<TaskFault<T>>;

	public function new(type:Execution,?completeHandler:TaskResult<T>->Void,?inj:IInjector){
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

	public function add(task:Task):TaskRunner<T>{
		taskDefs.push({ o:task, fn:'execute'});
		return this;
	}

	public function stop():TaskRunner<T>{
		stopped = true;
		running = false;
		return this;
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
				onComplete(new TaskResult(data,faults));
			}
			if(done != null){
				done(faults);
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
						instance.done = onParallelAsyncTaskComplete.bind(ref,_);
						openTaskRefs.push(ref);
					}

					Reflect.callMethod(instance, Reflect.field(instance, ref.fn), currentArgs);
			}

		}
	}

	function onTaskComplete(?fault:Dynamic) {
		if(fault == null){
			start(this.data);
		}else {
			addFault(fault);
		}
	}

	function onParallelAsyncTaskComplete(ref:TaskRef,?fault:Dynamic) {
		openTaskRefs.remove(ref);
		addFault(fault);
		start(this.data);
	}

	function addFault(fault:Dynamic){
		if(fault==null){
			return;
		}

		if(faults == null){
			faults = [];
		}

		faults.push({ data: this.data, fault: fault});
	}

	function isTaskAsync(type:Class<Dynamic>,fn:String){
		return Lambda.has(Type.getInstanceFields(type),fn);
	}
}