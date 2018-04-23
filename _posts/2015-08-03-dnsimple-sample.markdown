Date: 3 Aug 2015
Categories: development
Summary: An example how to update a register (IP) in Dnsimple.com
Read more: Show me more

# Updating a domain IP with Dnsimple when you have a Dinamyc IP

I'm using [Dnsimple][dnsimple] because they have an API that works very well.

I made a Shell Script with requests to the API using "curl". But I decided to make one in Node.js.

I could have used the library [request][request] to use with the API but I found this module https://github.com/fvdm/nodejs-dnsimple and it0s fine.

Clone this [repository][github].

<pre><code>git clone https://github.com/monchopena/dnsimple-sample
cd dnsimple-sample
npm install</code></pre>

Then copy config.sample.js

<pre><code>cp config.sample.js config.js</code></pre>

And change test data for you Dnsimple domain, register, ...

This program is funny because include a Cron.

Next step could be work with [forever][forever].

[github]: https://github.com/monchopena/dnsimple-sample/
[dnsimple]: https://dnsimple.com
[request]: https://github.com/request/request
[forever]: https://github.com/foreverjs/forever

