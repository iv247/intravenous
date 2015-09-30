package intravenous.messaging;

import intravenous.ioc.IInjector;

class CommandSequencer implements Sequencer
{

	private var sequence: SequenceDef;
	private var injector: IInjector;

	private var currentCommandDefs : Array<CommandDef>;
	public var currentCommandDefIndex : Int = 0;

	public var stopped(default,null):Bool;
	public var started(default,null):Bool;
	private var running:Bool = false;

	public function new(sequence:SequenceDef, injector:IInjector){
		this.sequence = sequence;
		this.injector = injector;
	}


	public function start(){		
		if(started){
			throw "Command Sequence has already been started";
		}

		started = true;
		startSequence();
	}
	/*
		Stop the command sqequence from calling more commands. The current command will still be executed
	*/
	public function stop(){
		stopped = true;
	}


	/*
		Cancel the command sequence
	*/
	public function cancel(){
		stopped = true;
	}

	/*
		Continue the command sequence
	*/
	public function resume(){
		if(stopped){
			stopped = false;
			startSequence();
		}
	}

	private function startSequence(){
		var cmdsCompleted = false;

		if( !isEmpty(sequence.interceptors) ){
			callCommands(sequence.interceptors,[sequence.message]);
		}
		if( !isEmpty(sequence.commands) && !stopped ){
			callCommands(sequence.commands,[sequence.message]);
		}

		if( !isEmpty(sequence.completeMethods) && !stopped ){
			callCommands(sequence.completeMethods,[sequence.message]);
		}
	}

	private function isEmpty(arr:Array<CommandDef>):Bool {
		return (arr == null || arr.length == 0);
	}

	public function callCommands(commandDefs:Array<CommandDef>,args:Array<Dynamic>):Void{
		var instance, 
			result;

		while(commandDefs.length > 0){
			var currentArgs = args.copy();

			if(stopped){
				running = false;
				return;
			}

			var ref = commandDefs.shift() ;

			if(ref.skip){
				continue;
			}

			if(ref.async){
				currentArgs = args.concat([this.callback]);
				stop();
			}
			if(ref.sequenceController){
				currentArgs = currentArgs.concat([this]);
			}
			result =
			switch(ref.t){
				case TObject:
					//ref.o is a class in this case
					instance = (injector != null) ? injector.instantiate(ref.o) : Type.createInstance(ref.o ,[]);
					Reflect.callMethod( instance , Reflect.field(instance,ref.f), currentArgs);
				case TClass(c):
					Reflect.callMethod(ref.o, Reflect.field(ref.o, ref.f), currentArgs);
				case _: //todo: throw error
						// errorHandler('callCommands',ref);
					null;
			}

			if(result != null){
				stop();
			}
		}
	}

	private function callback(restart:Bool):Void {
		if(restart && running){
			stopped = false;
		}else if(restart){
			resume();
		}else{
			cancel();
		}	
	}
}

