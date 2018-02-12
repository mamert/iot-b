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
    while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
    }

    delay(1000);
    // initialize device
    Serial.println("Initializing I2C devices...");
    accelgyro.initialize();

    // verify connection
    Serial.println("Testing device connections...");
    Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

    // use the code below to change accel/gyro offset values
    Serial.println("Updating internal sensor offsets...");
//    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -896
//    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -5743
//    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1476
    // void setXAccelOffset(int16_t offset); etc - don't understand yet
    accelgyro.setXAccelOffset(-958);
    accelgyro.setYAccelOffset(-5752);
    accelgyro.setZAccelOffset(1795);

//    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
//    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
//    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    // average gyro values at rest were: -718 -35 95 (module "02")
    accelgyro.setXGyroOffset(177);
    accelgyro.setYGyroOffset(11);
    accelgyro.setZGyroOffset(-17);
    
    Serial.print("\n");

}

void loop() {
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // some functions; more here: https://github.com/jrowberg/i2cdevlib/blob/master/Arduino/MPU6050/MPU6050.h
    //int16_t getTemperature();
    //void getAcceleration(int16_t* x, int16_t* y, int16_t* z);
    //void getRotation(int16_t* x, int16_t* y, int16_t* z);
    //int16_t getRotationX(); int16_t getRotationY(); int16_t getRotationZ();

    // display tab-separated accel/gyro x/y/z values
//    Serial.print("a/g:\t");
//    Serial.print(ax); Serial.print("\t");
//    Serial.print(ay); Serial.print("\t");
//    Serial.print(az); Serial.print("\t");
//    Serial.print(gx); Serial.print("\t");
//    Serial.print(gy); Serial.print("\t");
//    Serial.println(gz); Serial.print("\t"); // 0

      
    mouseVX = gx/sensitivityDivider;
    mouseVY = -gz/sensitivityDivider;
    Mouse.move(mouseVX, mouseVY);
  
    delay(15);
}

