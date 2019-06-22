#include "InputAxis.h"
#include "L298N.h"
#include "BTS7960.h"

// Arduino pin assignments:
// Joystick
int ax1Pin = A0;
int ax2Pin = A1;
int trigPin = 13;
// L298N motor driver
int outA1Pin = 2;
int outA2Pin = 4;
int outAEnPin = 6; // Timer0
int outB1Pin = 8;
int outB2Pin = 7;
int outBEnPin = 5; // Timer0
// BTS7960 motor driver
int outCLEnPin = A3; // brown jumper
int outCLPwmPin = 9; // white jumper
int outCREnPin = A2; // orange jumper
int outCRPwmPin = 10; // grey jumper
// also available for later use on arm thing:
// 03(PWM T2): thin green
// 11(PWM T2): thin white
// 12: thin yellow

// hardware calibration
int threshold = 80;
// wrist thing
//int centerA = 480;
//int centerB = 530;
// turret
int centerA = 509;
int centerB = 523;

L298N *ax1, *ax2;
BTS7960 *ax3;


void setup() {
  Serial.begin(115200);
  pinMode(trigPin, INPUT_PULLUP); // needs external pullup, actually
  ax1 = new L298N(outA1Pin, outA2Pin, outAEnPin,
      new InputAxis(ax1Pin, 0, centerA, 1023, threshold, 90, 255));
//  ax2 = new L298N(outB1Pin, outB2Pin, outBEnPin,
//      new InputAxis(ax2Pin, 0, centerB, 1023, threshold, 80, 255));
  ax3 = new BTS7960(outCLEnPin, outCLPwmPin, outCREnPin, outCRPwmPin,
  new InputAxis(ax2Pin, 0, centerB, 1023, threshold, 8, 60));
}

void loop() {
  ax1->update();
//  ax2->update();
  ax3->update();
//  trigVal = digitalRead(trigPin);
//  Serial.println(trigVal);
  
  delay(20);
}
