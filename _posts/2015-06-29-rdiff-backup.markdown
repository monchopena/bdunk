---
layout: post
title:  "How to install latest version of Rdiff-Backup"
date:   2015-06-29 00:00:00 +0200
categories: development
summary: Compiling rdiff-backup lastest version in Debian/Ubuntu
---

Latest version is 1.3.3 and you can download from [this page][rdiff-backup].

<pre>cd /usr/local/src
wget http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.3.3.tar.gz
tar -xzvf rdiff-backup-1.3.3.tar.gz
cd rdiff-backup-1.3.3
python setup.py install
</code></pre>

If you see an error with “_librsyncmodule.c” you have to install this dependence:

<pre><code class=“ruby”>apt-get install -y librsync-dev
</code></pre>

Sample Script for copies:

<pre><code class=“ruby”>/opt/local/bin/rdiff-backup —remote-schema “ssh -C -p2223 %s rdiff-backup —server” root@YOUR_REMOTE_IP::/data/mysql/ /Volumes/SERVERS/mycopies/dbs
/opt/local/bin/rdiff-backup —force —remove-older-than 2W /Volumes/SERVERS/mycopies/dbs
</code></pre>



[rdiff-backup]: http://www.nongnu.org/rdiff-backup/
