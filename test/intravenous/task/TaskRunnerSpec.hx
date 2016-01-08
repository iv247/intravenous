package intravenous.task;

import buddy.BuddySuite;
import intravenous.task.TaskRunner;

using buddy.Should;

class TaskRunnerSpec extends BuddySuite {
	public function new() {
		var runner:TaskRunner<TaskModel>;
		var model:TaskModel;

		describe('TaskRunner', {
			before({
				model = {tasks: new Array<String>()};
			});

			it('should use injector if one is supplied',{
				var injector = new intravenous.ioc.IV();

				injector.mapDynamic(MockTask,MockTask);
				injector.mapValue(intravenous.ioc.IV,injector);

				runner = new Sequential(null,injector);
				runner.add(MockTask);
				runner.execute(model);

				model.hasInjection.should.be(true);
			});

			it('should support classes with an execute method',{
				runner = new Sequential(null,null);
				runner.add(MockTask);
				runner.add(MockTask2);
				runner.execute(model);
				model.tasks.should.containExactly(['task1','task2']);
			});

			it('should support nesting tasking runners', function(){
				var mainRunner = new Sequential(null,null);
				var sRunner2 = new Sequential(null,null);
				var pRunner = new Parallel(null,null);

				var asyncTask = new MockAsyncTask();
				var asyncTask2 = new MockAsyncTask();

				mainRunner.add(MockTask);
				mainRunner.add(MockTask2);
				mainRunner.add(sRunner2);

				//nested seqential runner
				sRunner2.add(asyncTask2);
				sRunner2.add(MockTask);

				mainRunner.add(pRunner);

				//nested parallel runner
				pRunner.add(MockTask2);
				pRunner.add(asyncTask);

				mainRunner.execute(model);

				asyncTask2.complete();
				asyncTask.complete();

				model.tasks.should.containExactly([
					'task1',
					'task2',
					'asynctask1',
					'task1',
					'task2',
					'asynctask1'
				]);

			});

			describe('Sequential Tasks',{

				it('should run tasks in the order they are added',{
					runner = new Sequential(null,null);
					runner.add(new MockTask());
					runner.add(new MockTask2());
					runner.execute(model);
					model.tasks.should.containExactly(['task1','task2']);
				});


				it('should call complete callback when all tasks have been executed',{
					var called;
					runner = new Sequential(function(result){
						called = true;
					},null);
					runner.add(MockTask);
					runner.execute(model);
					called.should.be(true);
				});

				it('should pause runner and wait for async tasks to complete before restarting',{
					var asyncTask = new MockAsyncTask();

					runner = new Sequential(null,null);

					runner.add(MockTask);
					runner.add(asyncTask);
					runner.add(MockTask2);

					runner.execute(model);

					model.tasks.should.containExactly(['task1']);

					asyncTask.complete();

					model.tasks.should.containExactly(['task1', 'asynctask1', 'task2']);


				});

				it('should cancel runner if a task reports an error', {

				});

				it('should wait for aysnc tasks to complete before calling complete callback',{
					var called;
					var asyncTask = new MockAsyncTask();

					runner = new Sequential(function(result){
						called = true;
					},null);

					runner.add(MockTask);
					runner.add(asyncTask);

					runner.execute(model);

					called.should.not.be(true);
					asyncTask.complete();
					called.should.be(true);
				});

			});

			describe('Parallel Tasks', {
				it('should not pause runner to wait for async tasks to complete', {
					var asyncTask = new MockAsyncTask();

					runner = new Parallel(null,null);

					runner.add(MockTask);
					runner.add(asyncTask);
					runner.add(MockTask2);

					runner.execute(model);
					asyncTask.complete();

					model.tasks.should.containExactly(['task1', 'task2', 'asynctask1']);

				});

				it('should wait for aysnc tasks to complete before calling complete callback', {
					var called;
					var asyncTask = new MockAsyncTask();

					runner = new Parallel(function(result){
						called = true;
					},null);

					runner.add(MockTask);
					runner.add(asyncTask);

					runner.execute(model);

					called.should.not.be(true);
					asyncTask.complete();
					called.should.be(true);
				});

				it('should not cancel runner if a task reports an error');

			});
		});
	}
}

typedef TaskModel = {
	var tasks:Array<String>;
	@:optional var hasInjection:Bool;
}

class MockTask {
	public function new(){}

	@inject
	public var injector:intravenous.ioc.IV;

	public function execute(model:TaskModel) {
		model.tasks.push('task1');
		model.hasInjection = (injector != null);
	}
}

class MockTask2 extends MockTask {
	override public function execute(model:TaskModel) {
		model.tasks.push('task2');
	}
}

class MockAsyncTask extends MockTask {
	var model:TaskModel;

	public var done:?Dynamic->Void;

	override public function execute(taskModel:TaskModel) {
		model = taskModel;
	}

	public function complete(){
		model.tasks.push('asynctask1');
		done();
	}
}
