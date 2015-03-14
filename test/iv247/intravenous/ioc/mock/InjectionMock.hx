package iv247.intravenous.ioc.mock;
import iv247.intravenous.ioc.macros.IVMacro;

class InjectionMock {
	
	@inject public var injectedObject : InjectedObject;

	@inject("injectedObjectId") public var injectedObjectWithId : InjectedObject;

	public var nonInjectedObject : InjectedObject;
	public var postInjectedObject : InjectedObject;
	public var postInjectedObjectNoId : InjectedObject;

	@inject public function new(){

	}

	@inject 
	public function injectableMethod(injectedObject : InjectedObject) : InjectedObject {
		return injectedObject;
	}

	@inject(null,"injectedObjectId") 
	public function injectableMethodWithId(v1:InjectedObject,v2:InjectedObject) : Dynamic {
		var t = @ivmacro {"whatever";};
		trace(t);
		return {
			injectedObject : v1,
			injectedObjectWithId : v2
		}
	}

	@inject("injectedObjectId")
	public function injectableMethodWithOptionalArg(v1:InjectedObject,?v2:InjectedObject) : Dynamic {
		
		return {
			injectedObjectWithId : v1,
			injectedObject : v2
		}
	}

	@post("postInjectId")
	public function postInjectMethod(post:InjectedObject):Void {
		postInjectedObject = post;
	}

	@post
	public function anotherPostInjectMethod(post:InjectedObject):Void {
		postInjectedObjectNoId = post;
	}
}

class SubClassInjectionMock extends InjectionMock {

	public var subPostInjectedObject : InjectedObject;
	public var postCount : Int = 0;

	public function new(){
		super();
	}

	@post("postInjectId")
	override public function postInjectMethod(post:InjectedObject):Void {
		subPostInjectedObject = post;
		postCount++;
	}
}

class CtorInjectionMock extends InjectionMock {
	public var ctorObject : InjectedObject;
	public var ctorObjectWithId: InjectedObject;

	@inject(null,"injectedObjectId")
	public function new(io : InjectedObject, ioId : InjectedObject){
		ctorObject = io;
		ctorObjectWithId = ioId;
		super();
	}
}

class InjectedObject {
	public function new(){};
}