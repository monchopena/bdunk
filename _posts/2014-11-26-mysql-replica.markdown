Date: 26 Nov 2014
Categories: development
Summary: How To Set Up Database Replication In MySQL
Read more: Show me more

# Mysql Database Replica

We start from two MySQL servers.

For example:

Master:
134.170.185.46

Slave:
137.254.120.50

Let's first try to connect to a database from Slave to Master server.

Create a database:

<pre><code>CREATE DATABASE demo DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;</code></pre>

Create a user for this database.

<pre><code>CREATE USER 'demo'@'%' IDENTIFIED BY '***';GRANT USAGE ON *.* TO 'demo'@'%' IDENTIFIED BY '***' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;</code></pre>

And we give it access to the demo database.

<pre><code>GRANT ALL PRIVILEGES ON `demo`.* TO 'demo'@'%'WITH GRANT OPTION;</code></pre>

We check that everything works.

<pre><code>mysql --user=demo --password=password demo</code></pre>

Now we create a simple table for testing:

<pre><code></code>CREATE TABLE `demo` (
       `demo_id` int(11) NOT NULL AUTO_INCREMENT,
       `name` varchar(200) NOT NULL,
       PRIMARY KEY (`demo_id`),
       KEY `demo_id` (`demo_id`)
     ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;</code></pre>

Were created user to give it permission to access from any server with '@'% '. Before proceeding we must ensure that you can access from the slave to the master server.

First on the master server comment the following line in the MySQL configuration file (/etc/mysql/my.cnf).

<pre><code>#bind-address=127.0.0.1</code></pre>

Restart MySQL.

<pre><code>/etc/init.d/mysql restart</code></pre>

And test from the slave server connection:

<pre><code></code>mysql --host=134.170.185.46 --user=demo --password=password demo</pre>

All right! If this works can continue.

We focus on the Master server.

We return to the MySQL configuration file and type:

<pre><code>server-id               = 1
log_bin                 = /var/log/mysql/mysql-bin.log
expire_logs_days        = 10
max_binlog_size         = 100M
binlog_do_db           = demo</code></pre>

Note: you must use the --server-id option to establish a unique replication ID in the range from 1 to 2^32-1.

Restart MySQL.

Create a user for replicas:

<pre><code>GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;</code></pre>

To see that all goes well we can enter the shell and run:

<pre><code>USE demo;
FLUSH TABLES WITH READ LOCK;
SHOW MASTER STATUS;</code></pre>

It will look something like this (we'll use this information later):

<pre><code>+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      348 | demo         |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)</code></pre>

On the Slave server:

<pre><code>SLAVE STOP;
CHANGE MASTER TO MASTER_HOST='134.170.185.46', MASTER_USER='slave_user', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=348;
START SLAVE;</code></pre>

Restart MySQL.

Let's try.

The replicas are fine when we are working with large databases. It is also quite easy to configure. It is very important that the connection between the network servers works fine, If don't you'll have a lot of lag.