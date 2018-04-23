Date: 29 Apr 2012
Categories: systems, nginx
Summary: Sometimes in some cases a customer asks us not to know that web server we are using. To avoid this in nginx is an extension called Headers More. This article will explain how to install.
Read more: Show me more

# Nginx Headers More

If you make in your terminal with Nginx installed in localhost:

> curl -i http://localhost

You probably will see:

> HTTP/1.1 200 OK

> Server: nginx/1.2.0

> Date: Tue, 01 May 2012 14:55:08 GMT

Oh My God! The server and the version of Nginx!

Don't worry. Go to your source path and get the module

> wget --no-check-certificate https://github.com/agentzh/headers-more-nginx-module/zipball/master -O agentzh.zip

> unzip agentzh.zip

Go to your Nginx source path and choose the "Headers More" path:

> ./configure --add-module=/opt/local/src/agentzh-headers-more-nginx-module-33a82ed/

> make

> make install

Add this in the beginning of nginx.conf:

> more_set_headers "Server: My Ninja Server";

Restart Nginx:

> /usr/local/nginx/sbin/nginx -s stop

> /usr/local/nginx/sbin/nginx

Now you will see:

> Connection: keep-alive

> Server: My Ninja Server

Easy! You can read more about [module][module] and the source in [GitHub][github].

[github]: https://github.com/agentzh/headers-more-nginx-module
[module]: http://wiki.nginx.org/HttpHeadersMoreModule

