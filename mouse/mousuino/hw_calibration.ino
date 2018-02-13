// calibration for specific modules (each has its own offsets)
#include "MPU6050.h"



void mpu6050_setOffsets(MPU6050 accelgyro) {
	// for module marked "02"
    accelgyro.setXAccelOffset(-958);
    accelgyro.setYAccelOffset(-5752);
    accelgyro.setZAccelOffset(1795);
    accelgyro.setXGyroOffset(177);
    accelgyro.setYGyroOffset(11);
    accelgyro.setZGyroOffset(-17);
}
