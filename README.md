SLTableView-Demo
================

A Self-Loading TableView that lists data from /r/pics

When you select a cell, a custom pop up view appears and displays the intended image that the corresponding post's url is suppose to link to.

However it isn't always a url that directs to an image, but rather a webpage, therefore a crash will occur.
Though that is iff the url does not direct to an image. 
This can be easily fixed with a UIWebView instead, though it looks ugly so an external WebView Controller will be made instead.

Implementation is simple:

	table = [[SLTableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
	[self.view addSubview:table];
    
   	[table loadData];
    
    
    
Further work includes changing the inits to include an (id) parameter for the UIViewController the SLTableView is in, so navigation to a separate WebView Controller can be implemented
