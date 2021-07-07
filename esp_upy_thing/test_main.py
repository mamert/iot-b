from machine import I2C, Pin, soft_reset
from time import ticks_ms, ticks_diff
import uasyncio as aio

import gc
gc.collect()
#from micropython import mem_info
from math import sqrt
from algo import approx_len
from mpu6050 import MPU6050 as IMU
#from imu_out_txt import ImuOutTxt, ImuOutStatsTxt
gc.collect()
from out_pwm import Out2PWM
from data_filter import ListFilter as F, ExponentialSmoother as ES, MovingAvg as MA, MovingMax as MMAX
#gc.collect()

D1=5
D2=4
D4=2
D5=14
D6=12
D7 = 13
D8=15
D11=9 # can cause reset
D12=10 # sometimes input only

#LED0_PIN = D1
#LED1_PIN = D2
WS_PIN = D4
#SCL_PIN = D5
#SDA_PIN = D6
#BTN_PIN = D7
#MPU_INT_PIN = D8


SDA_PIN = D1
SCL_PIN = D2
LED0_PIN = D5
LED1_PIN = D6




WS_LEDS = 6
WS_PIN = 12  # GPIO 12 is D6. Warn: doesn't work on that module?
MPU_POLL_MS = 30
FILT_ES = 0.1
FILT_MA = 12
#FILT_ES = 0.2
#FILT_MA = 10
#FILT_ES = 0.3
#FILT_MA = 6
SCALE_DOWN = 64
#SCALE_DOWN = 128
FILT_AG_RATIO = 1.8
Q_S_TICS = 9 

OUT_C = 1
# TODO HW: taptic directly on barely-filtered accel axis uotput

magnitudes = ( # rma(max), abs_max
    (30, 60), # stationary
    (72, 150), # in hand, not moving
    (225, 440), # v. slow
    (650, 1425), # threshold speed
    (6000, 15700), # v. fast
)

async def imu_coro(imu):
    print('Running...')
    outputs = [
        #ImuOutTxt(OUT_C),
        #ImuOutStatsTxt(OUT_C),
        Out2PWM(LED0_PIN, LED1_PIN, 380, 700, 3000),
    ]
    f3 = F(ES, FILT_ES)
    fm = F(MA, FILT_MA)
    o_max = MMAX(Q_S_TICS)
    
    last = 0
    while True:
        data = imu.get_values()
        magn_a = approx_len(*data[0:3])
        magn_g = approx_len(*data[3:6])
        data = [magn_a*FILT_AG_RATIO, magn_g]
        df3 = f3(data)
        dfm = fm(data)
        data = max(abs(df3[0]-dfm[0]), abs(df3[1]-dfm[1]))
        data = o_max(data)
        
        for o in outputs:
            o.update(data)
            
        now = ticks_ms()
        delta = ticks_diff(now, last)
        last = now
        await aio.sleep_ms(MPU_POLL_MS-delta)


def main():
    i2c = machine.I2C(scl=Pin(SCL_PIN), sda=Pin(SDA_PIN))
    imu = IMU(i2c)
    #imu.val_test()
    #gc.collect()
    #mem_info()
    loop = aio.get_event_loop()
    loop.create_task(imu_coro(imu))
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        print('Interrupted')
    finally:
        #aio.new_event_loop()
        soft_reset()


main()


