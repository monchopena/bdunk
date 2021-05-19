---
layout: post
title:  "Your own hosting like a boss (1 of 5)"
date:   2021-05-19 00:00:00 +0200
categories: hosting, portainer, docker
summary: The first step. Creating the server with Terraform
---

This is the first post long time ago. A lot of things passed in my live, one of them: I dedicated a lot of time to learn and apply [DevOps][devops] knowledge.

In these serie of posts (first of fifth) I want to reach these conditions:

- I want to create a server with a script, for this I'm going to use [Terraform][terraform].
- I would like to have the possiblity of scale. I choosed [Docker Swarm][dockerSwarm].
- I need my own [registry][registry] server for my images.
- It's mandatory to use SSL certificates and I know [Traefik][traefik] works fantastic with [Let's encrypt][letsencrypt].
- I expect to deploy in a easy way and [Portainer][portainer] has a good system to do it with a [webhook][portainerWebhook].

First of all you can find the files used in this article [here][githubRepo].

[How to install Terraform][howToInstallTerraform].

Let's take a 👀    to the [main file][mainFile].

I'm using DO but you could do it with other provider.

```
provider "digitalocean" {
  token = var.do_token
}
```

This token is defined as a variable into the [vars file][varsFile]

```
variable "do_token" {
    description = "The token"
}
```

If you don't define a "default value" you will asked for the value when you try to apply the script.

Here the type of the droplet:

```
resource "digitalocean_droplet" "docker_swarm" {
  image  = "ubuntu-20-10-x64"
  name   = "docker-swarm"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  ssh_keys = [ "123123" ]
  user_data = file("userdata.yaml")
}
```

I choosed Ubuntu as server.

How to know your ssh_key id:

```
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer here_your_token" "https://api.digitalocean.com/v2/account/keys" 
```

At the begining of the respose you have the id:

```
{"ssh_keys":[{"id":123123,"fingerprint ...
```

May be you have some question about this file [userdata.yaml][userdataYAML]. This is like a script to deploy after the machine is created. More info in [this repo][cloudInit]. If you want to know more deeply [here some samples of configuration files][cloudInitSamples].

In my case I only want to install docker dependencies:

```
#cloud-config
package_update: true
packages:
  - docker.io
  - docker-compose
  - vim
  - htop
```

I use the DO DNSs so I can update with the IP assigned easily.

```
resource "digitalocean_record" "edge" {
  domain = var.domain
  type   = "A"
  name   = "traefik"
  ttl    = "300"
  value  = digitalocean_droplet.docker_swarm.ipv4_address
}
```

Let's launch the terraform:

````
terraform init
terraform validate
terraform plan
terraform apply
```

You need to paste the token:

```
$ terraform apply
var.do_token
  The token

  Enter a value: 
```

After 1-2 minutes ...

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

connect_ssh = "ssh root@46.101.204.107"
```

The output is because we define into [main file][mainFile]:

```
output "connect_ssh" {
  description = "How to connect to the New Server"
  value = "ssh root@${digitalocean_droplet.docker_swarm.ipv4_address}"
}
```

The Droplet:

![droplet photo]

And if we connect with the server with ssh:

```
root@docker-swarm:~# docker  ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Well done! We have the base to start with the [Docker Swarm][dockerSwarm].

See you soon in part 2.

[devops]: https://en.wikipedia.org/wiki/DevOps
[terraform]: https://www.terraform.io/
[dockerSwarm]: https://docs.docker.com/engine/swarm/
[registry]: https://hub.docker.com/_/registry
[traefik]: https://doc.traefik.io/traefik/
[letsencrypt]: https://letsencrypt.org
[portainer]: https://www.portainer.io/
[portainerWebhook]: https://documentation.portainer.io/v2.0/webhooks/create/
[githubRepo]: https://github.com/monchopena/your-own-hosting-like-a-boss-files/tree/main/terraform
[mainFile]: https://github.com/monchopena/your-own-hosting-like-a-boss-files/blob/main/terraform/digital-ocean/docker-machine-create/main.tf
[varsFile]: https://github.com/monchopena/your-own-hosting-like-a-boss-files/blob/main/terraform/digital-ocean/docker-machine-create/variables.tf
[howToInstallTerraform]: https://learn.hashicorp.com/tutorials/terraform/install-cli
[userdataYAML]: https://github.com/monchopena/your-own-hosting-like-a-boss-files/blob/main/terraform/digital-ocean/docker-machine-create/userdata.yaml
[cloudInit]: https://github.com/canonical/cloud-init
[cloudInitSamples]: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
[droplet photo]: /attachments/droplets.png "Droplet Create Success"