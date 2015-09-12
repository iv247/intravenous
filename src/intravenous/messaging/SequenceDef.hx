
package intravenous.messaging;

typedef SequenceDef = {
	interceptors : Dynamic,
	commands : Dynamic,
	completeMethods : Dynamic,
	processor : MessageProcessor,
	message : Dynamic
};