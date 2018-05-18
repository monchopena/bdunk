---
layout: post
title:  "Switch a LED on from OpenSim"
date:   2018-05-19 00:00:00 +0200
categories: arduino
summary: Lighting a real light from Second Life
---

Three years ago I published this video:

[![](https://img.youtube.com/vi/jBbb-RDDzes/0.jpg)](https://www.youtube.com/watch?v=jBbb-RDDzes)

And some people asked to me for a \'How to\' and thne ... here we go.

# Arduino part

We need a Arduino. In this case we'll use a [Arduino Wifi Shield][arduino_wifi_shield].


# OpenSim part

## How to install

```
wget http://opensimulator.org/dist/opensim-0.9.0.0.tar.gz
cd opensim-0.9.0.0/bin
```

Then if you try to start opensim you will recieve this warning

```
./opensim.sh: 5: ./opensim.sh: mono: not found
```

Then we have to install mono dependencies:

```
apt-get install mono-complete
```

Then start again with

```
./opensim.sh
```

# Singularity

You can use another \'Second Life\' Clients but in this sample I'm using this






[arduino_wifi_shield]: https://store.arduino.cc/arduino-wifi-shield