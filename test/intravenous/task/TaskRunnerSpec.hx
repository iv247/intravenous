package intravenous.task;

import buddy.BuddySuite;

using buddy.Should;

class TaskRunnerSpec extends BuddySuite {
	public function new() {
		describe('TaskRunnerSpec', {
			it('should run tasks in the order they are added');
			it('should support classes with an execute method');
			it('should use injector if one supplied');
			it('should pass common object to all tasks');
			it('should call complete callback when all tasks have been executed');
		});
		
	}
}