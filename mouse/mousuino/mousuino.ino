// see https://github.com/jrowberg/i2cdevlib, some comments come from there
#include "I2Cdev.h"
#include "MPU6050.h"
#include <Mouse.h>

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

MPU6050 accelgyro; // default is 0x68; with AD0 high it's 0x69
//int interruptPin = 3; // INT0 is 3 on Micro, 2 on others

int16_t ax, ay, az;
int16_t gx, gy, gz;

int16_t sensitivityDivider = 250;
//int deadZone = 40; // radius in which motion is ignored. Not used since much smaller than sensitivityDivider.

signed char mouseVX, mouseVY;



void setup() {
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    Serial.begin(38400);
//    while (!Serial) {
//    ; // wait for serial port to connect. Needed for Leonardo only
//    }
    delay(10); // we don't really care about serial if not connected, so just this instead
    
    Serial.println("Initializing MPU-6050");
    accelgyro.initialize();

    Serial.println("Testing device connection...");
    Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

    Serial.println("Updating internal sensor offsets...");
    mpu6050_setOffsets(accelgyro);
}

void loop() {
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // some functions; more here: https://github.com/jrowberg/i2cdevlib/blob/master/Arduino/MPU6050/MPU6050.h
    //int16_t getTemperature(); // bullshit value on knockoff modules
    //void getAcceleration(int16_t* x, int16_t* y, int16_t* z);
    //void getRotation(int16_t* x, int16_t* y, int16_t* z);
    //int16_t getRotationX(); int16_t getRotationY(); int16_t getRotationZ();

    mouseVX = gx/sensitivityDivider;
    mouseVY = -gz/sensitivityDivider;
    Mouse.move(mouseVX, mouseVY);
  
    delay(15);
}

