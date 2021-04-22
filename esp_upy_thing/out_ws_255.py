from machine import Pin
from neopixel import NeoPixel  # Note: slice assignment and len don't work on NeoPixel



class ImuOutWS:
    def __init__(self, data_pin_num, led_count):
        self.data_pin_num = data_pin_num
        self.led_count = led_count
        self.np = NeoPixel(Pin(self.data_pin_num), self.led_count)
        for i in range(led_count):
            self.np[i] = (0, 0, 0)
    
    def _get_color(self, val):
        neg = val < 0
        val = int(val**2 / 255)
        return (0 if neg else val,
                2,
                val if neg else 0)
        #return (max(0, min(255, val)),
        #        2,
        #        max(0, min(255, -val)))
        
    def update(self, data):
        pass
        for i, v in enumerate(data):
            self.np[i] = self._get_color(v)
            self.np.write()
    