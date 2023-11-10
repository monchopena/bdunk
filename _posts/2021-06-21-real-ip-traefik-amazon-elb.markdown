---
layout: post
title:  "Real IP with Traefik and K8s"
date:   2021-06-21 00:00:00 +0200
categories: devops
summary: How to get Real IP with Traefik working with Amazon ELB
---

The environment: [K8s][k8s] + [Amazon ELB][amazon-elb] + [Traefik][traefik].

The problem:

```
curl -i https://yourdomain.com
...
X-Forwarded-For: 10.1.3.150
X-Forwarded-Host: yourdomain.com
X-Forwarded-Port: 443
X-Forwarded-Proto: https
X-Forwarded-Server: traefik-55c96f54d6-7cmfn
X-Real-Ip: 10.1.3.150
...
```

The X-Real-Ip is the IP of a node 😞.

The solution:

FIRST: You have to [Configure proxy protocol support for your Classic Load Balancer][configure-proxy-protocol-elb].

As you can see ELB Amazon uses TCP, with HTTP or HTTPS protocol you don't should to have this problem.

![tcp-elb-amazon]

Steps to follow ...

Add the policy:

```
aws elb create-load-balancer-policy --load-balancer-name name-of-the-balancer --policy-name traefik-ProxyProtocol-policy --policy-type-name ProxyProtocolPolicyType --policy-attributes AttributeName=ProxyProtocol,AttributeValue=true --region eu-central-1
```

Verify:

```
aws elb describe-load-balancers --load-balancer-name name-of-the-balancer --region eu-central-1 | grep traefik -A 5 -B 5 
```

You will see:

```
"Policies": {
    "AppCookieStickinessPolicies": [],
    "LBCookieStickinessPolicies": [],
    "OtherPolicies": [
      "traefik-ProxyProtocol-policy"
    ]
},
...
```

Now look for the correct port:

```
aws elb describe-load-balancers --load-balancer-name name-of-the-balancer --region eu-central-1 | grep 443 -A 5 -B 5 
```

Result:

```
...
"Listener": {
    "Protocol": "TCP",
    "LoadBalancerPort": 443,
    "InstanceProtocol": "TCP",
    "InstancePort": 31533
},
...
```

Then you have to add the policy to the port 31533:

```
aws elb set-load-balancer-policies-for-backend-server --load-balancer-name name-of-the-balancer --instance-port 31533 --policy-names traefik-ProxyProtocol-policy --region eu-central-1
```

Review if the policy was added:

```
aws elb describe-load-balancers --load-balancer-name name-of-the-balancer --region eu-central-1 | grep -R BackendServerDescriptions -A 7
```
Result:

```
"BackendServerDescriptions": [
  {
    "InstancePort": 31533,
    "PolicyNames": [
        "traefik-ProxyProtocol-policy"
    ]
  }
],
```

SECOND: Add a special configuration to [Traefik][traefik] to be ready for the [Proxy protocol][proxy-protocol]. More info [here][traefik-proxy-protocol].

Find into the Load Balancer description the [CIDR][CIDR] networks:

![subnet-cidr]

This is the configuration in YAML:

```
## Static configuration
entryPoints:
  websecure:
    address: ":443"
    proxyProtocol:
      trustedIPs:
        - "10.1.4.0/24"
        - "10.1.5.0/24"
        - "10.1.6.0/24"
```

For the CLI:

```
--entryPoints.websecure.address=:443
--entryPoints.websecure.proxyProtocol.trustedIPs=10.1.4.0/24,10.1.5.0/24,10.1.6.0/24
```

Note: if you want to now the ranges use [ipaddressguide][this-page-ips]

Ok. If now we do the curl ...

```
curl -i https://yourdomain.com
...
X-Forwarded-For: 93.22.110.23
X-Forwarded-Host: yourdomain.com
X-Forwarded-Port: 443
X-Forwarded-Proto: https
X-Forwarded-Server: traefik-55c96f54d6-7cmfn
X-Real-Ip: 93.22.110.23
...
```

You got the REAL IP!

[k8s]: https://kubernetes.io
[amazon-elb]: https://aws.amazon.com/elasticloadbalancing/
[traefik]: https://doc.traefik.io/traefik/
[configure-proxy-protocol-elb]: https://docs.aws.amazon.com/es_es/elasticloadbalancing/latest/classic/enable-proxy-protocol.html
[CIDR]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
[traefik-proxy-protocol]: https://doc.traefik.io/traefik/routing/entrypoints/
[proxy-protocol]: https://www.haproxy.org/download/2.0/doc/proxy-protocol.txt
[tcp-elb-amazon]: /attachments/tcp-elb-amazon.png "TCP ELB Amazon"
[subnet-cidr]: /attachments/subnet-cidr.png "Subnet CDIR"
[this-page-ips]: https://www.ipaddressguide.com/cidr
