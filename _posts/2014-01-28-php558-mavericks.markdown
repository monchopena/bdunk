---
layout: post
title:  "Compiling PHP 5.5.8 on OSX Mavericks"
date:   2014-01-28 00:00:00 +0200
categories: php systems
summary: I explain step by step how compile PHP 5.5.8 on Mavericks OSX
---

I assume you have installed [MacPorts][macports] or maybe [Homebrew][brew].

First obtain the code:

<pre><code>
cd /usr/local/src
sudo wget http://es1.php.net/get/php-5.5.8.tar.gz/from/this/mirror -O php558.tar.gz
sudo tar -xzvf php558.tar.gz
sudo chown -R user:staff php-5.5.8
cd php-5.5.8
</code></pre>

This is my configure options:

<pre><code>
./configure --with-zlib --enable-intl --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl --enable-mbstring --with-mcrypt=/opt/local/ --with-jpeg-dir --with-gd --enable-fpm --with-curl --without-iconv
</code></pre>

If you obtain several errors perphas you need install some dependences like mcript, sample:

<pre><code>
sudo port install libmcrypt
</code></pre>

Next steps:

<pre><code>
make
sudo make install
</code></pre>

If everything was fine:

<pre><code>
php -v
PHP 5.5.8 (cli) (built: Jan 28 2014 22:16:50) 
Copyright (c) 1997-2013 The PHP Group
Zend Engine v2.5.0, Copyright (c) 1998-2013 Zend Technologies
</code></pre>

You should define php.ini

<pre><code>
sudo cp php.ini-production /usr/local/lib/php.ini
</code></pre>

And uncomment this line, in my case:

<pre><code>
date.timezone = "Europe/Madrid"
</code></pre>

Let's start a server

<pre><code>
php -S localhost:3001
</code></pre>

And you'll see:

![php558 screenshot]

[macports]: http://www.macports.org/
[brew]: http://brew.sh/
[php558 screenshot]: /attachments/php558.png "PHP 5.5.8 Screenshot"




