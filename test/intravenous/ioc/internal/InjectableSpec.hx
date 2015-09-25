package intravenous.ioc.internal;

import intravenous.ioc.mock.MockObject;
import intravenous.ioc.mock.MockEnum;

using buddy.Should;

class InjectableSpec extends buddy.BuddySuite  {
	  public function new(){
		  describe('Injectable types', {
			 it('can be an enum');
		  	 it('can be a class');
		  	 it('can be made from a class path');
		     it('can be made from an enum path');
		  });

		  describe('isClass/isAClass',{
		  	it('should return true if object is a class', function(){
		  		var inj:Injectable<Enum<Dynamic>,Class<Dynamic>> = MockObject;
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
		  		var inj:Injectable<Enum<Dynamic>,Class<Dynamic>> = intravenous.ioc.mock.MockEnum;
		  		inj.isEnum().should.be(true);
		  		Injectable.isAnEnum(inj).should.be(true);
		  	});

		  	it('should return false if object is an enum', function(){
		  		var inj:Injectable<Enum<Dynamic>,Class<Dynamic>> = MockObject;
		  		inj.isEnum().should.be(false);
		  		Injectable.isAnEnum(inj).should.be(false);
		  	});
		  });
	  }
}
