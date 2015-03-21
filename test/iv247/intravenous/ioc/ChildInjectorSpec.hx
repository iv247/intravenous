package iv247.intravenous.ioc;

import iv247.intravenous.ioc.mock.InjectionMock;

using buddy.Should;

class ChildInjectorSpec extends buddy.BuddySuite
{	
	public var iv:IInjector;

	public function new(){
		describe("Child injectors",{
			var iv, setParent;
			
			setParent = function(parent:IInjector,child:IInjector):Void{
				child.parent = parent;
			};

			before({
				iv = new IV();
			});

			it("should optionally add a parent injector through it's constructor",{
				var childInjector = new IV(iv);
				childInjector.parent.should.be(iv);
			});

			it("should assign a parent injector through it's accessor", function(){
				var childInjector = new IV();
				childInjector.parent = iv;
				childInjector.parent.should.be(iv);
			});

			it("should throw an error if the parent wants to be it's own child (circular reference)",{
				setParent.bind(iv,iv).should.throwType(String);
			});

			it("should throw an error if a parent wants to be a child (circular reference)",{
				var childInjector = new IV(iv);
				setParent.bind(childInjector,iv).should.throwType(String);
			});

			it("should allow removal of their parent",{
				var childInjector = new IV();
				childInjector.parent = iv;
				childInjector.parent = null;
				childInjector.parent.should.be(null);
			});

			it("should return mapped objects from their parents if child mapping doesn't exist",{
				var object = new InjectionMock(),
					childInjector = new IV(iv),
					result;

				iv.mapValue(InjectionMock, object);
				result = childInjector.getInstance(InjectionMock);
				object.should.be(result);

			});		

			it("should not return objects mapped on parent if child mapping exists",{
				var object = new InjectionMock(),
					childMappedObject = new InjectionMock(),
					childInjector = new IV(iv);

				iv.mapValue(InjectionMock, object);
				childInjector.mapValue(InjectionMock, childMappedObject);

				object.should.not.be(childInjector.getInstance(InjectionMock));
				childMappedObject.should.be(childInjector.getInstance(InjectionMock));
			});

			it("should return null on unmapped object on parent and child",{
				var childInjector = new IV(iv),
					result = new InjectionMock();				
					result = childInjector.getInstance(InjectionMock);
					
					result.should.be(null);
			});{}
		});
	}
}