Date: 14 Apr 2015
Categories: development
Summary: Solved a problem with _escaped_fragment_ in browsers
Read more: Show me more

# Nginx Angular JS SEO with hashbang

We used [Prerender.io][prerender.io] for performance SEO in [Angular JS][angularjs]f. But we had a problem with [Facebook][facebook] because they save url link with [_escaped_fragment_][_escaped_fragment_] so when you navigate with a browser some "Angular things" don't work.

The solution: we only need to do two conditions:

IF url has include [_escaped_fragment_][_escaped_fragment_]

AND

you are in a browse

THEN

redirect to hashbang.

This is the code:

<pre><code>set $redirect "";

if ($http_user_agent ~* '(Mozilla)') {
  set $redirect  G;
}

if ($arg__escaped_fragment_) {
  set $redirect  "${redirect}O";
}

if ($redirect = GO) {
  rewrite ^ $scheme://$host/#!$arg__escaped_fragment_? break;
}</code></pre>

It's very funny how you have to do an AND condition in [Nginx][nginx] :-)

[prerender.io]:https://prerender.io/
[angularjs]:https://angularjs.org/
[facebook]:https://www.facebook.com/
[_escaped_fragment_]:https://developers.google.com/webmasters/ajax-crawling/docs/specification
[nginx]:http://nginx.org/
