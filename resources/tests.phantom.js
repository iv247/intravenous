var page = require('webpage').create();
var success = /, (0 failures,)/igm;
var fail= /, ([1-9]+ failures,)/igm;
page.onConsoleMessage = function(msg) { 
	console.log(msg);
    
    if(success.test(msg)){
    	phantom.exit(0);
    }

    if(fail.test(msg)){
    	phantom.exit(1);
    }
};

page.clearMemoryCache();
page.open('build/js/index.html', function(status) {
    if (status !== 'success') {
        console.log('Error: Unable to access network!');
		phantom.exit(1);
    } 
});
