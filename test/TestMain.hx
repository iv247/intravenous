package ;

import buddy.Buddy;
import buddy.BuddySuite;


/**
test
**/
class TestMain extends BuddySuite implements Buddy {
/** test; **/
	public function new() {
		super();

		var inj:iv247.intravenous.ioc.internal.Injectable<Enum<Dynamic>,Class<Dynamic>> = "One";
			trace( inj.isClass() );
		
	
	
	}

}


enum Testing {
	ONE;
	TWO;
	THREE;
}

class One {
	public var test:String;
}
