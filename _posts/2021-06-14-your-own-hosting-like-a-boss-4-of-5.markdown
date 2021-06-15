---
layout: post
title:  "Your own hosting like a boss (4 of 5)"
date:   2021-06-14 00:00:00 +0200
categories: hosting portainer docker gitlab actions
summary: Fourth step. How to deploy.
---

We are going to use the [repository of this webpage][bdunk] and [GitHub Actions][github-actions].

First we need to create 3 repository secrets:

- REGISTRY_USER: the registry user
- REGISTRY_PASS: the password for registry
- PORTAINER_WEBHOOK: sample https://portainer.contabo.bdunk.com/api/webhooks/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

![environment-secrets]

You can get this webhook from the button "Copy Link" (Remember you have to activate the webhook):

![service-webhook]

Create a new file for the Actions Definition [like this][github-actions-file].

```
{% raw %}name: Testing the Actions with Jekyll

on:
  push:
    branches: [ master ]

jobs:
  publish:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Build the site in the jekyll/builder container
      run: |
        docker run \
        -v ${{ github.workspace }}:/srv/jekyll -v ${{ github.workspace }}/_site:/srv/jekyll/_site \
        jekyll/builder:latest /bin/bash -c "chmod -R 777 /srv/jekyll && jekyll build --future"
    
    - name: Set up QEMU
      uses: docker/setup-qemu-action@v1
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1
    
    - name: Login to your own Registry
      uses: docker/login-action@v1 
      with:
        registry: registry.yourdomain.com
        username: ${{ secrets.REGISTRY_USER }}
        password: ${{ secrets.REGISTRY_PASS }}

    - name: Build and push
      id: docker_build
      uses: docker/build-push-action@v2
      with:
        push: true
        context: .
        tags: registry.yourdomain.com/moncho/bdunk-web:latest
    
    - name: Image digest
      run: echo ${{ steps.docker_build.outputs.digest }}
    
    - name: curl
      uses: wei/curl@v1
      with:
        args: -X POST ${{ secrets.PORTAINER_WEBHOOK }}{% endraw %}
```

When the action is going to be called, in this case when we make a push to master.

```
{% raw %}on:
  push:
    branches: [ master ]{% endraw %}
```

We generate all the necessary files and save into _site foder.

```
{% raw %}Build the site in the jekyll/builder container{% endraw %}
```

Login againsts our own Registry.

```
{% raw %}registry: registry.yourdomain.com{% endraw %}
```

Pushing the image. In this step is very important to write the correct context.

```
{% raw %}with:
        push: true
        context: .
        tags: registry.yourdomain.com/moncho/bdunk-web:latest{% endraw %}
```

And finally we do a call to the Portainer webhook, so it's going to get the latest image and pull it ... Awesome!. [More info about this][portainer-webhook].

```
{% raw %}args: -X POST ${{ secrets.PORTAINER_WEBHOOK }}{% endraw %}
```

Next post we are going to make a complete sample with a complex webpage.

[bdunk]: https://github.com/monchopena/bdunk
[github-actions]: https://github.com/features/actions
[environment-secrets]: /attachments/environment-secrets.png "Environment secrets"
[github-actions-file]: https://github.com/monchopena/bdunk/blob/master/.github/workflows/jekyll.yml
[service-webhook]: /attachments/service-webhook.png "Service Webhook"
[portainer-webhook]: https://documentation.portainer.io/v2.0/webhooks/create/
