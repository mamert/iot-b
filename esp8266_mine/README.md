# Fallout 3 - style "mine"

Motion detection via external device, sound playback (PCM) and some blinking.

This is intended to play mine sounds from Fallout 3 (licensed to Bethesda Softworks), downsampled to 8bit16khz
Attached, however, are samples I recorded myself - because I find it funny for a mine to literally SAY "beep"


Hardware:
* ESP8266 module or dev board
* RCWL-0516 or similar motion sensor
* resistors:
** (optional) 580kΩ resistor (the lower the value, the lower the sensitivity, default is too high)
** 270Ω
** 150Ω
* capacitors:
** 33-68nF
** 2pcs 10μF
* battery, 4-12V (determined by input ranges of your motion detector and your LDO), e.g. 2xLi-Ion or 1xLi-Ion + buck to 5V
* push button
* audio amplifier
* speaker

If using an ESP8266 module (e.g. ESP-07) rather than an ESP8266 dev board (any with a MicroUSB), you also need:
* 2pcs 1-1000μF capacitors
* AMS1117 or similar LDO (if using a dev board, it's probably included)
* some kind of switch (e.g. push button, jumper)





Useful links:
https://github.com/jdesbonnet/RCWL-0516  excellent information & research of RCWL-0516, input voltage, sensitivity control
https://github.com/jdesbonnet/RCWL-0516/issues/11  discusion of a better sensitivity control (not used here)
https://github.com/jdesbonnet/RCWL-0516/issues/2  discussion of filter to use if the motion detector keeps triggering for no reason (not used here)
https://nodemcu.readthedocs.io/en/master/en/modules/pcm/#audio-format  NodeMCU pcm module docs, audio format section
