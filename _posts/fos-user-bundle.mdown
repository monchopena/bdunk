Date: 09 Aug 2013
Categories: php
Summary: I explain step by step how install this bundle on Symfony 2
Read more: Show me more

# Installing FOS User Bundle in Symfony 2

Recently I'm starting a project with Symfony. There is a very interesting bundle for managing users called [FOS User Bundle][fos user bunle].

Let's see how it is installed. (I assume you have installed Symfony 2).

- Download FOSUserBundle using composer

Add FOSUserBundle in your composer.json:

<pre><code>
{
    "require": {
        "friendsofsymfony/user-bundle": "~2.0@dev"
    }
}
</code></pre>

Now use composer...

<pre><code>
composer update friendsofsymfony/user-bundle
</code></pre>

- Enable the bundle

<pre><code>
// app/AppKernel.php

public function registerBundles()
	{
	   $bundles = array(
	       // ...
	       new FOS\UserBundle\FOSUserBundle(),
	   );
	}
</code></pre>

- Configure the FOSUserBundle

<pre><code>
# app/config/config.yml
fos_user:
    db_driver: orm # other valid values are 'mongodb', 'couchdb' and 'propel'
    firewall_name: main
    user_class: Acme\UserBundle\Entity\User
</code></pre>

- Create your User class (This is only a sample)

This is very funny in Symfony.

<pre><code>
php app/console generate:bundle --namespace=Acme/UserBundle
</code></pre>

The directory:

<pre><code>
mkdir src/Acme/UserBundle/Entity/
</code></pre>

The file:

<pre><code>
// src/Acme/UserBundle/Entity/User.php

namespace Acme\UserBundle\Entity;

use FOS\UserBundle\Model\User as BaseUser;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="fos_user")
 */
class User extends BaseUser
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    public function __construct()
    {
        parent::__construct();
        // your own logic
    }
}
</code></pre>


- Configure your application's security.yml

<pre><code>
security:
    encoders:
        Symfony\Component\Security\Core\User\User: plaintext
        FOS\UserBundle\Model\UserInterface: sha512

    role_hierarchy:
        ROLE_ADMIN:       ROLE_USER
        ROLE_SUPER_ADMIN: ROLE_ADMIN

    providers:
        fos_userbundle:
            id: fos_user.user_provider.username

    firewalls:
    	main:
            pattern: ^/
            form_login:
                provider: fos_userbundle
                csrf_provider: form.csrf_provider
            logout:       true
            anonymous:    true
        dev:
            pattern:  ^/(_(profiler|wdt)|css|images|js)/
            security: false

        login:
            pattern:  ^/demo/secured/login$
            security: false

        secured_area:
            pattern:    ^/demo/secured/
            form_login:
                check_path: _security_check
                login_path: _demo_login
            logout:
                path:   _demo_logout
                target: _demo
            #anonymous: ~
            #http_basic:
            #    realm: "Secured Demo Area"

    access_control:
        - { path: ^/demo/secured/hello/admin/, roles: ROLE_ADMIN }
        - { path: ^/login$, role: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/register, role: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/resetting, role: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/admin/, role: ROLE_ADMIN }
        #- { path: ^/login, roles: IS_AUTHENTICATED_ANONYMOUSLY, requires_channel: https }
</code></pre>

- Import FOSUserBundle routing files

<pre><code>
# app/config/routing.yml
fos_user_security:
    resource: "@FOSUserBundle/Resources/config/routing/security.xml"

fos_user_profile:
    resource: "@FOSUserBundle/Resources/config/routing/profile.xml"
    prefix: /profile

fos_user_register:
    resource: "@FOSUserBundle/Resources/config/routing/registration.xml"
    prefix: /register

fos_user_resetting:
    resource: "@FOSUserBundle/Resources/config/routing/resetting.xml"
    prefix: /resetting

fos_user_change_password:
    resource: "@FOSUserBundle/Resources/config/routing/change_password.xml"
    prefix: /profile
</code></pre>

- Update your database schema

<pre><code>
php app/console doctrine:schema:update --force
</code></pre>

- Translation

<pre><code>
# app/config/config.yml

framework:
    translator: ~
</code></pre>

Testing:

If you go http://localhost/app_dev.php/register/ and register.

This is a sample when you are logged:

![fos screenshot]

[fos user bunle]: https://github.com/FriendsOfSymfony/FOSUserBundle 
[fos screenshot]: /attachments/symfony_fosuser.png "FOS Screenshot"




