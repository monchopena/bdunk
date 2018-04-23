---
layout: post
title:  "How to export your PGP private Key to another computer"
date:   2015-09-17 00:00:00 +0200
categories: systems
summary: If you need export your PGP keys you could use this commands.
---

First of all: Do you have some private keys in your machine?

Try this:

<pre><code>gpg --list-secret-keys</code></pre>

In my case:

<pre><code>/Users/moncho/.gnupg/secring.gpg
--------------------------------
sec   2048R/87273203 2015-05-21
uid                  Moncho <moncho@penarodriguez.org>
ssb   2048R/8C042203 2015-05-21</code></pre>


Now you only need write this command:

<pre><code>gpg --armor --export-secret-keys moncho@penarodriguez.org > warning_my_private_key.txt</code></pre>

Be careful with your private key!

Now send to another computer the key and import:

<pre><code>gpg --allow-secret-key-import --import warning_my_private_key.txt</code></pre>


Do the same with public key, first export:

<pre><code>gpg --armor --export moncho@penarodriguez.org > my_public_key.txt</code></pre>

And import:

<pre><code>gpg --import my_public_key.txt</code></pre>

More information in [GnuPG][gnupg].

[gnupg]:https://www.gnupg.org
