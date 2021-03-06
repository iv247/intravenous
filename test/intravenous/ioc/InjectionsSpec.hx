package intravenous.ioc;

import buddy.BuddySuite;
import intravenous.ioc.mock.*;
import intravenous.ioc.mock.MockConstructorArg;
import intravenous.ioc.mock.InjectionMock;
import intravenous.ioc.IV;
import buddy.CompilationShould;


using buddy.Should;

class InjectionsSpec extends BuddySuite {
    public function new() {
        describe("IInjector implementation", {
            var iv;

            beforeEach({
                iv = new IV();                                
            });

            it("should instantiate objects", {
                Foo.instantiated = false;
                iv.instantiate(Foo);
                Foo.instantiated.should.be(true);
            });

            it("should instantiate objects with constructor args when constructor is annotated with inject",{
                var object:MockConstructorArg;

                iv.mapTransient(MockObject,MockObject);
                
                object = iv.instantiate(MockConstructorArg);

                object.mock.should.not.be(null);
            });

            it("should use injections id's if available for constructor args", {
                var mock1, mock2, object:MockConstructorArg.WithId;

                iv.mapPersistent(MockObject,MockObject,"mockId");
                iv.mapPersistent(MockObject,MockObject,"mockId2");

                mock1 = iv.getInstance(intravenous.ioc.mock.MockObject,"mockId");
                mock2 = iv.getInstance(intravenous.ioc.mock.MockObject,"mockId2");

                object = iv.instantiate(WithId);

                object.mockWithId.should.be(mock1);
                object.mockWithId2.should.be(mock2);
                object.noId.should.be(null);
            });

            it("should inject 'inject' annotated properties on an object if mapping exists",{
                var object = new InjectionMock();

                iv.mapTransient(InjectedObject,InjectedObject);
                iv.injectInto(object);

                object.injectedObject.should.not.be(null);
                //mapping not created
                object.injectedObjectWithId.should.be(null);
            });

            it("should inject 'inject' annotated properties with an id", {
                var object = new InjectionMock();

                iv.mapTransient(InjectedObject,InjectedObject,"injectedObjectId");
                iv.injectInto(object);

                object.injectedObjectWithId.should.not.be(null);
            });

            it("should inject 'injected' annotated properties defined on a super class", {
                var subclass = new SubClassInjectionMock();

                iv.mapTransient(InjectedObject,InjectedObject);

                iv.injectInto(subclass);

                subclass.injectedObject.should.not.be(null);
            });

            describe("calling inject annotated methods", {
                
                it("should have arguments injected",{
                    var injectedObject = new InjectedObject(),
                        object = new InjectionMock(),
                        result;
                    
                    iv.mapValue(InjectedObject,injectedObject);

                    result = iv.call("injectableMethod", object);

                    injectedObject.should.be(result);
                });

                it("should use argument id's if set",{
                    var injectedObject = new InjectedObject(),
                        injectedObjectWithId = new InjectedObject(),
                        object = new InjectionMock(),
                        result;
                    
                    iv.mapValue(InjectedObject,injectedObjectWithId,"injectedObjectId");

                    result = iv.call("injectableMethodWithId", object); 

                    injectedObjectWithId.should.be(result.injectedObjectWithId);
                });

                it("should support optional arguments",{
                    var injectedObjectWithId = new InjectedObject(),
                        object = new InjectionMock(),
                        result : {
                                  injectedObjectWithId : InjectedObject,
                                  injectedObject : InjectedObject
                              };
                    
                    iv.mapValue(InjectedObject,injectedObjectWithId,"injectedObjectId");

                    result = iv.call("injectableMethodWithOptionalArg", object);

                    result.injectedObjectWithId.should.be(injectedObjectWithId);
                });
            });

            describe("mapped classes",{
                it("should have their 'inject' annotated properties injected",{
                    var injectionMock:InjectionMock;

                    iv.mapTransient(InjectedObject,InjectedObject);
                    iv.mapTransient(InjectionMock,InjectionMock);
                    injectionMock = iv.getInstance(InjectionMock);
                    injectionMock.injectedObject.should.not.be(null);
                    

                });

                it("should not inject properties that are not mapped",{
                    var injectionMock:InjectionMock;
                    iv.mapTransient(InjectionMock,InjectionMock);
                    injectionMock = iv.getInstance(InjectionMock);
                    injectionMock.injectedObject.should.be(null);
                });

                it("should use the property's inject id if set", {
                    var injectedObjectWithId = new InjectedObject(),
                        injectionMock;

                    iv.mapTransient(InjectionMock,InjectionMock);
                    iv.mapValue(InjectedObject,injectedObjectWithId, "injectedObjectId");

                    injectionMock = iv.getInstance(InjectionMock);

                    injectedObjectWithId.should.be(  injectionMock.injectedObjectWithId );

                });

                it("should have constructor args injected when instantiated",{
                    var ctorInjectionMock:CtorInjectionMock;

                    iv.mapTransient(CtorInjectionMock,CtorInjectionMock);

                    iv.mapTransient(InjectedObject,InjectedObject,"injectedObjectId");
                    iv.mapTransient(InjectedObject,InjectedObject);

                    ctorInjectionMock = iv.getInstance(CtorInjectionMock);

                    ctorInjectionMock.ctorObject.should.not.be(null);
                    ctorInjectionMock.ctorObjectWithId.should.not.be(null);

                });

            });

            describe('Compilation errors', {
                it('should occur when trying to map incompatible classes', {
                    CompilationShould.failFor(iv.mapTransient(InjectedObject,MockObject));
                });
            });
        });
    }
}
