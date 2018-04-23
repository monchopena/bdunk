---
layout: post
title:  "Varnish SSL"
date:   2012-05-08 00:00:00 +0200
categories: systems nginx
summary: "Varnish does not support SSL. How can we solve this: with Nginx."
---

[Varnish][varnish-web] it makes your web site go faster and has good tools like "varnishlog". But there is a problem not supports SSL ([this is the official explanation][varnish-ssl]).

So we can solve with Nginx. If for example we started Varnish: 

> varnishd -f /usr/local/etc/varnish/default.vcl -s malloc,1G -T 127.0.0.1:2000 -a 0.0.0.0:10000

You can Proxy it with Nginx

> ...
> 
> ssl                  on;
> 
> ssl_certificate	/root/certs/wildcard.nginx.crt;
> 
> ssl_certificate_key /root/certs/wildcard.nginx.key;
> 	
> 	#for attack BEAST
> 	ssl_session_cache shared:SSL:10m;
> 
>   ssl_session_timeout 5m;
> 
>   ssl_protocols SSLv3 TLSv1;
> 
>   ssl_ciphers RC4:HIGH:!aNULL:!MD5;
> 
>   ssl_prefer_server_ciphers on;
> 
>   add_header Strict-Transport-Security "max-age=2592000; includeSubdomains";
> 
> 	location / {
> 
>       proxy_pass http://localhost:10000;
> 
>       proxy_set_header   Host             $host;
> 
>       proxy_set_header   X-Real-IP        $remote_addr;
> 
>       proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
> 
>       proxy_ignore_headers Set-Cookie; 
> 
>       proxy_ignore_headers Cache-Control; 
> 
>       proxy_cache_bypass        $http_secret_header;
> 
>       add_header X-Cache-Status $upstream_cache_status;
> 
>   }
>
> ...

And Nginx will server the page in SSL!

[varnish-web]: https://www.varnish-cache.org/
[varnish-ssl]: https://www.varnish-cache.org/docs/trunk/phk/ssl.html