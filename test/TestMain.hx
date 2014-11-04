package ;

import buddy.Buddy;
import buddy.BuddySuite;

class TestMain extends BuddySuite implements Buddy {
	public function new() {
		trace('new');
		iv247.iv.macros.IVMacro.test('one');
	}
}