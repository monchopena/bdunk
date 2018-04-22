Date: 11 Feb 2013
Categories: development
Summary: A program in Processing that generates a random image
Read more: Show me more

# Every Possible Photograph in Processing

I read in [Microsiervos][microsiervos] an interesting article about [Every Possible Photograph][every_possible_photograph].

I made a Processing program that generates a random image each time you make a click.

<pre><code>//Globals

int w=800;
int h=600;
  
int block_x = 10;
int block_y = 10;
  
int blocks_x=ceil(w/block_x);
int blocks_y=ceil(h/block_y);

void setup() {  
  size(w, h);
}

void draw() {
  
  if (mousePressed) {
    makeit();
  } 
  
}

void makeit() {
  
  for (int i=0;i&lt;blocks_y;i++) {

    int coord_y=i*block_y;
  
    for (int w=0;w&lt;blocks_x;w++) {
      int coord_x=w*block_x;
      color c1 = color(random(0,255), random(0,255), random(0,255));
      fill(c1);
      rect(coord_x, coord_y, coord_x+block_x, coord_y+block_y);
    }
    
  }

}</code></pre>

![Processing Screenshot]

What is the possibility of hitting a recognizable image? :-)

[microsiervos]: http://www.microsiervos.com/archivo/arte-y-diseno/todas-las-fotografias-posibles.html
[every_possible_photograph]: http://www.jeffreythompson.org/EveryPossiblePhotograph.php
[Processing Screenshot]: /attachments/processing_all_image.png "Processing Screenshot"


