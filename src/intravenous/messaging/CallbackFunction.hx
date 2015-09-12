package intravenous.messaging;

@:callable
abstract CallbackFunction(Bool->Void) from  Bool->Void to Bool->Void {}