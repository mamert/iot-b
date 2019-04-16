// see https://github.com/jrowberg/i2cdevlib, some comments come from there
#include "I2Cdev.h"
#include "MPU6050.h"
#include <Mouse.h>
#include <Bounce2.h>

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

MPU6050 accelgyro; // default is 0x68; with AD0 high it's 0x69

#define INTERRUPT_PIN 7
// INT0 is pin 2 on most ATMEGAs, 3 on ATmega32u4, but 3 is taken up by SCL there

int16_t ax, ay, az;
int16_t gx, gy, gz;
bool isInterrupted;

int16_t sensitivityDivider = 250;
//int deadZone = 40; // radius in which motion is ignored. Not used since much smaller than sensitivityDivider.

signed char mouseVX, mouseVY;


const unsigned long BTN_THROTTLE_DELAY = 40;
const int btnPin[] = {10, 16, 14};
const char mouseBtn[] = {MOUSE_LEFT, MOUSE_MIDDLE, MOUSE_RIGHT};
Bounce * btn = new Bounce[3];


bool blinkState = false;

void onMotion() {
//    Serial.println("INTERRUPT");
    isInterrupted = true;
}


void setup() {
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
        Wire.setClock(400000); // 400kHz I2C clock. Comment this line if having compilation difficulties
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    Serial.begin(38400);
//    while (!Serial); // wait for serial port to connect. Needed for Leonardo only
    delay(10); // we don't really care about serial if not connected, so just this instead

    isInterrupted = false;
    Serial.println("Initializing MPU-6050");
    accelgyro.initialize();

    Serial.println("Testing device connection...");
    Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

    Serial.println("Updating internal sensor offsets...");
    mpu6050_setOffsets(accelgyro);

    accelgyro.resetGyroscopePath();
    accelgyro.resetAccelerometerPath();
//    accelgyro.resetTemperaturePath();
    accelgyro.setInterruptMode(1);// Register 37, Bit 7  0: active high
    accelgyro.setInterruptDrive(0);// Register 37, Bit 6  0: push-pull
    accelgyro.setInterruptLatch(1);// Register 37, Bit 5  0: 0: 50us-pulse, 1: latch-until-int-cleared
    accelgyro.setInterruptLatchClear(0);// Register 37, Bit 4  0: 0=status-read-only
    accelgyro.setFSyncInterruptLevel(1);// Register 37, Bit 3  0: active high
    accelgyro.setFSyncInterruptEnabled(0);// Register 37, Bit 2  0: New FSYNC pin interrupt off
    accelgyro.setI2CBypassEnabled(0);// Register 37, Bit 1  0: no direct access o econdary i2c
    accelgyro.setClockOutputEnabled(0);// Register 37, Bit 0  0: no external clock
//    accelgyro.setDLPFMode(3); // low-pass filter, 3: 44Hz
    accelgyro.setDHPFMode(1); // high-pass filter, 2: 2.5Hz
    accelgyro.setMotionDetectionThreshold(1);//20?
    accelgyro.setMotionDetectionDuration(40); // millieconds, 40?
    accelgyro.setAccelerometerPowerOnDelay(2); // 4+2ms
    accelgyro.setMotionDetectionCounterDecrement(1);
    accelgyro.setFreefallDetectionCounterDecrement(1);
    accelgyro.setIntEnabled(0); // zero all
    accelgyro.setIntMotionEnabled(1); // FINALLY
    
    pinMode(LED_BUILTIN, OUTPUT);
    pinMode(INTERRUPT_PIN, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), onMotion, FALLING);
    
    for(int i = 0; i < 3; i++){
      btn[i].attach(btnPin[i], INPUT_PULLUP);
      btn[i].interval(BTN_THROTTLE_DELAY);
    }
}

void loop() {
  if(isInterrupted){
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // some functions; more here: https://github.com/jrowberg/i2cdevlib/blob/master/Arduino/MPU6050/MPU6050.h
    //int16_t getTemperature(); // bullshit value on knockoff modules
    //void getAcceleration(int16_t* x, int16_t* y, int16_t* z);
    //void getRotation(int16_t* x, int16_t* y, int16_t* z);
    //int16_t getRotationX(); int16_t getRotationY(); int16_t getRotationZ();

    processMouse(-gy, gz);
    blinkState = !blinkState;
    digitalWrite(LED_BUILTIN, blinkState);
  }
  isInterrupted = false;
  processBtns();
  delay(15);
}

void processMouse(int dX, int dY){

    mouseVX = dX/sensitivityDivider;
    mouseVY = dY/sensitivityDivider;
    if(mouseVX != 0 || mouseVX != 0){
      Mouse.move(mouseVX, mouseVY);
//      altSerial.print("$M 0 ");
//      altSerial.print(mouseVX);
//      altSerial.print(" ");
//      altSerial.print(mouseVY);
//      altSerial.print(" 0\n");
    }

  
}

void processBtns(){
  for(int i = 0; i < 3; i++){
    btn[i].update();
    if (btn[i].fell()) {
      Mouse.press(mouseBtn[i]);
    } else if(btn[i].rose()){
      Mouse.release(mouseBtn[i]);
    }
  }
}

