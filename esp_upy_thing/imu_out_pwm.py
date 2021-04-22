from machine import Pin, PWM


class ImuOutPwm:
    def __init__(self, out_pin_num):
        self.pwm = PWM(Pin(2), freq=50, duty=0)
    
    def _get_mag(self, data):
        light movement
        0.000,-31.031,-41.937,
        -17.844,-14.000,-27.273,
        158.875,13.875,0.000,
        26.391,16.648,18.523

        # full twist range and above-light movement
        #-126.625,-127.406,-133.687,
        #-45.852,-54.961,-73.914,
        #140.656,37.469,115.688,
        #63.805,75.070,45.641
        val = int(val**2 / 255)
        return (max(0, min(255, val)),
                2,
                max(0, min(255, -val)))
        
    def update(self, data):
        pass
        for i, v in enumerate(data):
            self.np[i] = self._get_color(v)
            self.np.write()
    