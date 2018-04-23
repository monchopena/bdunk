Date: 2 Jun 2014
Categories: systems
Summary: If you want to avoid firewalls to teach your web from your computer this is your tutorial
Read more: Show me more

# Tunnel a local webserver to the Internet

First: we need a server accessible from your computer by ssh, in this sample we use testing.wentook.com.

Second: We will work with Nginx Proxy in the internet server:

Sample nginx conf:

<pre><code>server {
	listen 80;
	server_name testing.wentook.com;
	location / {
		proxy_pass    http://127.0.0.1:8801/;
	}
}</code></pre>

Important: remember port 8801

Third: In my localhost I have installed nginx and it listen port 81.

Sample nginx conf:

<pre><code>server {
	listen 81;
	root /usr/share/nginx/www;
	index index.html index.htm;
	server_name localhost;
}</code></pre>

And four:

<pre><code>ssh root@testing.wentook.com -R *:8801:localhost:81</code></pre>

![tunnel_sample]

And you will not have to worry about firewalls.

[tunnel_sample]: /attachments/tunnel_sample.png "Tunnel sample"