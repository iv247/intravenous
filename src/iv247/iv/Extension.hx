package iv247.iv;

 interface Extension {
	public function onInjection(injector : IInjector) : Void;
	public function init (injector : IInjector) : Void;
}