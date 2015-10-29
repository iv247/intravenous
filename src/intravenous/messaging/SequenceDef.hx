package intravenous.messaging;

typedef SequenceDef = {
	commands : Array<CommandDef>,
	message : Dynamic,
	?onComplete:Sequencer->Void,
	?onFail:Dynamic->Void
};