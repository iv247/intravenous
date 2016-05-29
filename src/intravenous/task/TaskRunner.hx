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
	public function new(?injector:IInjector){
		this = new TaskRunner<T>(Execution.PARALLEL,injector);
	}
}
@:forward
abstract Sequential<T>(TaskRunner<T>) to TaskRunner<T> to Task{
	public function new<T>(?injector:IInjector){
		this = new TaskRunner<T>(Execution.SEQUENTIAL,injector);
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
	public var done:?Dynamic->Void;

	var taskDefs:Array<TaskRef>;
	var injector:IInjector;
	var completeFn:TaskResult<T>->Void;
	var openTaskRefs:Array<TaskRef>;
	var data:Dynamic;
	var taskResult:TaskResult<T>;
	var completed:Bool = false;
	var executed:Bool;

	public function new(type:Execution,?inj:IInjector){
		taskDefs = [];
		injector = inj;
		openTaskRefs = [];
		execution = type;
	}

	public function execute(model:Dynamic):TaskRunner<T>{	
		if(!executed){
			data = model;
			taskResult = new TaskResult(data,[]);
			executed = true;

			start(data);
		}else{
			throw 'execute can only be called once';
		}
		
		return this;
	}

	public function onComplete(fn:TaskResult<T>->Void):TaskRunner<T>{
		completeFn = fn;
		if(completed){
			fn(taskResult);
		}

		return this;
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
			completed = true;
			running = false;

			if(completeFn != null){
				completeFn(taskResult);
			}

			if(done != null){
				if(taskResult.faults.length > 0){
					done(taskResult.faults);
				}else{
					done();
				}
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
					(injector != null) ? injector.instantiate(cast ref.o) : Type.createInstance(cast ref.o ,[]);
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
						openTaskRefs.push(ref);
						#if !php
							instance.done = onParallelAsyncTaskComplete.bind(ref,_);
						#else
							instance.done = new PHPCallback(ref,this).done;
						#end
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
		if(fault != null){
		   addFault(fault);
		}
		start(data);
	}

	function addFault(fault:Dynamic){
		taskResult.faults.push({ data: this.data, fault: fault});
	}

	function isTaskAsync(type:Class<Dynamic>,fn:String){
		return Lambda.has(Type.getInstanceFields(type),fn);
	}
}

#if php
@:access(intravenous.task.TaskRunner)
class PHPCallback<T> {
	var ref:TaskRef;
	var runner:TaskRunner<T>;
	public function new(r,run){
		ref = r;
		runner = run;
	}

	public function done(fault:Dynamic){
		runner.onParallelAsyncTaskComplete(ref,fault);
	}
}
#end