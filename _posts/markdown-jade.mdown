Date: 26 Nov 2012
Categories: development
Summary: Using Markdown in Jade.
Read more: Show me more

# Using Markdown in Express

Ok. I'm a geek and I like [markdown]. I've been testing with Express and wanted to use [markdown].

	$ npm install -g express
	$ express --sessions --css stylus myapp
	$ cd myapp && npm install
	$ node app.js

Now you can go to http://localhost:3000 and see The Express Default Page.

If we want use markdown we need install:

	$ npm install node-markdown

Let's create a new markdown file into views:

	$ vi views/index.mdown

Content:

	***Ok*** this is a test

In app.js file add this files:

	...
	, fs = require('fs')
	...
	var md = require("node-markdown").Markdown;
	...
	var index_file = fs.readFileSync(__dirname + '/views/index.mdown', "utf8");
	app.locals.body = md(index_file);
	...

In views change file index.jade adding:

	!{body}

Wonderful! I really like [express]!

[express]: http://expressjs.com/
[markdown]: http://daringfireball.net/projects/markdown/