package intravenous;

import buddy.BuddySuite;

using buddy.Should;

class RouterSpec extends BuddySuite {
	public function new(){
		@include
		describe('Router',{
			var router;

			before({
				router = new Router();
			});

			after({
				router = null;
			});

			it('should return a valid route',{
				var route;
				router.add({
					url: '/users/:user/:id'
				});
				
				route = router.getRoute('/users/clark/20/');
				route.should.not.be(null);
			});

			it('should populate the params map in a valid route',{
				var params;
				router.add({
					url: '/users/:user/:id'
				});
				
				params = router.getRoute('/users/clark/20/').params;
				params['user'].should.be('clark');
				params['id'].should.be('20');
			});

			it('should populate the query map in a valid route', {
				var query;
				router.add({
					url: '/users/:user/:id'
				});
				
				query = router.getRoute('/users/clark/20?foo=bar&name=value').query;
				
				query['foo'].should.be('bar');
				query['name'].should.be('value');
			});

			it('should match a valid route from multiple routes', {
				var params;
				
				router
				.add({
					url: '/users/:user/:id'
				})
				.add({
					url: '/users/:user/:id/:location'
				});

				params = router.getRoute('/users/jones/81/newyork').params;
				params['user'].should.be('jones');
				params['id'].should.be('81');
				params['location'].should.be('newyork');

				params = router.getRoute('/users/clark/20/').params;
				params['user'].should.be('clark');
				params['id'].should.be('20');
				params.exists('location').should.be(false);
			});

			it('should match a valid route with special characters',{
				var params;
				router.add({
					url: '/users/:user/:id'
				});
				
				params = router.getRoute('/users/cla=$%&ark/20?sdf').params;
				params['user'].should.be('cla=$%&ark');
				params['id'].should.be('20');
			});

			it('should not match an invalid route',{
				var route;
				router.add({
					url: '/users/:user/:id'
				});
				
				route = router.getRoute('/invalid/clark/20/');
				route.should.be(null);
			});

			it('should create a string map of query params', {
				var  query = router.getQuery('/url/one/two?id=five&user=me');
				query['id'].should.be('five');
				query['user'].should.be('me');
			});

			it('should add a query value of null for params with no "="',{
				var  query = router.getQuery('/?noEqual');
				query.exists('noEqual').should.be(true);
				query['noEqual'].should.be(null);

			});

			it('should add a query value of "" for params with "=" but no value',{
				var  query = router.getQuery('/?noValue=');
				query.exists('noValue').should.be(true);
				query['noValue'].should.be('');
			});
		});
	}
}