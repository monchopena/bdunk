Date: 6 May 2013
Categories: arduino
Summary: Upload the firmware to a device from shell.
Read more: Show me more

# Arduino from shell

If you want to upload a program to Arduino from the command line can be done with [inotool][inotool].

First install dependences:

<pre><code>apt-get install python-setuptools
apt-get install python-configobj
apt-get install python-jinja2
apt-get install python-serial</code></pre>

For serial tests:

<pre><code>apt-get install picocom</code></pre>

Obtain source and compile it:

<pre><code>git clone git://github.com/amperka/ino.git
make install</code></pre>

Start a project:

<pre><code>mkdir blink
cd blink
ino init</code></pre>

Change it src/sketch.ino with your program. A sample:

<pre><code>#define LED_PIN 13

void setup()
{
    pinMode(LED_PIN, OUTPUT);
}

void loop()
{
    digitalWrite(LED_PIN, HIGH);
    delay(100);
    digitalWrite(LED_PIN, LOW);
    delay(900);
}</code></pre>

In my case I'm using Arduino Duemilanove so I created a configuration file ino.ini (in the same project folder):

<pre><code>[build]
board-model = atmega328

[upload]
board-model = atmega328</code></pre>

You will need arduino-core:

<pre><code>apt-get install arduino-core</code></pre>

Build project

<pre><code>ino build</code></pre>

And now upload to Arduino:

<pre><code>ino upload</code></pre>

My Arduino:

![My Arduino]

You can see a good tutorial [here][quickstart-guide].

[inotool]: http://inotool.org/
[quickstart-guide]: http://inotool.org/quickstart
[My Arduino]: /attachments/arduino_test.jpg "My Arduino"