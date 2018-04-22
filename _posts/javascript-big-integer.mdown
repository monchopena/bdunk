Date: 10 sep 2015
Categories: NodeJS
Summary: Beware of big integers in Javascript
Read more: Show me more

# Big Integer and Javascript

The other day I was testing the graphics library [D3.js][d3js] and wanted to represent the [Fibonacci][fibonacci] series.

So I did a quick program in [Node.js][nodejs]:

<pre><code>var fibonacci = [ 0, 1 ];

var position=2;

var sum=0;

while (position<100) {

	fibonacci[position]=fibonacci[position-1]+fibonacci[position-2];
	position++;
	
}

console.log(JSON.stringify(fibonacci));</code></pre>

This program return first 100 positions.

Doing mental arithmetic I realized that in the 79 position of the array (the sum of the position 77 and 78) was wrong!

<pre><code> 5527939700884757
 8944394323791464 
14472334024676220!!!
</code></pre>

I read a little on the internet and the largest number that is represented as an integer in JavaScript is 2 ^ 53.

Let's do a little sample.

<pre><code>var big=Math.pow(2, 53);
var big2=big+1;

console.log('big: '+big);
console.log('big2: '+big2);</code></pre>

OMG it's true!

So I changed initial program by this:

<pre><code>var limit=Math.pow(2, 53);

var fibonacci = [ 0, 1 ];

var position=2;

var controller=0;
var sum=0;

while (controller==0) {

	sum=fibonacci[position-1]+fibonacci[position-2];

	if (sum>limit) {
		controller=1;
	} else {
		fibonacci[position]=sum;	
		position++;
	}
	
}

position--;

console.log('The last right position is: ' + position);
console.log(JSON.stringify(fibonacci));</code></pre>

So the last right position is 78 because 14472334024676221 > 9007199254740992 :-)

Be careful with this. Next week I'll try this library [big-integer][biginteger].

[d3js]:http://d3js.org/
[fibonacci]:https://en.wikipedia.org/wiki/Fibonacci
[nodejs]:https://nodejs.org/en/
[biginteger]:https://github.com/peterolson/BigInteger.js