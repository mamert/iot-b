// calibration for specific modules (each has its own offsets)
#include "MPU6050.h"



void mpu6050_setOffsets(MPU6050 mpu) {
    // for module marked "02"
//    mpu.setXAccelOffset(-958);
//    mpu.setYAccelOffset(-5752);
//    mpu.setZAccelOffset(1795);
//    mpu.setXGyroOffset(177);
//    mpu.setYGyroOffset(11);
//    mpu.setZGyroOffset(-17);

    // for module "03", buried in white-grey PCL
//    mpu.setXAccelOffset(2068);
//    mpu.setYAccelOffset(-3122);
//    mpu.setZAccelOffset(849);
//    mpu.setXGyroOffset(-205);
//    mpu.setYGyroOffset(-40);
//    mpu.setZGyroOffset(-12);

	
	// for module on 1st ESP32+duino
	mpu.setXAccelOffset(-1336);
	mpu.setYAccelOffset(2030);
	mpu.setZAccelOffset(857);
	mpu.setXGyroOffset(108);
	mpu.setYGyroOffset(-21);
	mpu.setZGyroOffset(20);

    // for module marked "04", 90\deg pins
//    mpu.setXAccelOffset(-345);
//    mpu.setYAccelOffset(-4746);
//    mpu.setZAccelOffset(1453);
//    mpu.setXGyroOffset(97);
//    mpu.setYGyroOffset(21);
//    mpu.setZGyroOffset(3);


    // for module marked "05", flat pins
//    mpu.setXAccelOffset(-4963);
//    mpu.setYAccelOffset(508);
//    mpu.setZAccelOffset(1735);
//    mpu.setXGyroOffset(42);
//    mpu.setYGyroOffset(-13);
//    mpu.setZGyroOffset(-7);

    // for module marked "06", 90\deg pins
//    mpu.setXAccelOffset(-1940);
//    mpu.setYAccelOffset(-1396);
//    mpu.setZAccelOffset(320);
//    mpu.setXGyroOffset(-179);
//    mpu.setYGyroOffset(-4);
//    mpu.setZGyroOffset(140);
    
    // for module marked "07", 90\deg pins
//    mpu.setXAccelOffset(1448);
//    mpu.setYAccelOffset(1230);
//    mpu.setZAccelOffset(678);
//    mpu.setXGyroOffset(-18);
//    mpu.setYGyroOffset(53);
//    mpu.setZGyroOffset(23);

}
