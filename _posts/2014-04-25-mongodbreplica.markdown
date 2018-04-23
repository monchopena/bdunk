---
layout: post
title:  "MongoDB simple replicas"
date:   2014-04-25 00:00:00 +0200
categories: systems, mongodb
summary: MongoDB simple replication 3 servers sample
---

If you don't have [Mongo DB][mongodb_web] this is a good moment to install it. In Debian you can do it:

<pre>apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

apt-get update

apt-get install mongodb-org</pre>

More information about MongoDB installation [here][mongodb_installation].

I have 3 servers wiht MongoDB with this IPS 192.168.0.[11,12,14].

My intention is make this:

![mongodb_architecture]

Now you need change 2 lines in mongod.conf

Put real IP:

<pre>bind_ip=192.168.0.11 #put here diferent ips</pre>

And the name of the replica:

<pre>replSet=myhome</pre>

Now start all the servers. I have one on OSX and I want see http stats in port 28017, so It's needed add --rest when you start MongoDB, sample:

<pre>mongod -f mongod.conf --rest</pre>

In Debian restart the service:

<pre>/etc/init.d/mongod restart</pre>

Ok now we connect to mongo in all servers:

In my case:

<pre>mongo 192.168.0.11
mongo 192.168.0.12
mongo 192.168.0.14</pre>

Now we'll create the members:

<pre>
rs.initiate();
rs.add("192.168.0.12");
rs.add("192.168.0.14);
rs.status();
</pre>

That's it. We're done!

You can see rest stats from http://192.168.0.11:28017/_replSet

![mongodb_stats]

Two important things:

You'll obtain this error in secondary members when you try some query:

<pre></pre>

Run this code:

<pre>rs.slaveOk()</pre>

This allows the current connection to allow read operations to run on secondary members.

How to configure connections? Sample in [Mongoose][mongodb_connections]:

<pre>mongoose.connect('mongodb://username:password@host:port/database,mongodb://username:password@host:port,mongodb://username:password@host:port?options...' [, options]);</pre>

Now it's time to test. Try to turn off 2 servers and after turn on, turn off primary... It's nice!

[mongodb_web]: https://www.mongodb.org/
[mongodb_installation]: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-debian/
[mongodb_architecture]: /attachments/replica-set-read-write-operations-primary.png "Architecture MongoDB"
[mongodb_stats]: /attachments/mongodb_stats.png "MongoDB Stats"
[mongodb_connections]: http://mongoosejs.com/docs/connections.html



