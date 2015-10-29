package intravenous.task;

import haxe.ds.Either;
import intravenous.ioc.IInjector;
import intravenous.messaging.CommandSequencer;
import intravenous.task.TaskDef;

class TaskRunner {
	public var stopped(default,null):Bool; 
	public var running(default,null):Bool; 
	public var execution(default,null):Bool;

	var taskDefs:Array<TaskDef>;
	var injector:IInjector;
	var onComplete:Void->Void;

	public function new(type:Execution,completeHandler:Void->Void,?injector:IInjector){
		taskDefs = [];
		injector = injector;
		onComplete = completeHandler;

		execution = type;
	}

	public function add(task:Dynamic, ?fn:String='execute'):TaskRunner{
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
					(injector != null) ? injector.instantiate(ref.o) : Type.createInstance(ref.o ,[]);
				case TClass(c):
					instance = ref.o;		
				case _: //todo: throw error
					// errorHandler('callCommands',ref);
					null;
			}

			if(_isSequential){
				if(isTaskAsync(instance,ref.fn)){
					stop();
				}
				result = Reflect.callMethod(instance, Reflect.field(ref.o, ref.fn), currentArgs);

				if(result != null){
					stop();
				}
			}
			
		}
	}

	function isTaskAsync(obj:Dynamic,fn:String){
		var meta = haxe.rtti.Meta.getFields(obj);
		var fieldMeta = Reflect.field(meta,fn);
		return Reflect.hasField(fieldMeta,'async');
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




