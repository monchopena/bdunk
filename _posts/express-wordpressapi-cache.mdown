Date: 19 Feb 2017
Categories: development
Summary: How to use cache with node with a sample
Read more: Show me more

# Express.js, Wordrpress API and Cache

This is a sample made with [express.js][express.js] and 2 libraries: [node-wpapi][node-wpapi] and [node-cache][node-cache].

You can find the code [here][repository].

<pre>
git clone https://github.com/monchopena/express-wordpressapi-cache
cd express-wordpressapi-cache
npm i
npm start
</pre>

Into "lib/wordpress.js" you can put your API url page.

This is the file where we are checking if we can access to cached data "routes/index.js".

<pre>
var isCached = 'posts';
var cachePosts = cache.get(isCached);
</pre>

If we can't access to cached data then we get the posts from the API and then create the cache.

Into the file "routes/index":

<pre>
cache.put('posts', passPosts, 5000); // 5 seconds
</pre>

In this case we put 5000ms. If time isn't passed in, it is stored forever.

Using cache, displaying the pages will be much more efficient.


[express.js]: http://expressjs.com/
[node-wpapi]: https://github.com/WP-API/node-wpapi
[node-cache]: https://github.com/ptarjan/node-cache
[repository]: https://github.com/monchopena/express-wordpressapi-cache