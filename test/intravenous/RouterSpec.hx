package intravenous;

import buddy.BuddySuite;

using buddy.Should;

class RouterSpec extends BuddySuite {
	public function new(){
		describe('Router',{
			var router;

			beforeEach({
				router = new Router();				
			});

			afterEach({
				router = null;
			});
			describe('query string parsing', {	
				beforeEach({
					router = new Router();				
				});
				it('should create a string map of query params', {
					var  query = router.getQuery('/one/two?id=five&user=me');
					query['id'].should.be('five');
					query['user'].should.be('me');
				});

				it('should support full urls',{
					var  query = router.getQuery('http://whatver.com/one/two?id=five&user=me');
					query['id'].should.be('five');
					query['user'].should.be('me');
				});

				it('should support a name value pair string',{
					var  query = router.getQuery('id=five&user=me');
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

			describe('getting a route based on a path', {
				beforeEach({
					router = new Router();				
				});

				it('should return a valid route when matching path is added',{
					var route;
					router
					.add({
						path: '/users/:user/:id'
					});
					
					route = router.getRoute('/users/clark/20/');
					route.should.not.be(null);
				});

				it('should populate the params map in a valid route',{
					var params;
					router.add({
						path: '/users/:user/:id'
					});
					
					params = router.getRoute('/users/clark/20/').params;
					params['user'].should.be('clark');
					params['id'].should.be('20');
				});

				it('should populate the query map in a valid route', {
					var query;
					router.add({
						path: '/users/:user/:id'
					});
					
					query = router.getRoute('/users/clark/20?foo=bar&name=value&empty=&novalue').query;

					query['foo'].should.be('bar');
					query['name'].should.be('value');
					query.exists('novalue').should.be(true);
					query['novalue'].should.be(null);
					query['empty'].should.be('');
				});

				it('should match a valid routes from multiple added routes', {
					var params;
					
					router
					.add({
						path: '/',
						data: 'main'
					})
					.add({
						path: '/users/:user/:id'
					})
					.add({
						path: '/testing'
					})
					.add({
						path: '/users/:user/:id/:location'
					});

					router.getRoute('/').meta.data.should.be('main');

					params = router.getRoute('/users/jones/81/newyork').params;
					params['user'].should.be('jones');
					params['id'].should.be('81');
					params['location'].should.be('newyork');

					params = router.getRoute('/users/clark/20/').params;
					params['user'].should.be('clark');
					params['id'].should.be('20');
					params.exists('location').should.be(false);

					var paramNames = router.getRoute('/testing').paramNames;
					paramNames.length.should.be(0);
					router.getRoute('/testing').should.not.be(null);
				});

				it('should match a valid route with special characters',{
					var params;
					router.add({
						path: '/users/:user/:id'
					});
					
					params = router.getRoute('/users/cla=$%&ark/20?sdf').params;
					params['user'].should.be('cla=$%&ark');
					params['id'].should.be('20');

				});

				it('should not match an invalid route',{
					var route;
					router.add({
						path: '/users/:user/:id',
						allow: false
					});
					
					route = router.getRoute('/users/clark/20/asdfasfd');
					route.should.be(null);
				});

				it('should match a route if the beginning path is valid',{
					var route;
					router.add({
						path: '/users/:user/:id',
						allow: true,

					});
					
					route = router.getRoute('/users/clark/20/asdfasfd');
					route.should.not.be(null);
					route.params['user'].should.be('clark');
					route.params['id'].should.be('20');
					trace(route.params);
				});
			});
		
		});
	}
}