package intravenous.task;

import buddy.BuddySuite;
import intravenous.task.TaskRunner;

using buddy.Should;

class TaskRunnerSpec extends BuddySuite {
	public function new() {
		var runner:TaskRunner;

		describe('TaskRunnerSpec', {
			before({
				runner = new Sequential(null,null);
				runner.add({done: function(){ }});
			});
			it('should run tasks in the order they are added');
			it('should support classes with an execute method');
			it('should use injector if one supplied');
			it('should pass common object to all tasks');
			it('should call complete callback when all tasks have been executed');
		});
		
	}
}