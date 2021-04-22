from machine import Pin
from neopixel import NeoPixel  # Note: slice assignment and len don't work on NeoPixel
from time import sleep
import math

NUM_LEDS = 6
WS_PIN = 2  # GPIO 2 is "D4"
#WS_PIN = 14  # GPIO 14 is "D5"
#WS_PIN = 18  # GPIO 14 is "D8"
#SCL_PIN = 5  # GPIO 5 is D1
#SDA_PIN = 4  # GPIO 4 is D2
SCL_PIN = 14  # GPIO 14 is D5
SDA_PIN = 12  # GPIO 12 is D6


def marquee_gen(led_count):
    step = 0
    while True:
        r = int((1 + math.sin(step * 0.1324)) * 127)
        g = int((1 + math.sin(step * 0.1654)) * 127)
        b = int((1 + math.sin(step * 0.1)) * 127)
        yield (step % led_count), (r, g, b)
        step += 1
        



def main():
    np = NeoPixel(Pin(WS_PIN), NUM_LEDS)
    try:
        np = NeoPixel(Pin(WS_PIN), NUM_LEDS)
        for i in range(NUM_LEDS):
            np[i] = (0, 0, 0)
        for ledNum, color in marquee_gen(NUM_LEDS):
            np[ledNum] = color
            np.write()
            sleep(0.1)
    except KeyboardInterrupt:
        for i in range(NUM_LEDS):
            np[i] = (0, 0, 0)
            np.write()
    


main()