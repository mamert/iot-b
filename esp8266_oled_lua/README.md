# iot-b
A wearable thing for testing accel/gyro data from forearm

TODO: repetition detect:
several levels of lowpass filter
on every data channel
moving window:
* normalize by highest/lowestget
* get (diff of peaks (how close the highs are, same for lows), pythagorate that with peak distance diff
* lowest above value: most trustworthy axis/lowpassValue combo
* from that one, peaks are rep counts