package iv247.intravenous.messaging;

import iv247.intravenous.ioc.IInjector;

class CommandSequencer implements Sequencer
{

	private var sequence: SequenceDef;
	private var injector: IInjector;

	private var currentCommandDefs : Array<CommandDef>;
	private var currentArgs : Array<Dynamic>;
	private var currentCommandDefIndex : Int = 0;

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

	private function startSequence(){
		if(sequence.interceptors != null){
			callCommands(sequence.interceptors,[sequence.message,this]);
		}

		if(sequence.commands != null){
			callCommands(sequence.commands,[sequence.message]);
		}

		if(sequence.completeMethods != null){
			callCommands(sequence.completeMethods,[sequence.message]);
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
	public function resume(){
		if(stopped){
			stopped = false;
			startSequence();
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

         currentCommandDefs = commandDefs;
         currentArgs = args;		
         running = true;	

		for(i in startIndex...commandDefs.length){

			ref = commandDefs[i];			
			currentCommandDefIndex = i;

			if(stopped){	
				running = false;
				return;
			}

			if(ref.async){
				args.push(callback);
				currentCommandDefIndex++;
				stop();
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
		commandDefsComplete(commandDefs);
	}

	private function commandDefsComplete(commandDefs:Array<CommandDef>){
		if(commandDefs == sequence.interceptors){
			sequence.interceptors = null;	
		}
		else if(commandDefs == sequence.commands){
			sequence.commands = null;		
		}else{
			sequence.completeMethods = null;
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

