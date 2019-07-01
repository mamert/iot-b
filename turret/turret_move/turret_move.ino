// include wire library first
#include <Wire.h>
// include port expander library second
#include <Arduino_I2C_Port_Expander.h>

#include "InputAxis.h"
#include "L298N.h"


EXPAND io(0x01);      //port expander with address 0x01
// has "Slave_I2C_Port_Expander" sketch on it

// Arduino pin assignments:
// Joystick
int ax1Pin = A0;
int ax2Pin = A1;
int trigPin = 4;
int firePin = 5;
// motor driver
int outA1Pin = 2;
int outA2Pin = 4;
int outAEnPin = 6;
int outB1Pin = 8;
int outB2Pin = 7;
int outBEnPin = 5;
int outTrigPin = 9;
int outFirePin = 3;


// also available for later use on arm thing: GPIO10(PWM), 11(PWM), 12 as green, white & yellow cable

// hardware calibration
int threshold = 80;
// wrist thing
//int centerA = 480;
//int centerB = 530;
// turret
int centerA = 509;
int centerB = 523;

L298N *ax1, *ax2;

void setup() {
  Wire.begin();
  Serial.begin(115200);
  pinMode(trigPin, INPUT_PULLUP);
  pinMode(firePin, INPUT_PULLUP);
  pinMode(outTrigPin, OUTPUT);
  pinMode(outFirePin, OUTPUT);
  ax1 = new L298N(outA1Pin, outA2Pin, outAEnPin,
      new InputAxis(ax1Pin, 0, centerA, 1023, threshold, 80, 255, &io));
  ax2 = new L298N(outB1Pin, outB2Pin, outBEnPin,
      new InputAxis(ax2Pin, 0, centerB, 1023, threshold, 80, 255, &io));
}

void loop() {
  ax1->update();
  ax2->update();
  bool temp = io.digitalReadPullup(trigPin);
  digitalWrite(outTrigPin, temp);
  temp = io.digitalReadPullup(firePin);
  digitalWrite(outFirePin, temp);
  // TODO: turn off fire after maybe 0.4s, for single shot
//  trigVal = digitalRead(trigPin);
//  Serial.println(trigVal);
  
  delay(30);
}
