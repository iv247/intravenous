package iv247.intravenous.messaging;

import iv247.intravenous.ioc.IInjector;

class CommandSequencer implements Sequencer
{

	private var sequence: SequenceDef;
	private var injector: IInjector;

	private var currentCommandDefs : Array<CommandDef>;
	private var currentArgs : Array<Dynamic>;
	private var currentCommandDefIndex : Int = 0;

	private var stopped:Bool;
	private var started:Bool;

	public function new(sequence:SequenceDef, injector:IInjector){
		this.sequence = sequence;
		this.injector = injector;
	}


	public function start(){		
		if(started){
			throw "Command Sequence has already been started";
		}

		started = true;

		if(sequence.interceptors != null){
			callCommands(sequence.interceptors,[sequence.message,this]);
		}

		if(stopped){
			setCurrentCommandInfo(sequence.commands,0,[sequence.message]);
			return;
		}

		if(sequence.commands != null){
			callCommands(sequence.commands,[sequence.message]);
		}

		if(stopped){
			setCurrentCommandInfo(sequence.resultCommands,0,[sequence.message]);
			return;
		}

		if(sequence.resultCommands != null){
			callCommands(sequence.resultCommands,[sequence.message]);
		}
	}

	private function setCurrentCommandInfo(commandDefs,commandDefIndex,args):Void {
		currentCommandDefs = commandDefs;
		currentCommandDefIndex = commandDefIndex;
		currentArgs = args;
	}

	/*
	Stop the command sqequence from calling more commands. The current command will still be executed 
	*/
	public function stop(){
		stopped = true;
	}
	
	/*
	Continue the command sequence 
	*/
	public function continueSequence(){
		if(stopped){
			stopped = false;
			callCommands(currentCommandDefs,currentArgs,currentCommandDefIndex);
		}
	}

	/*
	Cancel the command sequence 
	*/
	public function cancel(){
		stopped = true;
	}

	public function callCommands(commandDefs:Array<CommandDef>,args:Array<Dynamic>,?startIndex:Int=0):Void{
		var ref,
            instance,
            result;

		for(i in startIndex...commandDefs.length){
			if(stopped){
				currentCommandDefs = commandDefs;
				currentCommandDefIndex = i;
				currentArgs = args;
				return;
			}

			ref = commandDefs[i];
			if( ref.async ){
				args.push(callback);
			}

			result =
			switch(ref.t){
				case TObject:
                    //ref.o is a class in this case
                    instance = (injector != null) ? injector.instantiate(ref.o) : Type.createInstance(ref.o ,[]);
                    Reflect.callMethod( instance , Reflect.field(instance,ref.f), args);
				case TClass(c):
					Reflect.callMethod(ref.o, Reflect.field(ref.o, ref.f), args);
				case _: //todo: throw error
						//errorHandler('callCommands',ref);
						null;
			}

			if(result != null){
				stop();				
			}
		}
	}

	private function callback(restart:Bool):Void {
		if(restart){
			continueSequence();
		}else{
			cancel();
		}	
	}
}

