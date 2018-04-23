---
layout: post
title:  "Express.js and Moustache"
date:   2015-05-30 00:00:00 +0200
categories: development nginx
summary: Testing Moustache in Express.js
---

First intall [Express.js][express.js] generator:

<pre>
npm install express-generator -g
</pre>

Display the command options with the -h option:

<pre>
express -h
</pre>

Create application:

<pre>
express myapp
</pre>

Then install dependencies:

<pre>
cd myapp 
npm install
</pre>

Run the app (on MacOS or Linux):

<pre>
$ DEBUG=myapp npm start
</pre>

In app.js default view engine by default is [Jade][jade]:

<pre>
app.set('view engine', 'jade');
</pre>

First we need install this extension [node-mustache-express][node-mustache-express]:

<pre>
npm install mustache-express --save
</pre>

And then add in app.js:

<pre>
var mustacheExpress = require('mustache-express');
...
app.engine('mustache', mustacheExpress());
app.set('view engine', 'mustache');
...
</pre>

Into directory 'views/templates' we create this file named 'index.mustache':

<pre>
&lt;p&gt;Welcome to {{title}}!&lt;/p&gt;
</pre>

Go to http://localhost:3000 and see the resutl.

Let's do a new sample:

In file 'routes/index.js':

<pre>
var express = require('express');
var router = express.Router();
var lusers=[
			 { name: 'Linus Torvalds', so: 'Linux' },
			 { name: 'Bill Gates', so: 'Windows XP' }
		    ];
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express', lusers: lusers });
});
module.exports = router;
</pre>

And in file 'views/index.mustache':

<pre>
&lt;p&gt;Welcome to {{ title }}!&lt;/p&gt;
&lt;ul&gt;
{{#lusers}}
&lt;li>{{name}} - {{so}}&lt;/li&gt;
{{/lusers}}
&lt;/ul&gt;
</pre>

Now is time to play with [{{ mustache }}][mustache]!


[express.js]: http://expressjs.com/
[jade]: http://jade-lang.com/
[node-mustache-express]: https://github.com/bryanburgers/node-mustache-express
[mustache]: https://github.com/janl/mustache.js

