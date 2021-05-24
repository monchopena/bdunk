---
layout: post
title:  "Your own hosting like a boss (2 of 5)"
date:   2021-05-24 00:00:00 +0200
categories: hosting, portainer, docker
summary: Second step. Docker Swarm configuration and how to deploy Portainer.
---

Good news for you: If you have docker you can start to work with [Docker Swarm][dockerSwarm].

With this arquitecture you have these incredible features:
- Create a number of replicas
- You can create new servers and add to the swarm as workers

The first step is start with this command:

```
docker swarm init
```

In Digital Ocean you got this error:

```
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on interface eth0 (206.81.24.179 and 10.19.0.6) - specify one with --advertise-addr
```

Choose the external IP:

```
docker swarm init --advertise-addr 206.81.24.179
```

If everything is Ok. You will read:

```
Swarm initialized: current node (cyjmwjxm4ivlvh6pbdruospgj) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-1n3t6qxkftfa24zq6r5xnkxu9n554wt32m1ype50xmha53h6z0-ejwiozr4iqqozxsddn37zoi6a 206.81.24.179:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

As I commnented at the begining you can add new servers with the command join. No worries if you don't save or remember the token, you can access at any momment with this command:

```
docker swarm join-token worker
```

Check the network created.

```
# docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
1cf3640c4dae   bridge            bridge    local
8a937e6a0cb9   docker_gwbridge   bridge    local
b95fa8892056   host              host      local
mf24yxxrpofp   ingress           overlay   swarm
3f7807925072   none              null      local
```

We choose [Portainer][portainer] because is a good idea to have a UI for the control of your server.

This is the stack file you can find [here](https://github.com/monchopena/your-own-hosting-like-a-boss-files/blob/main/portainer/stack.yaml). Read the comments to understand how it works.

```
version: "3.3"

services:
  traefik:
    image: "traefik:latest"
    command:
      # We want the dashboard of traefik active
      - --api.dashboard=true
      - --api.insecure=true
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --providers.docker
      # Change this if you want more logs (DEBUG level could be too much)
      - --log.level=ERROR
      - --certificatesresolvers.leresolver.acme.tlschallenge=true
      - --certificatesresolvers.leresolver.acme.httpchallenge=true
      - --certificatesresolvers.leresolver.acme.email=your_email@here.com
      # To save the certs is hight recommended to use a volume as you can see it bellow
      - --certificatesresolvers.leresolver.acme.storage=./acme.json
      - --certificatesresolvers.leresolver.acme.httpchallenge.entrypoint=web
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      # In the same folder you have this file
      # mkdir traefik && touch traefik/acme.json && chmod 400 traefik/acme.json
      - "./traefik/acme.json:/acme.json"
    labels:
      - "traefik.enable=true"
      # Redirect all traffic from http to https
      - "traefik.http.routers.http-catchall.rule=hostregexp(`{host:.+}`)"
      - "traefik.http.routers.http-catchall.entrypoints=web"
      - "traefik.http.routers.http-catchall.middlewares=redirect-to-https"
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.permanent=true"

      # Middleware
      # admin-auth middleware with HTTP Basic auth
      # Using the environment variables USERNAME and HASHED_PASSWORD
      # Sample echo $(htpasswd -nB user) | sed -e s/\\$/\\$\\$/g
      # In this case the password is password: Don't use this in production 😁
      - "traefik.http.middlewares.admin-auth.basicauth.users=user:$$2y$$05$$0et0ONr1P6o3Fh2f/6h6G.sRNu740FOSTg.zXwA87Gq/VSvTOj2oW"

      # Dashboard
      # Remember to point to the Docker Swarm IP server
      - "traefik.http.routers.traefik-public.rule=Host(`traefik.yourdomain.com`)"
      - "traefik.http.routers.traefik-public.entrypoints=websecure"
      - "traefik.http.routers.traefik-public.middlewares=admin-auth"
      - "traefik.http.services.traefik-public.loadbalancer.server.port=8080"
      - "traefik.http.routers.traefik-public.service=api@internal"
      - "traefik.http.routers.traefik-public.tls.certresolver=leresolver"

  portainer:
    image: portainer/portainer-ce:latest
    command: -H unix:///var/run/docker.sock
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == manager]
    labels:
      - "traefik.enable=true"
      # Frontend
      # Remember to point to the Docker Swarm IP server
      - "traefik.http.routers.frontend.rule=Host(`portainer.yourdomain.com`)"
      - "traefik.http.routers.frontend.entrypoints=websecure"
      - "traefik.http.services.frontend.loadbalancer.server.port=9000"
      - "traefik.http.routers.frontend.service=frontend"
      - "traefik.http.routers.frontend.tls.certresolver=leresolver"

volumes:
  portainer_data:
```  

With [Traefik][traefik] you resolve the problem with certs. One tip: review if the domains point to the server before launch the stack.

```
host -t A portainer.yourdomain.com
...
```

Deploy this stack 🚀

```
# docker stack deploy -c portainer.yaml portainer
Creating network portainer_default
Creating service portainer_traefik
Creating service portainer_portainer
```

Take a look to containers with `docker ps -a`.

```
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                NAMES
0dbf02813006   traefik:latest                  "/entrypoint.sh --ap…"   34 seconds ago   Up 28 seconds   80/tcp               portainer_traefik.1.7777idunbforuu53enwi47qhr
02e7c7ff96b1   portainer/portainer-ce:latest   "/portainer -H unix:…"   2 minutes ago    Up 2 minutes    8000/tcp, 9000/tcp   portainer_portainer.1.e69yugombuxs6cb9gqgcr1q8d
```

Watch logs of the container:

```
docker logs -f 0dbf02813006
time="2021-05-24T17:02:09Z" level=info msg="Configuration loaded from flags."
```

No erros good news!

Go to the Traefik dasboard (traefik.yourdomain.com) and use the user and password for Basic Auth.

![traefik dashboard]

The first time you go to Portainer Admin you have to choose user and password.

![portainer dashboard]

In this moment you passed the most difficult part, now you have the base to create other stacks.

Next part is about how to create your own [registry][registry].

See you soon in part 3.

[dockerSwarm]: https://docs.docker.com/engine/swarm/
[registry]: https://hub.docker.com/_/registry
[traefik]: https://doc.traefik.io/traefik/
[portainer]: https://www.portainer.io/
[traefik dashboard]: /attachments/traefik-dashboard.png "Traefik Dashboard"
[portainer dashboard]: /attachments/portainer-dashboard.png "Portainer Dashboard"
