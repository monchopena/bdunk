---
layout: post
title:  "SQLite3 in Node JS"
date:   2014-11-17 00:00:00 +0200
categories: systems
summary: Testing SQLite3 in Node JS
---

I have a problem. I'm making an application for run over a [Raspberry PI][raspberrypi], I initially chose  [Mongo DB][mongodb] (I really like it!), but in a [Raspberry PI][raspberrypi] this program is slow.

I was looking for a solution and I thought about SQLite. There's a module maintained by [Mapbox][mapbox] that you can find it [here][node_sqlite3].

Let's do a fast test:

<pre><code>express -e sqlite_express</code></pre>

<pre><code>cd sqlite_express</code></pre>

Open package.json and add a line in dependences:

<pre><code>"sqlite3":""</code></pre>

Install packages:

<pre><code>npm install</code></pre>

We'll put dabase into a dir.

<pre><code>mkdir database</code></pre>

This is app.js code:

<pre><code>var express = require('express');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var routes = require('./routes/index');
var users = require('./routes/users');

var app = express();

//SQLite
var sqlite3 = require('sqlite3').verbose();
var sqlite3_file=__dirname+'/database/sqlite_express.sqlite3';
var db = new sqlite3.Database(sqlite3_file);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/users', users);

app.get('/data/start', function (req, res, next) {
  db.serialize(function() {
  	db.run("CREATE TABLE IF NOT EXISTS users (name TEXT)");
  	db.all("SELECT rowid AS id, name FROM users", function(err, rows) {
    	if (err) {
	    	res.send('err: '+err);
    	} else {
	    	if (rows.length>0) {
		    	res.send('No users added');
	    	} else {
		    	var stmt = db.prepare("INSERT INTO users VALUES (?)");
		    	stmt.run("Neo");
		    	stmt.run("Trinity");
		    	stmt.run("Morfeo");
		    	stmt.finalize();
		    	res.send('Users added');
	    	}
    	}
  	});
  });
});

app.get('/show', function (req, res, next) {
	db.all("SELECT rowid AS id, name FROM users", function(err, rows) {
    	if (err) {
	    	res.send('err: '+err);
    	} else {
	    	console.log(rows);
	    	res.render('show', { title: 'Show users', users: rows });
    	}
  	});
});

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;</code></pre>

First we started database going to http://localhost:3000/data/start.

This is the template for view users (views/show.ejs):

<pre><code>&lt;!DOCTYPE html&gt;
  &lt;html&gt;
  &lt;head&gt;
    &lt;title&gt;&lt;%= title %&gt;&lt;/title&gt;
    &lt;link rel='stylesheet' href='/stylesheets/style.css' /&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;h1&gt;&lt;%= title %&gt;&lt;/h1&gt;
    &lt;ul&gt;
      &lt;% for(var i=0; i&lt;users.length; i++) {%&gt;
        &lt;li&gt;&lt;%= users[i].name %&gt;&lt;/li&gt;
      &lt;% } %&gt;
    &lt;/ul&gt;
  &lt;/body&gt;
&lt;/html&gt;</code></pre>

This is a very simple sample but it's a good start.

[raspberrypi]:https://www.google.com/search?q=raspberry%20pi&gws_rd=ssl&tbm=isch
[mongodb]:http://www.mongodb.org/
[mapbox]:https://www.mapbox.com/
[node_sqlite3]:https://github.com/mapbox/node-sqlite3
