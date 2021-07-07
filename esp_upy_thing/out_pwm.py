from machine import Pin, PWM

class Out2PWM:
    def __init__(self, pin0, pin1, v_min, v_med, v_max):
        l0_amax = min(v_max, v_med*2-v_min)
        self.thr0, self.magn0 = v_min, l0_amax-v_min
        self.thr1, self.magn1 = v_med, v_max-v_med
        self.scale0 = 256.0/self.magn0/self.magn0
        self.scale1 = 128.0/self.magn1/self.magn1 # half magn
        self.pwm0 = PWM(Pin(pin0), freq=64, duty=0)
        self.pwm1 = PWM(Pin(pin1), freq=64, duty=0)

    def update(self, val):
        v0 = min(max(0, val-self.thr0), self.magn0)
        v1 = min(max(0, val-self.thr1), self.magn1)
        v0 = int(v0**2 * self.scale0)
        v1 = int(v1**2 * self.scale1)
        print("{:5.3f}\t{:5.3f}".format(v0, v1))
        self.pwm0.duty(v0)
        self.pwm1.duty(v1)
