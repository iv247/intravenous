package intravenous.ioc.internal;

import intravenous.ioc.mock.MockObject;
import intravenous.ioc.mock.MockEnum;


using buddy.Should;

class InjectableSpec extends buddy.BuddySuite  {
	  public function new(){
	  	var inj:Injectable<Enum<Dynamic>,Class<Dynamic>>;

		  describe('Injectable types', {
			 it('can be an enum',{
			 	inj = MockEnum;
			 	inj.should.be(MockEnum);
			 });

			 it('can be a class',{
		  	 	inj = MockObject;
		  	 	inj.should.be(MockObject);
		  	 });

		  	 it('can not be an instance',{
			  	inj = new MockObject();
				(inj == null).should.be(true);
			 });

		  	 it('can be made from a class path',{
		  	 	inj = 'intravenous.ioc.mock.MockObject';
		  	 	inj.should.be(MockObject);
		  	 });

		     it('can be made from an enum path',{
		     	inj = 'intravenous.ioc.mock.MockEnum';
		     	inj.should.be(MockEnum);
		     });
		     
		     it('can not be made from invalid paths',{
		     	inj = 'intravenous.ioc.NotAClass';
		     	inj.should.be(null);
		     });

		     it('can be made from a path string var typed as dynamic', {
		     	var test:Dynamic;
		     	test = 'intravenous.ioc.mock.MockEnum';
		     	inj = test;
		     	inj.should.be(MockEnum);
		     });
		  });

		  describe('isClass/isAClass',{
		  	it('should return true if object is a class', function(){
		  		inj = MockObject;
		  		inj.isClass().should.be(true);
		  		Injectable.isAClass(inj).should.be(true);
		  	});

		  	it('should return false if object is an enum', function(){
		  		var inj:Injectable<Enum<Dynamic>,Class<Dynamic>> = MockEnum;
		  		inj.isClass().should.be(false);
		  		Injectable.isAClass(inj).should.be(false);
		  	});
		  });

		  describe('isEnum/isAEnum',{
		  	it('should return true if object is an enum', function(){
		  		inj = intravenous.ioc.mock.MockEnum;
		  		inj.isEnum().should.be(true);
		  		Injectable.isAnEnum(inj).should.be(true);
		  	});

		  	it('should return false if object is a class', function(){
		  		inj = MockObject;
		  		inj.isEnum().should.be(false);
		  		Injectable.isAnEnum(inj).should.be(false);
		  	});
		  });
	  }
}
