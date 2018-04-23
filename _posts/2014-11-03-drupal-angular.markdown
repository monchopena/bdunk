Date: 3 Nov 2014
Categories: systems
Summary: First steps with Drupal and Angular JS
Read more: Show me more

# Drupal and AngularJS

Do you have [drush][drush]?

<pre><code>apt-get install drush</code></pre>

Install drupal:

<pre><code>drush pm-download --drupal-project-rename=drupal</code></pre>

<pre><code>cd drupal</code></pre>

Yo can see status:

<pre><code>drush status</code></pre>

Prepare a mysql database and then run this command:

<pre><code>drush site-install --db-url=mysql://drupal:drupal@127.0.0.1/drupal --account-mail=admin@bdunk.com --account-name="admin" --account-pass="here your pass" standard</code></pre>

If you have Nginx like webserver there is a nice configuration file sample [here][here].

We need to install "views" (in [Drupal 8][drupal8] this module belongs to the core):

<pre><code>drush dl views</code></pre>

<pre><code>drush en views</code></pre>

<pre><code>drush en views_ui</code></pre>

And install a module named [Views Datasource][views_datasource].


<pre><code>drush dl views_datasource</code></pre>

<pre><code>drush en views_json</code></pre>

Now it's time to create your own content. In my case I created a list of dogs. Just contains the following fields: 

- title 
- Body 
- Photo

And create a new view to show this content. Edit this view, most important is:

- Format: Choose JSON Document. In this sections select "JSON data format" > "MIT Simile/Exhibit".
- Fields: Select all required fields.
- Photo field: in "Formatter" select "URL to file".

We have now a url like this http://localhost/dogs-json and result it's

<pre>
{"Items":[{"node":{"title":"Je je je","Body":"Niki Niki.\n","Post date":"Monday, November 3, 2014 - 18:54","Photo":"http:\/\/192.168.0.21:81\/sites\/default\/files\/perrete_abrazo.jpg"},"label":"Item","type":"node"},{"node":{"title":"Another perrete","Body":"OMG!!!\n","Post date":"Monday, November 3, 2014 - 15:04","Photo":"http:\/\/192.168.0.21:81\/sites\/default\/files\/perrete_comida.jpg"},"label":"Item","type":"node"},{"node":{"title":"Perrete","Body":"It's a good animal\n","Post date":"Monday, November 3, 2014 - 14:52","Photo":"http:\/\/192.168.0.21:81\/sites\/default\/files\/perrete_guarrindongo.jpg"},"label":"Item","type":"node"}]}
</pre>

Finally let's go with [Angular JS][angularjs].

You only need a sample like "Hello Angular JS".

In this sample controller is:

<pre><code>angular.module("dogs", [])

.controller("DogController", function($scope, $http) {
	$scope.dogs="";
	$http.get('/dogs-json').
	  success(function(data, status, headers, config) {
	    // this callback will be called asynchronously
	    // when the response is available
	    console.log(data);
	    $scope.dogs=data.Items;   
	  }).
	  error(function(data, status, headers, config) {
	    // called asynchronously if an error occurs
	    // or server returns response with an error status.
	  });	
}
);</code></pre>

HTML code:

<pre><code>&lt;html lang=&quot;en&quot; ng-app=&quot;dogs&quot;&gt; 
...
&lt;div class=&quot;container&quot; ng-controller=&quot;DogController&quot;&gt;
&lt;div ng-repeat=&quot;dog in dogs&quot;&gt;
&lt;h3&gt;{{dog.node.title}}&lt;/h3&gt;
&lt;p&gt;{{dog.node.Body}}&lt;/p&gt; 
&lt;p&gt; 
&lt;img ng-src=&quot;{{dog.node.Photo}}&quot; class=&quot;img-responsive&quot; alt=&quot;Responsive image&quot;&gt; 
&lt;/p&gt; 
&lt;/div&gt; 
&lt;/div&gt;
...</code></pre>

The result:

![drupal_angular]

I don't like work with Drupal's templates. I think this is a better way if you want a clean code.

Cheers!

[drush]: https://github.com/drush-ops/drush
[here]:http://wiki.nginx.org/Drupal
[views_datasource]:https://www.drupal.org/project/views_datasource
[drupal8]:https://www.drupal.org/node/3060/release
[angularjs]:https://angularjs.org/
[drupal_angular]: /attachments/drupal_angular.png "Drupal Angular JS"


