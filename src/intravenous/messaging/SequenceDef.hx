
package intravenous.messaging;

typedef SequenceDef = {
	commands : Array<CommandDef>,
	processor : MessageProcessor,
	message : Dynamic
};