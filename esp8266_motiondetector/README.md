React to pin state change (RCWL-0516 motion detector) and do something

Hardware:
* ESP8266 module (ESP-07)
* RCWL-0516 motion sensor
* AMS1117 or similar LDO
* 580kΩ resistor (the lower the value, the lower the sensitivity, default is too high)
* 3pcs 10μF capacitor
* battery, 4-12V (I'm using 2xLi-Ion)
* push button
* audio amplifier
* speaker





Useful links:
https://github.com/jdesbonnet/RCWL-0516  excellent information & research of RCWL-0516, input voltage, sensitivity control
https://github.com/jdesbonnet/RCWL-0516/issues/11  discusion of a better sensitivity control (not used here)
https://github.com/jdesbonnet/RCWL-0516/issues/2  discussion of filter to use if the motion detector keeps triggering for no reason (not used here)
