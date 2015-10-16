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

			it('should match a valid route',{
				var params;
				router.add({
					url: '/users/:user/:id'
				});
				
				params = router.matchRoute('/users/clark/20/').params;
				params['user'].should.be('clark');
				params['id'].should.be('20');
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

				params = router.matchRoute('/users/jones/81/newyork').params;
				params['user'].should.be('jones');
				params['id'].should.be('81');
				params['location'].should.be('newyork');

				params = router.matchRoute('/users/clark/20/').params;
				params['user'].should.be('clark');
				params['id'].should.be('20');
				params.exists('location').should.be(false);
			});

			it('should match a valid route with special characters',{
				var params;
				router.add({
					url: '/users#@/:user/:id'
				});
				
				params = router.matchRoute('/users#@/cl#ark/20/').params;
				params['user'].should.be('cl#ark');
				params['id'].should.be('20');
			});

			it('should not match an invalid route',{
				var route;
				router.add({
					url: '/users/:user/:id'
				});
				
				route = router.matchRoute('/invalid/clark/20/');
				route.should.be(null);
			});
		});
	}
}