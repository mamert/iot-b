// calibration for specific modules (each has its own offsets)
#include "MPU6050.h"



void mpu6050_setOffsets(MPU6050 accelgyro) {
    // for module marked "02"
//    accelgyro.setXAccelOffset(-958);
//    accelgyro.setYAccelOffset(-5752);
//    accelgyro.setZAccelOffset(1795);
//    accelgyro.setXGyroOffset(177);
//    accelgyro.setYGyroOffset(11);
//    accelgyro.setZGyroOffset(-17);

    // for module marked "03", on Lenovo headphones
//    accelgyro.setXAccelOffset(2119);
//    accelgyro.setYAccelOffset(-3135);
//    accelgyro.setZAccelOffset(909);
//    accelgyro.setXGyroOffset(-251);
//    accelgyro.setYGyroOffset(-15);
//    accelgyro.setZGyroOffset(-20);
	
	// for module on 1st ESP32+duino
	accelgyro.setXAccelOffset(-1336);
	accelgyro.setYAccelOffset(2030);
	accelgyro.setZAccelOffset(857);
	accelgyro.setXGyroOffset(108);
	accelgyro.setYGyroOffset(-21);
	accelgyro.setZGyroOffset(20);

    // for module marked "04", 90\deg pins
//    accelgyro.setXAccelOffset(-350);
//    accelgyro.setYAccelOffset(-4742);
//    accelgyro.setZAccelOffset(1435);
//    accelgyro.setXGyroOffset(92);
//    accelgyro.setYGyroOffset(14);
//    accelgyro.setZGyroOffset(-22);

    // for module marked "05", flat pins
//    mpu.setXAccelOffset(-4963);
//    mpu.setYAccelOffset(508);
//    mpu.setZAccelOffset(1735);
//    mpu.setXGyroOffset(42);
//    mpu.setYGyroOffset(-13);
//    mpu.setZGyroOffset(-7);



}
