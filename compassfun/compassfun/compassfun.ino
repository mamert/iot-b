// see https://github.com/jrowberg/i2cdevlib, some comments come from there

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif


#include "I2Cdev.h"
#include "HMC5883L.h"

HMC5883L mag;

int16_t minx=-200, miny=-200, minz=-200, maxx=200, maxy=200, maxz=200;
int16_t mx, my, mz;
#define LED1 9
#define LED2 6
#define LED3 5


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
  
  mag.initialize();
  Serial.println(mag.testConnection() ? "HMC5883L connection successful" : "HMC5883L connection failed");
  
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
}

void loop() {
  // read raw heading measurements from device
  mag.getHeading(&mx, &my, &mz);
  
  processVals();
  delay(150);
}

void processVals(){
  // maybe update the range
  minx = min(minx, mx);
  miny = min(miny, my);
  minz = min(minz, mz);
  maxx = max(maxx, mx);
  maxy = max(maxy, my);
  maxz = max(maxz, mz);

  
  analogWrite(LED1, map(max(0,mx), 0,maxx,0,255));
  analogWrite(LED2, map(max(0,my), 0,maxy,0,255));
  analogWrite(LED3, map(max(0,mz), 0,maxz,0,255));

  
  // display tab-separated gyro x/y/z values
  Serial.print("mag:\t");
  Serial.print(mx); Serial.print("\t");
  Serial.print(my); Serial.print("\t");
  Serial.print(mz); Serial.print("\t");
  
  // To calculate heading in degrees. 0 degree indicates North
  float heading = atan2(my, mx);
  if(heading < 0)
    heading += 2 * M_PI;
  Serial.print("heading:\t");
  Serial.println(heading * 180/M_PI);

}
