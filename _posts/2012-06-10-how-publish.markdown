---
layout: post
title:  "How to publish an article on this website"
date:   2012-06-10 00:00:00 +0200
categories: development
summary: I explain step by step how do I post an article on this website.
---

First: I write the article in [*.mdown format][mdown page]. 

![Coda Screenshot]

Second: I check on my computer everything works fine.

> shotgun config.ru

![Nesta Server Screenshot]

Third: login in heroku.

> heroku login

Fourth: update the code from server.

> git pull

Fifth: send to git server the changes.

> git add .

> git commit -a -m "How to publish"

Sixth: send to heroku server.

> git push heroku master

More information about Heroku git in this [page][heroku git page].

[mdown page]: http://daringfireball.net/projects/markdown/syntax
[Coda Screenshot]: /attachments/coda.png "Coda Screenshot"
[heroku git page]: https://devcenter.heroku.com/articles/git
[Nesta Server Screenshot]: /attachments/server_nesta_cms.png "Nesta CMS server"
