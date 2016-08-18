package intravenous.task;

import buddy.BuddySuite;
import intravenous.task.TaskRunner;

using buddy.Should;

class TaskRunnerSpec extends BuddySuite {
	public function new() {
		//needed for some async specs
		var runner:TaskRunner<TaskModel>;
		var model:TaskModel;
		describe('TaskRunner', {
			beforeEach({
				model = {tasks: new Array<String>()};
			});

			it('should throw an error if executed more than once', {
				
				function (){
					new Sequential()
						.execute(model)
						.execute(model);

				}.should.throwType(String);
			});

			it('should use injector if one is supplied',{
				var injector = new intravenous.ioc.IV();

				injector.mapTransient(MockTask,MockTask);
				injector.mapValue(intravenous.ioc.IV,injector);

				new Sequential(injector)
					.add(MockTask)
					.execute(model);

				model.hasInjection.should.be(true);
			});

			it('should support classes with an execute method',{
				new Sequential()
					.add(MockTask)
					.add(MockTask2)
					.execute(model);
					
				model.tasks.should.containExactly(['task1','task2']);
			});

			it('should support instantiated classes with an execute method',{
				new Sequential()
					.add(new MockTask())
					.add(new MockTask2())
					.execute(model);
					
				model.tasks.should.containExactly(['task1','task2']);
			});


			it('should support nesting tasking runners',{
				var mainRunner = new Sequential();
				var sRunner2 = new Sequential();
				var pRunner = new Parallel();

				var asyncTask = new MockAsyncTask();
				var asyncTask2 = new MockAsyncTask();

				mainRunner
					.add(MockTask)
					.add(MockTask2)
					.add(sRunner2
							.add(asyncTask2)
							.add(MockTask))
					.add(pRunner
							.add(MockTask2)
							.add(asyncTask))
					.execute(model);

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
					new Sequential()
						.add(new MockTask())
						.add(new MockTask2())
						.execute(model);
					model.tasks.should.containExactly(['task1','task2']);
				});

				it('should call complete callback when all tasks have been executed',{
					var called;
					new Sequential()
						.add(MockTask)
						.execute(model)
						.onComplete(function(result){
							called = true;
						}
					);

					called.should.be(true);
				});

				it('should pause runner and wait for async tasks to complete before restarting',{
					var asyncTask = new MockAsyncTask();

					new Sequential()
						.add(MockTask)
						.add(asyncTask)
						.add(MockTask2)
						.execute(model);

					model.tasks.should.containExactly(['task1']);

					asyncTask.complete();

					model.tasks.should.containExactly(['task1', 'asynctask1', 'task2']);
				});

				it('should cancel runner if a task reports an error', {
					var called;
					var asyncTask = new MockAsyncTask();

					new Sequential()
						.add(MockTask)
						.add(asyncTask)
						.execute(model)
						.onComplete(function(result){
							called = true;
						}
					);

					called.should.not.be(true);
					asyncTask.fault('error');
					called.should.not.be(true);
				});

				it('should wait for aysnc tasks to complete before calling complete callback',{
					var called;
					var asyncTask = new MockAsyncTask();

					new Sequential()
						.add(MockTask)
						.add(asyncTask)
						.execute(model)
						.onComplete(function(result){
							called = true;
						}
					);

					called.should.not.be(true);
					asyncTask.complete();
					called.should.be(true);
				});

			});

			describe('Parallel Tasks', {
				it('should not pause runner to wait for async tasks to complete', {
					var asyncTask = new MockAsyncTask();

					new Parallel()
						.add(MockTask)
						.add(asyncTask)
						.add(MockTask2)
						.execute(model);

					asyncTask.complete();

					model.tasks.should.containExactly(['task1', 'task2', 'asynctask1']);

				});

				it('should wait for aysnc tasks to complete before calling complete callback', {
					var called;
					var asyncTask = new MockAsyncTask();

					new Parallel()
						.add(MockTask)
						.add(asyncTask)
						.execute(model)
						.onComplete(function(result){
							called = true;
						}
					);

					called.should.not.be(true);
					asyncTask.complete();
					called.should.be(true);
				});

				it('should not cancel runner if a task reports an error',{
					var called;
					var asyncTask = new MockAsyncTask();

					new Parallel()
						.add(MockTask)
						.add(asyncTask)
						.execute(model)
						.onComplete(function(result){
							called = true;
						}
					);

					called.should.not.be(true);
					asyncTask.fault('error');
					called.should.be(true);
				});

				it('should deliver all task faults on completion', {
					var asyncTask = new MockAsyncTask();
					var asyncTasktwo = new MockAsyncTask();
					var taskResult;

					runner = new Parallel()
						.add(asyncTask)
						.add(asyncTasktwo)
						.onComplete(function(result){
							taskResult = result;
						})
						.execute(model);

					asyncTask.fault('error1');
					asyncTasktwo.fault('error2');

					taskResult.faults.length.should.be(2);

					taskResult.faults[0].data.should.be(model);
					taskResult.faults[0].fault.should.be('error1');

					taskResult.faults[1].data.should.be(model);
					taskResult.faults[1].fault.should.be('error2');
				});

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

	public function new(){
		super();
	}

	public var done:?Dynamic->Void;

	override public function execute(taskModel:TaskModel) {
		model = taskModel;
	}

	public function complete(){
		model.tasks.push('asynctask1');
		done();
	}

	public function fault(error:String){
		done(error);
	}
}
