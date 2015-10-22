package intravenous.task;

import intravenous.ioc.IInjector;
import intravenous.messaging.CommandSequencer;
import intravenous.task.TaskDef;


class ParallelTaskRunner {
	private var _taskdefs:Array<TaskDef>;
	private var _sequencer:CommandSequencer;
	private var _injector:IInjector;
	private var _onComplete:Void->Void;

	public function new(onComplete:Void->Void,?injector:IInjector){
		_taskdefs = [];
		_injector = injector;
		_onComplete = onComplete;
	}

	public function add(type:haxe.ds.Either<Class<Dynamic>,{}>,?fn:String='execute'):ParallelTaskRunner{
		_taskdefs.push({
			o:type,
			t:Type.typeof(type),
			f:fn
		});
		return this;
	}

	public function start(){
		// if(_sequencer != null){
		// 	_sequencer = new CommandSequencer({
		// 		commands: _taskdefs
		// 	},_onComplete);
		// 	_sequencer.start();
		// }

	}

}