import uasyncio as asyncio
from machine import I2C, Pin
from time import ticks_ms, ticks_diff

import gc
gc.collect()
#from micropython import mem_info
from math import sqrt
from algo import approx_len
from mpu6050 import MPU6050 as IMU
from imu_out_txt import ImuOutTxt, ImuOutStatsTxt
gc.collect()
from out_pwm import Out2PWM
from data_filter import ListFilter as F, ExponentialSmoother as ES, MovingAvg as MA, MovingMax as MMAX
#gc.collect()

#SCL_PIN = 5  # GPIO 5 is D1
#SDA_PIN = 4  # GPIO 4 is D2
SCL_PIN = 14  # GPIO 14 is D5
SDA_PIN = 12  # GPIO 12 is D6

LED0_PIN = 13  # GPIO 13 is D7
LED1_PIN = 14  # GPIO 14 is D5

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

async def imu_task(imu):
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
        await asyncio.sleep_ms(MPU_POLL_MS-delta)


def main():
    i2c = machine.I2C(scl=Pin(SCL_PIN), sda=Pin(SDA_PIN))
    imu = IMU(i2c)
    #imu.val_test()
    #gc.collect()
    #mem_info()
    try:
        asyncio.run(imu_task(imu))
    except KeyboardInterrupt:
        print('Interrupted')
    finally:
        asyncio.new_event_loop()


main()


