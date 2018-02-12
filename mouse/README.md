Air Mouse.

For now:

Raw input from MPU-6050

Requires I2Cdev and MPU6050 from https://github.com/jrowberg/i2cdevlib/tree/master/Arduino


TODO:
* buttons
* discard first values read (may be wrong)
* try accel axes to do trigonometry to gyro axes - so can hold "pointer" at an angle and motion will still match
* try accel rather than gyro (or both, on separate mdules: accel for walking, gyro for looking?)
* pot to control sensitivity (option to switch between that and presets like 250)
* on/off button (also working as "temporary freeze" on longer hold, to help center)
* trackball as alt
* more buttons for keyboard keys (wsad, directional, etc)
* upgrade options for wireless:
** a BT module (no longer needs Pro micro, a Pro Mini will suffice)
** RPi0W with hidclient (first connect via USB, later skip arduino)
* use MPU-6050's DMP rather than raw input
