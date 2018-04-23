---
layout: post
title:  "Reading texts from image"
date:   2014-02-24 00:00:00 +0200
categories: systems, nodejs
summary: We took a photo to a written text and see it with an OCR program.
---

These last weeks in Wentook, my new venture in IOT, we are devoting much time to R&D. We are thinking about a possible product that is able to read a license plate from a webcam. This can be useful for instance in garages.

To start we investigated on OCR command line. We focused on two options: [Tesseract][tesseract] a Google Project and [Gocr][gocr].

An example with Tesseract:

<pre><code>apt-get install tesseract-ocr
</code></pre>

We call this image test.png

![Test image]

Run the following command in the directory where we saved the image:

<pre><code>tesseract test.png test
</code></pre>

We'll see how a document called test.txt is created, to view simply:

<pre><code>cat test.txt
</code></pre>

It works! Okay now the next step is to create a program that captures an image from a Webcam and kick us the result. We are working NodeJS, so we use this knowledge to make a test area.

You can download the code from the [git page][github_myocr]:

<pre><code>git clone https://github.com/monchopena/myocr.git
</code></pre>

We use as a framework [Express JS][express_js] and for websocket communication [Socket.IO][socket_io].

We'll highlight the most important files.

File [views/index.ejs][file_index].

In line 118 we load the library socket.io

<pre><code>... script src="javascripts/socket.io.js" ...
</code></pre>

From line 121 we call to socket (NOTE: change the URL according to your needs) and listen to the result that the server will send us.

<pre><code>var socket = io.connect('http://192.168.1.130:3000');
    	
    	socket.on('from_server', function (data) {
    		console.log(data);
            $("#reader").html(data);
        });
</code></pre>

In line 87 we have the "captureImage" function which is activated by pressing the "Camera button", the image is sent to the server on line 106 with "socket.emit".

<pre><code> function captureImage() {
...
socket.emit('from_client', dataURL);
</code></pre>

Now let see the [File Server][file_app].

In line 36 we listen the web and websocket

<pre><code>var io = require('socket.io').listen(app.listen(app.get('port')));
</code></pre>

From line 40 we wait for the client to send us a picture. First we store it and then run the OCR command in line 51.

<pre><code>var cmd = 'gocr public/images/test.png -o public/images/ocr.txt';
</code></pre>

Finally we emit the result in line 64:

<pre><code>socket.emit('from_server', data);
</code></pre>

This is my WebCAM:

![MyOCR WebCAM]

Here is a screenshot:

![MyOCR Screenshot]

Connecting it to an Arduino and Raspberry PI ... Can you think of any ideas?

[github_myocr]: https://github.com/monchopena/myocr
[gocr]: http://jocr.sourceforge.net/
[tesseract]: https://code.google.com/p/tesseract-ocr/
[express_js]: http://expressjs.com/
[socket_io]: http://socket.io/
[file_index]: https://github.com/monchopena/myocr/blob/master/views/index.ejs
[file_app]: https://github.com/monchopena/myocr/blob/master/app.js
[Test image]: /attachments/test.png "Test image"
[MyOCR Screenshot]: /attachments/myocr_screenshot.png "MyOCR Screenshot"
[MyOCR WebCAM]: /attachments/myocr_webcam.png "MyOCR WebCAM"

