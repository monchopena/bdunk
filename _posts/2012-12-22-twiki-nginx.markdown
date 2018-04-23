---
layout: post
title:  "TWiki on Nginx"
date:   2012-12-22 00:00:00 +0200
categories: development nginx
summary: TWiki on Nginx a little HOWTO
---

I like [Twiki][twiki] and I love [Nginx][nginx]. Can they work together? Yes they can.

First: we need a CGI for Nginx.
I used to use [spawn-fcgi][spawn-fcgi] but is not updated for 4 years. So i tried with [Simple CGI support for Nginx][fcgiwrap].
<pre><code>git clone https://github.com/gnosek/fcgiwrap
autoreconf -i
./configure
make
make install</code></pre>

Maybe you need install:
<pre><code>apt-get install libfcgi-dev</code></pre>

A script for start FCGIWrap

<pre><code>#!/usr/bin/perl

use strict;
use warnings FATAL => qw( all );

use IO::Socket::UNIX;

my $bin_path = '/usr/local/sbin/fcgiwrap';
my $socket_path = $ARGV[0] || '/tmp/cgi.sock';
my $num_children = $ARGV[1] || 1;

close STDIN;

unlink $socket_path;
my $socket = IO::Socket::UNIX->new(
    Local => $socket_path,
    Listen => 100,
);

die "Cannot create socket at $socket_path: $!\n" unless $socket;

for (1 .. $num_children) {
    my $pid = fork;
    die "Cannot fork: $!" unless defined $pid;
    next if $pid;

    exec $bin_path;
    die "Failed to exec $bin_path: $!\n";
}</code></pre>

Now install TWiki. Obtain source from [TWike Download Page][twiki_donwload].

Create LocalLib.cfg and put all path (In my case):
<pre><code>$twikiLibPath = "/var/twiki/lib";
$TWiki::cfg{ScriptUrlPaths}{view} = '';
$TWiki::cfg{ScriptUrlPaths}{edit} = '/edit';</code></pre>

And now nginx configuration:

<pre><code>server {
        listen       81;
        server_name  192.168.1.113;
        
        access_log /var/log/nginx/acces_twiki.log;
        error_log /var/log/nginx/error_twiki.log;

	     root /var/twiki;
        index index.html;
        
        location = /favicon.ico {
          return 204;
          access_log     off;
          log_not_found  off;
        }


        rewrite ^/([A-Z].*)  /bin/view/$1;
        rewrite ^/edit/(.*)  /bin/edit/$1;

        location ~ ^/pub/ { allow all; }

        location ~ ^/bin/configure {
          allow all; #remember put deny all after finish configuration
          fastcgi_pass   unix:/tmp/cgi.sock;
          include        fastcgi_params;
          fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        }

        location ~ ^/bin/ {
          allow all;
          fastcgi_pass   unix:/tmp/cgi.sock;
          fastcgi_split_path_info  ^(/bin/[^/]+)(/.*)$;
          include        fastcgi_params;
          fastcgi_param  PATH_INFO        $fastcgi_path_info;
          fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
         }

    }</code></pre>

And go to web page!

![TWiki Screenshot]

[twiki]: http://twiki.org/
[nginx]: http://nginx.org/
[spawn-fcgi]: https://github.com/kindy61/spawn-fcgi
[fcgiwrap]: http://nginx.localdomain.pl/wiki/FcgiWrap
[twiki_donwload]: http://twiki.org/cgi-bin/view/Codev/DownloadTWiki?
[TWiki Screenshot]: /attachments/twiki_screenshot.png "TWiki Screenshot"

