---
layout: post
title:  "OpenResty: How to install"
date:   2017-02-28 00:00:00 +0200
categories: systems
summary: Firsts steps to work with OpenResty
---

I like [Lua][lua] and I like [Nginx][nginx] then is normal to try [OpenResty][openresty].

I will install in a Debian/Ubuntu system.

Prerequisites:

<pre>
apt-get install build-essential libpcre3-dev libssl-dev
</pre>

Get the source code from the [download page][openrestydownload]:

<pre>
wget https://openresty.org/download/openresty-VERSION.tar.gz
tar -xzvf openresty-VERSION.tar.gz
cd openresty-VERSION/
./configure -j2
make -j2
make install
</pre>

Add this line to your ~/.bashrc or ~/.bash_profile file.

<pre>
export PATH=/usr/local/openresty/bin:$PATH
</pre>

Then execute:

<pre>
openresty
</pre>

And you could visit the page http://127.0.0.1 (the better place), and you will see this:

![welcomepage]

[lua]: https://www.lua.org/
[nginx]: https://www.nginx.com/resources/wiki/
[openresty]: https://openresty.org/en/
[openrestyinstallation]: https://openresty.org/en/installation.html
[openrestydownload]: https://openresty.org/en/download.html
[welcomepage]: /attachments/openresty_welcome.png "OpenResty welcome page"
