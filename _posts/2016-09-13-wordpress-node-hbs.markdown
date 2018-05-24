---
layout: post
title:  "Access to Wordpress from Node.js"
date:   2016-09-13 00:00:00 +0200
categories: development
summary: I want to use Handelbars to show Posts from a Wordpress page
---

First we will need access to a Wordpress (obviously).

Let's start a project with [Express][express].

If you don't have _express-generator_ you can install with:

<pre><code>npm install express-generator -g</code></pre>

Create a new dir for the project:

<pre><code>mkdir node-wordpress
cd node-wordpress</code></pre>

Starting express generator with "hbs" (handlebars template engine) option:

<pre><code>express --hbs</code></pre>

Add [node-wordpress library][node-wordpress]:

<pre><code>npm i --save wordpress</code></pre>

Install all dependences:

<pre><code>npm i</code></pre>

Start the project:

<pre><code>DEBUG=node-wordpress:* npm start</code></pre>

This is a sample of routes/index.js

```javascript
var express = require('express');
var router = express.Router();

var wordpress = require( "wordpress" );
var client = wordpress.createClient({
    url: "http://mywwordpresssite.com",
    username: "myuser",
    password: "mypassword"
});


/* GET home page. */
router.get('/', function(req, res, next) {
  client.getPosts({ status: 'publish' }, function( err, posts ) {
		if (err) {
		   next(err);
		} else {
		   
		   for (var i = 0, len = posts.length; i < len; i++) {
		      console.log('title: '+posts[i].title);
		      console.log('status: '+posts[i].status);
		      console.log('-----------------------------------');
		    }
		   
	       res.render('index', { title: 'Express', posts: posts });
	    }
  });
  
});

module.exports = router;
```

And this is the hbs file /views/index.hbs

```html
<h1>{% raw %}{{title}}{% endraw %}</h2>
{% raw %}{{#each posts}}{% endraw %}
  <h2>{% raw %}{{title}}{% endraw %}</h2>
  <p>{% raw %}{{{content}}}{% endraw %}</p>
{% raw %}{{/each}}{% endraw %}
```

Go to [http://localhost:3000][localhost] and see the result.

More information about handelbars template engine [here][handlebars].

Next week I'm going to write about how to use [Memcached][memcached] to improve this project.

[express]:http://expressjs.com
[node-wordpress]:https://github.com/scottgonzalez/node-wordpress
[handlebars]:http://handlebarsjs.com/
[memcached]:https://memcached.org/
[localhost]:http://localhost:3000