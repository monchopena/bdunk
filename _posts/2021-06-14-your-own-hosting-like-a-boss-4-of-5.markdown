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

Create a new file for the Actions Definition [like this][github-actions-file].

```
name: Testing the Actions with Jekyll

on:
  push:
    branches: [ master ]

jobs:
  build:

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
    
    - name: Login to DockerHub
      uses: docker/login-action@v1 
      with:
        registry: registry.contabo.bdunk.com
        username: ${{ secrets.REGISTRY_USER }}
        password: ${{ secrets.REGISTRY_PASS }}

    - name: Build and push
      id: docker_build
      uses: docker/build-push-action@v2
      with:
        push: true
        file: DockerfileGithubActions
        tags: moncho/bdunk-web:latest
    
    - name: Image digest
      run: echo ${{ steps.docker_build.outputs.digest }}
    
    - name: curl
      uses: wei/curl@v1
      with:
        args: -X POST ${{ secrets.PORTAINER_WEBHOOK }}
```


[bdunk]: https://github.com/monchopena/bdunk
[github-actions]: https://github.com/features/actions
[environment-secrets]: /attachments/environment-secrets.png "Environment secrets"
[github-actions-file]: https://github.com/monchopena/bdunk/blob/master/.github/workflows/jekyll.yml
