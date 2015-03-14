
package iv247.intravenous.messaging;

typedef SequenceDef = {
	interceptors : Dynamic,
	commands : Dynamic,
	resultCommands : Dynamic,
	processor : MessageProcessor,
	message : Dynamic
};