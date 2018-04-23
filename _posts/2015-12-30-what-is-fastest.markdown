---
layout: post
title:  "What is fastest? HTML, Lua, Node.js, or PHP"
date:   2015-12-30 00:00:00 +0200
categories: systems
summary: I made tests over the same server with Apache HTTP server benchmarking tool with different technologies. And the winner is ...
---

I installed in a server [OpenResty][openresty] and [PHP-FPM][php-fpm].

[OpenResty][openresty] is very interesting because [Lua][lua] is integrated with [Nginx][nginx].

This is [Nginx][nginx] configuration for [Lua][lua]:

<pre><code>location /lua {
        default_type text/html;
        content_by_lua 'ngx.say("&lt;p&gt;Hello&lt;/p&gt;")';
}</code></pre>

And for [PHP-FPM][php-fpm]:

<pre><code>location ~ \.php$ {
            fastcgi_pass   unix:/var/run/php5-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }</code></pre>

This is a little program with [Express][express]:

<pre><code>var express = require('express');
var app = express();
app.get('/', function (req, res) {
  res.send('&lt;p&gt;Hello&lt;/p&gt;');
});
var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('Example app listening at http://%s:%s', host, port);
});</code></pre>

I used [Apache HTTP server benchmarking tool][ab] for tests:

<pre><code>ab -k -n 50000 -c 2 -e lua.csv http://192.168.0.55/lua
ab -k -n 50000 -c 2 -e html.csv http://192.168.0.55/index.html
ab -k -n 50000 -c 2 -e node.csv http://192.168.0.55:3000
ab -k -n 50000 -c 2 -e php.csv http://192.168.0.55/index.php</code></pre>

All pages show same content:

<pre><code>&lt;p&gt;Hello&lt;/p&gt;</code></pre>

And these are the results:

![fastest_lua_graph_00]

![fastest_lua_graph_01]

And the winner is [Lua][lua]!!!

[openresty]:https://openresty.org/
[php-fpm]:http://php-fpm.org/
[lua]: http://www.lua.org/
[nginx]: http://nginx.org/
[nodejs]: https://nodejs.org/en/
[express]: http://expressjs.com/
[ab]: https://httpd.apache.org/docs/2.2/programs/ab.html
[fastest_lua_graph_00]: /attachments/fastest-lua-graph-00.png "Lua wins Graph 1"
[fastest_lua_graph_01]: /attachments/fastest-lua-graph-01.png "Lua wins Graph 2"
