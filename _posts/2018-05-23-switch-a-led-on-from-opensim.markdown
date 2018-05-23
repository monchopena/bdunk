---
layout: post
title:  "Switch a LED on from OpenSim"
date:   2018-05-23 00:00:00 +0200
categories: arduino
summary: Lighting a real light from Second Life
---

Three years ago I published this video:

[![youtube_opensim_video]](https://www.youtube.com/watch?v=jBbb-RDDzes)

And some people asked to me for a \'How to\' ... and well ... here we go!

# Arduino part

We need a Arduino. In this case I'm using a [Arduino Wifi Shield][arduino_wifi_shield].

[This is all the code you will need][arduino_code].

With te Serial Monitor of the Arduino you can see if you are connected to the Wifi and what is your IP.

![arduino_monitor]

You can test if everything is working fine with curl

```
# Low the LED
curl http://192.168.0.21/L

# Hight the LED
curl http://192.168.0.21/H
```

# OpenSim part

How to install:

```
wget http://opensimulator.org/dist/opensim-0.9.0.0.tar.gz
cd opensim-0.9.0.0/bin
```

Then if you try to start opensim you will recieve this warning:

```
./opensim.sh: 5: ./opensim.sh: mono: not found
```

Let's install Mono dependencies:

```
apt-get install mono-complete
```

And start again with:

```
./opensim.sh
```

First question is about region.

Create a user with the command \'_create user_\'.

*IMPORTANT*: If you fill First with \'_moncho_\' and Last with \'_pena_\' your user id will be \'_moncho pena_\'.

# Singularity

You can use another \'Second Life\' Client but in this sample I'm using [Singularity][singularityviewer].

Thiis is the configuration of the grid.

![singularity_config]

How to login:

![singularity_login]

Ok. You are in a virtual world an you now are like a god. Create a new object. Then select, click on the tab Content and New Script.

![singularity_script]

This is the code where we are calling the "webhook" of the Arduino. We change the texture of the object everytime we touch it and we do the call to switch the led.

```
string texture1 = "00000000-0000-2222-3333-100000001041";//UUID of texture 1 (or inventory name if in inventorY)
string texture2= "00000000-0000-1111-9999-000000000003";//UUID of texture2
float time = 0.0;//time to sleep in seconds
integer side = ALL_SIDES;//which side to change texture on
string URL = "http://192.168.0.21";
string HTTP_USER_AGENT = "HTTP_USER_AGENT";
 
switch(string texture)
{
    llSetTexture(texture, side);
    currentstate = ~currentstate;//swith states
    llSleep(time);
}

default
{
    touch_start(integer total_number)
    {
        if(currentstate) {
            switch(texture1);
            llHTTPRequest(URL + "/H", [], "" );
            llSay(0, "On");
        } else {
            switch(texture2);
            llHTTPRequest(URL + "/L", [], "" );
            llSay(0, "Off");
        }
            
    }
}
```

Now if you click the object you will see a warning icon like this:

![singularity_warning]

This is why you have to allow to connect OpenSim to the Arduino Shield IP. Go to the \'_OpenSim.ini_\' and add this line:

```
OutboundDisallowForUserScriptsExcept = 192.168.0.21
```

This a new video with this sample working:

[![youtube_opensim_video_new]](https://www.youtube.com/watch?v=Yo-0jHir8Sk)

Maybe OpemSim is not a fashionable application but is fine to do tests.

[arduino_wifi_shield]: https://store.arduino.cc/arduino-wifi-shield
[youtube_opensim_video]: /attachments/youtube_opensim_video.jpg "Youtube capture OpenSim Video"
[singularityviewer]: http://www.singularityviewer.org/downloads
[arduino_code]: https://gist.github.com/monchopena/71e1918481a52ad8fbce9f796d33107b#file-wifi_web_server
[arduino_monitor]: /attachments/arduino_monitor.png "Arduino Monitor"
[singularity_config]: /attachments/singularity_config_grid.png "Singularity Config Grid"
[singularity_login]: /attachments/singularity_login.png "Singularity Login"
[singularity_script]: /attachments/singularity_script.png "Singularity Script"
[singularity_warning]: /attachments/singularity_warning.png "Singularity warning"
[youtube_opensim_video_new]:  /attachments/switch_a_led_with_arduino.jpg "Switch a led with Arduino"
