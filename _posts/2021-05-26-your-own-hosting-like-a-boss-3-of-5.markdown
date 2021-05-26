---
layout: post
title:  "Your own hosting like a boss (3 of 5)"
date:   2021-05-26 00:00:00 +0200
categories: hosting portainer docker
summary: Third step. Docker Deploy register.
---

I'm going to need docker images and I don't want to use a public repository.

There's a Official repo called [registry][registry], now we can create our own image store.

Let's create a new stack!

First we need to create the network:

```
docker network create registry_network --scope swarm
```

And we need a file to save the Basic Auth. Remember this user and password

```
mkdir -p registry/auth && mkdir -p registry/data
echo $(htpasswd -nb user password) | sed -e s/\\$/\\$\\$/g > registry/auth/registry.password
```

Into Portainer go to Stacks and press "+ Add stack".

![portainer stack]

Choose a name and paste this configuration:

```
version: "3.3"

services:

  registry:
    image: registry:2
    environment:
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
      REGISTRY_AUTH_HTPASSWD_REALM: Registry
    volumes:
      - ./registry/data:/var/lib/registry
      - ./registry/auth:/auth
    networks:
      - registry_network
      - portainer_default
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=portainer_default"
      - "traefik.http.routers.registry.rule=(Host(`registry.yourdomain.com`))"
      - "traefik.http.routers.registry.entrypoints=websecure"
      - "traefik.http.services.registry.loadbalancer.server.port=5000"
      - "traefik.http.services.registry.loadBalancer.sticky.cookie=true"
      - "traefik.http.routers.registry.service=registry"
      - "traefik.http.routers.registry.tls=true"
      - "traefik.http.routers.registry.tls.certresolver=leresolver"

networks:
  portainer_default:
    external: true
  registry_network:
    external: true
```

![portainer add stack]

Press deploy button and wait some seconds ⧖.

If everythig gone well you should login.

```
# docker login -u user -p password registry.contabo.bdunk.com
Login Succeeded
```

[here][nginx-sample] you can find a very simple sample to make a image.

Building the image:

```
docker build .
```

Listing the images with `docker images``
```
REPOSITORY   TAG             IMAGE ID       CREATED         SIZE
<none>       <none>          60081ed32117   5 minutes ago   133MB
```

A quick test for the image:

```
docker run -p 8888:80 60081ed32117 
```

Making a curl:

```
# curl localhost:8888
hello conch
```

Creating a tag for the image:

```
docker image tag 60081ed32117 registry.yourdomain.com/your-username/nginx-test:latest
```

And then push 🚀

```
# docker push registry.yourdomain.com/your-username/nginx-test
The push refers to repository [registry.yourdomain.com/moncho/nginx-test]
0b411e19d514: Pushed 
1914a564711c: Mounted from your-username/nginx-test 
db765d5bf9f8: Mounted from your-username/nginx-test 
903ae422d007: Mounted from your-username/nginx-test 
66f88fdd699b: Mounted from your-username/nginx-test 
2ba086d0a00c: Mounted from your-username/nginx-test 
346fddbbb0ff: Mounted from your-username/nginx-test 
latest: digest: sha256:e7e7ff0a82e1a97630e9b40377c1e97fadad09072789f9b4ce4e664bcef50671 size: 1777
```

Yes! The image is now into the repository. Good Job!

Next part is about how to make auto deploys.

See you soon in part 4.

[registry]: https://hub.docker.com/_/registry
[portainer stack]: /attachments/portainer-stack.png "Portainer Add Stack"
[portainer add stack]: /attachments/portainer-stack-paste.png "Portainer Stack Paste"
[nginx-sample]: https://github.com/monchopena/your-own-hosting-like-a-boss-files/tree/main/nginx-sample 