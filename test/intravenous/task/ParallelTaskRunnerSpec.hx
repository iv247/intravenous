package intravenous.task;

import buddy.BuddySuite;

using buddy.Should;

class ParallelTaskRunnerSpec extends BuddySuite {
	public function new(){
		describe('Parallel Tasks',{
			
			it('should not wait to complete one async task to move on to the next');
			it('should optionally call complete callback when all tasks have run but not completed');
			it('should call complete callback after all async tasks are copmlete');
		});
	}
}