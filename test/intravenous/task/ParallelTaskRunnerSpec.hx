package intravenous.task;

import buddy.BuddySuite;
import intravenous.task.ParallelTaskRunner;

using buddy.Should;

class ParallelTaskRunnerSpec extends BuddySuite {
	public var runner:ParallelTaskRunner;

	public function new(){
		describe('Parallel Tasks',{
			before({
				runner = new ParallelTaskRunner(null,null);
			});
			
			it('should not wait to complete one async task to move on to the next');
			it('should optionally call complete callback when all tasks have run but not completed');
			it('should call complete callback after all async tasks are copmlete');
		});
	}
}