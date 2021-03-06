// include wire library first
#include <Wire.h>
// include port expander library second
#include <Arduino_I2C_Port_Expander.h>

#include "InputAxis.h"
#include "L298N.h"
#include "BTS7960.h"


//EXPAND io(0x01);      //port expander with address 0x01
// has "Slave_I2C_Port_Expander" sketch on it

// Arduino pin assignments:
// Joystick
int ax1Pin = A2;
int ax2Pin = A3;
int trigPin = 4;
int firePin = 5;
// L298N motor driver (switch A1/A2 for grabber)
int outA1Pin = 2;
int outA2Pin = 4;
int outAEnPin = 6; // Timer0
int outB1Pin = 8;
int outB2Pin = 7;
int outBEnPin = 5; // Timer0
// BTS7960 motor driver
int outCLPwmPin = 6;
int outCRPwmPin = 5;

int outTrigPin = 9;
int outFirePin = 3;

int swapAxesPin = 10;

// also available for later use on arm thing:
// 11(PWM T2): thin white
// 12: thin yellow
// 10(PWM T1): white jumper
// A2: brown jumper
// A3: orange jumper

// hardware calibration
int threshold = 80;
// wrist thing
//int centerA = 480;
//int centerB = 530;
// turret
int centerA = 509;
int centerB = 523;
int hMinPwm = 12;
int vMinPwm = 14;

//L298N *axH, *axV;
BTS7960 *ax3;

void setup() {
  Wire.begin();
  Serial.begin(115200);
  pinMode(swapAxesPin, INPUT_PULLUP);
  pinMode(outTrigPin, OUTPUT);
  pinMode(outFirePin, OUTPUT);
  // change PWM frequency: timer0: pins 5 & 6;
  // why do it? No high-pitched noise, better torque @ low duty
  // WARNING! Also affects TIME (millis(), and delay()).
  TCCR0B = (TCCR0B & 0b11111000) | 0x04;
  // 0x01, prescaler 1,		62500Hz
  // 0x02, prescaler 8,		7812.5Hz
  // 0x03, prescaler 64,	976.5625Hz; default
  // 0x04, prescaler 256,	244.140625Hz
  // 0x05, prescaler 1024,	61.03515625Hz


  
  bool swapAxes = digitalRead(swapAxesPin);
  //axH = new L298N(swapAxes ? outA2Pin : outA1Pin, 
  //    swapAxes ? outA1Pin : outA2Pin, outAEnPin,
  //    &((new InputAxis(ax1Pin, 0, centerA, 1023, threshold, hMinPwm, 255, &io))->curve(true))); // increase for grabber: 80?
  //axV = new L298N(swapAxes ? outB2Pin : outB1Pin, 
  //    swapAxes ? outB1Pin : outB2Pin, outBEnPin,
  //    &((new InputAxis(ax2Pin, 0, centerB, 1023, threshold, vMinPwm, 255, &io))->curve(true)));
  ax3 = new BTS7960(outCLPwmPin, outCRPwmPin,
      &((new InputAxis(ax2Pin, 0, centerB, 1023, threshold, 10, 200))->curve(true)));
}

void loop() {
  //axH->update();
  //axV->update();
  ax3->update();
  //bool temp = io.digitalReadPullup(trigPin);
  //digitalWrite(outTrigPin, temp);
  //temp = io.digitalReadPullup(firePin);
  //digitalWrite(outFirePin, temp);
  // TODO: turn off fire after maybe 0.4s, for single shot
//  trigVal = digitalRead(trigPin);
//  Serial.println(trigVal);
  
  delay(6); // see timer0 prescaler change in setup() (@1kH we want 20-30)
}
