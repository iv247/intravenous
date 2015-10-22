package intravenous.messaging;

import intravenous.ioc.IInjector;

class CommandSequencer implements Sequencer
{

	private var sequence: SequenceDef;
	private var injector: IInjector;
	private var currentCommandDefs : Array<CommandDef>;
	private var running:Bool = false;

	public var currentCommandDefIndex : Int = 0;

	public var stopped(default,null):Bool;
	public var started(default,null):Bool;

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
		running = false;
	}

	/*
		Cancel the command sequence
	*/
	public function cancel(){
		stopped = true;
		done();
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

	private function done(){
		if(sequence.onComplete != null){
			sequence.onComplete(this);
		}
	}

	private function startSequence(){
		if( !isEmpty(sequence.commands) && !stopped ){
			callCommands(sequence.commands,[sequence.message]);
		}

		if(!stopped){
			stopped = true;
			done();
		}
	}

	private function isEmpty(arr:Array<CommandDef>):Bool {
		return (arr == null || arr.length == 0);
	}

	private function callCommands(commandDefs:Array<CommandDef>,args:Array<Dynamic>):Void{
		var instance, 
			result,
			currentArgs,
			ref;

		while(commandDefs.length > 0){
			currentArgs = args.copy();

			if(stopped){
				running = false;
				break;
			}

			ref = commandDefs.shift();

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
			stop();
		}	
	}
}

