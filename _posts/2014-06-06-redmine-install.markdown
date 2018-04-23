---
layout: post
title:  "How to install redmine in Debian"
date:   2014-06-06 00:00:00 +0200
categories: systems
summary: Installing redmine step by step
---

[Redmine][redmine] is my favorite Project Managent Program.

Let's see how to install redmine in Debian or Ubuntu.

## 00 - Add user redmine

If you are root:

<pre><code>adduser redmine</code></pre>

Add this user to sudoers.

<pre><code>adduser redmine sudo</code></pre>

So we'll work with user redmine.

<pre><code>su - redmine</code></pre>

## 01 - Install RVM

<pre><code>\curl -L https://get.rvm.io | bash -s stable --rails</code></pre>

You can now take a coffee break.

...

We need to make our environment aware of the new RVM installation. You can see in your .bashrc file:

<pre><code>export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting</code></pre>

Active it with:

<pre><code>source ~/.bashrc</code></pre>

Some usefull orders:

<pre><code>rvm info</code></pre>

<pre><code>rvm list</code></pre>

Let's try a Ruby page.

<pre><code>rails new sample
cd sample
rails s</code></pre>

And go to http://localhost:3000

![rails_server]


## 02 - Prepare database

Enter into MySQL command line:

<pre><code>mysql --user=root --password</code></pre>

And create database and user:

<pre><code>CREATE DATABASE redmine CHARACTER SET utf8;
CREATE USER 'redmine'@'127.0.0.1' IDENTIFIED BY 'password_redmine';
GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'127.0.0.1';</code></pre>

Exit and test:

<pre><code>mysql --host=127.0.0.1 --user=redmine --password=password_redmine redmine</code></pre>

## 03 - Download Redmine

<pre><code>wget http://www.redmine.org/releases/redmine-2.5.1.tar.gz
tar -xzvf redmine-2.5.1.tar.gz
cd redmine-2.5.1/</code></pre>

<pre><code>cp config/database.yml.example config/database.yml</code></pre>

Configure database:

<pre><code>production:
  adapter: mysql2
  database: redmine
  host: 127.0.0.1
  username: redmine
  password: password_redmine
  encoding: utf8</code></pre>

<pre><code>cp config/configuration.yml.example config/configuration.yml</code></pre>

Go to production section. In this case we'll put sendmail option, you may read file for more options.

<pre><code>production:
  email_delivery:
    delivery_method: :sendmail</code></pre>

## 04 - Starting redmine

Install MySQL library dev and RMagick.

<pre><code>sudo apt-get install libmysqld-dev
sudo apt-get install libmagick++-dev</code></pre>

Install bundler and configure redmine:

<pre><code>gem install bundler
bundle install --without development test
rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data</code></pre>

Create folders:

<pre><code>mkdir -p tmp tmp/pdf public/plugin_assets
sudo chown -R redmine:redmine files log tmp public/plugin_assets
sudo chmod -R 755 files log tmp public/plugin_assets</code></pre>

And start redmine:

<pre><code>ruby script/rails server webrick -e production</code></pre>

Go to http://localhost:3000.

## 05 - Using puma

Add gem "puma" to Gemfile and execute bundle again:

<pre><code>bundle install --without development test</code></pre>

Add this config file to config/puma.rb

<pre><code>#!/usr/bin/env puma

application_path = '/home/redmine/redmine-2.5.1'
directory application_path
environment 'production'
daemonize true
pidfile "#{application_path}/tmp/pids/puma.pid"
state_path "#{application_path}/tmp/pids/puma.state"
stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"
bind "unix://#{application_path}/tmp/sockets/redmine.socket"</code></pre>

And try with:

<pre><code>bundle exec puma -C config/puma.rb</code></pre>

## 06 - Configure Nginx

<pre><code>upstream redmine {
  server unix:/home/redmine/redmine-2.5.1/tmp/sockets/redmine.socket;
}

server {
  listen 90;
  server_name localhost;
  root /home/redmine/redmine-2.5.1/public;

  access_log  /var/log/nginx/redmine_access.log;
  error_log   /var/log/nginx/redmine_error.log;

  location / {
    try_files $uri $uri/index.html $uri.html @redmine;
  }

  location @redmine {
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_redirect     off;

    proxy_set_header   X-Forwarded-Proto $scheme;
    proxy_set_header   Host              $http_host;
    proxy_set_header   X-Real-IP         $remote_addr;

    proxy_pass http://redmine;
  }
}</code></pre>

Restart Nginx:

<pre><code>nginx -s stop
nginx</code></pre>

## 07- Monit start

Install monit:

<pre><code>sudo apt-get install monit</code></pre>

General configuration file /etc/monit/monitrc add:

<pre><code>set httpd port 2812
  allow admin:pass</code></pre>
  
Into /etc/monit/conf.d/ add file redmine:

<pre><code>check process redmine with pidfile /home/redmine/redmine-2.5.1/tmp/pids/puma.pid 
start program = "/bin/su redmine -lc 'cd /home/redmine/redmine-2.5.1  && /home/redmine/.rvm/gems/ruby-2.1.2/bin/puma -C /home/redmine/redmine-2.5.1/config/puma.rb'"
stop program = "/bin/su redmine -lc 'kill -TERM $(cat /home/redmine/redmine-2.5.1/tmp/pids/puma.pid)'"</code></pre>
  
And restart monit:

<pre><code>service monit restart</code></pre>

Go to monit web:

http://localhost:2812/redmine

![monit_server]

## 08 - Enter in redmine

Go to redmine:

http://localhost:2812/redmine

user: admin
pass: admin

And now you can start your projects!

[redmine]: http://www.redmine.org
[rails_server]: /attachments/rails.png "Rails Server"
[monit_server]: /attachments/monit_server.png "Rails Server"

