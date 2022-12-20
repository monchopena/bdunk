---
layout: post
title:  "Testing Vitess: Scalable, Reliable, MySQL-compatible"
date:   2022-12-20 00:00:00 +0200
categories: kubernetes mysql testing
summary: Finally! We have a scalable database compatible with MySQL.
---

As you know, for samples, I like to use Wordpress, because this "blog cms" has specific problems when you want to deploy in [K8s][kubernetes].

I always prayed for a easy scalable database compatible with [MySQL][mysql]. So go to the point. Of course you will need to have a [K8s][kubernetes] cluster.

Create the namespace:

```
k create ns vitess & k ns vitess
```

Clone the repo of [Vitess][vitess]:

```
git clone https://github.com/vitessio/vitess
cd vitess/examples/operator
```

Install the operator:

```
kubectl apply -f operator.yaml
```

Wait ...

```
k get pods                                     
NAME                               READY   STATUS    RESTARTS   AGE
vitess-operator-69f65546b7-zpht5   1/1     Running   0          87s
```

Now we have the operator we can start with the samples.
The first one starts the cluster:

```
k apply -f 101_initial_cluster.yaml
```

After a cup of 🍵 ...

```
example-commerce-x-x-zone1-vtorc-c13ef6ff-54d657995f-nkjfp   1/1     Running   3 (126m ago)   129m
example-etcd-faf13de3-1                                      1/1     Running   1 (126m ago)   129m
example-etcd-faf13de3-2                                      1/1     Running   1 (126m ago)   129m
example-etcd-faf13de3-3                                      1/1     Running   1 (126m ago)   129m
example-vttablet-zone1-2469782763-bfadd780                   3/3     Running   2 (126m ago)   129m
example-vttablet-zone1-2548885007-46a852d0                   3/3     Running   2 (126m ago)   129m
example-zone1-vtadmin-c03d7eae-7f46bfcd7c-qhpk8              2/2     Running   0              129m
example-zone1-vtctld-1d4dcad0-5db7c9799d-wrxf5               1/1     Running   3 (126m ago)   129m
example-zone1-vtgate-bc6cde92-7f6dccb697-vfmkr               1/1     Running   3 (126m ago)   129m
vitess-operator-79bd947f7b-sgtd5                             1/1     Running   0              129m
```

There's a bash script to create all "port-forwards" for services, but for this blog entry we are going to focus only in the connection to mysql.

We need to discover where's the svc for "vtgate"

```
kubectl get service --selector="planetscale.com/component=vtgate,planetscale.com/cell"
```
With the result:

```
k port-forward --address 0.0.0.0  svc/example-zone1-vtgate-bc6cde92  15306:3306
```

Let's connect to the database with:

```
mysql -h 127.0.0.1 -P 15306 -u user
...
show databases;
```

You are seeing the database commerce. Let's connect one application to this 

For simplify we'll do it with helm. The most important thing is the values. This is a sample of the file values.yaml:

```
## WordPress Settings
wordpressUsername: test
wordpressPassword: test
wordpressEmail: moncho@pena.com
wordpressFirstName: Moncho
wordpressLastName: Pena
wordpressBlogName: My Blog!

## Database Settings
externalDatabase:
  host: example-zone1-vtgate-bc6cde92.vitess.svc.cluster.local 
  user: user
  password: ""
  database: commerce
  port: 3306

## Enable Maria DB
mariadb:
  enabled: false
```

The most important part is to point to the service located into namespace vitess: `example-zone1-vtgate-bc6cde92.vitess.svc.cluster.local`

```
k create ns wordpress && k ns wordpress
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install myblog -f values.yaml bitnami/wordpress
```

Wait a few seconds:

```
k get pods                                          
NAME                                READY   STATUS    RESTARTS   AGE
myblog-wordpress-76cb978894-vwlm8   1/1     Running   0          11m
```

Let's take a look 👀 to the database:

```
MySQL [commerce]> show tables;
+-----------------------+
| Tables_in_commerce    |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
12 rows in set (0.004 sec)
```

It works. A WP pointing to [Vitess][vitess] ... Simply awesome.

[kubernetes]: https://kubernetes.io/
[mysql]: https://www.mysql.com/
[vitess]: https://vitess.io/