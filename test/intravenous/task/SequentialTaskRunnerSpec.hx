package intravenous.task;

import buddy.BuddySuite;

using buddy.Should;

class SequentialTaskRunnerSpec extends BuddySuite {
	public function new() {
		describe('SequentialTaskRunnerSpec', {
			it('should call complete callback when all tasks have run by default');
			it('should wait for async tasks to complete to move on to the next task');
		});
	}
}