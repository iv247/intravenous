package iv247.intravenous.ioc;

using buddy.Should;

import iv247.intravenous.ioc.mock.InjectionMock;

class PostInjectionSpec extends buddy.BuddySuite {
	public function new() {
		var iv:IV;

		describe('IV, after injection into objects, ',{
			before({
				iv = new IV();

			});
			
			it("should call methods annotated with post",{
				var object = new InjectionMock(),
                    injectedObject = new InjectedObject();

                iv.mapValue(InjectedObject,injectedObject,"postInjectId");
                iv.mapValue(InjectedObject,injectedObject);

                iv.injectInto(object);

                object.postInjectedObject.should.be(injectedObject);
                object.postInjectedObjectNoId.should.be(injectedObject);
			});

			it("should only call post annotated method once if marked with override",{
				var object = new SubClassInjectionMock(),
                    injectedObject = new InjectedObject();

                iv.mapValue(InjectedObject,injectedObject,"postInjectId");
                iv.injectInto(object);

                object.subPostInjectedObject.should.be(injectedObject);
                object.postCount.should.be(1);
			});

			it("should call methods annotated with post on super classes",{
				var object = new SubClassInjectionMock(),
                    injectedObject = new InjectedObject();

                iv.mapValue(InjectedObject,injectedObject,"postInjectId");
                iv.mapValue(InjectedObject,injectedObject);

                iv.injectInto(object);

                object.postInjectedObjectNoId.should.be(injectedObject);
			});
		});
	}
}