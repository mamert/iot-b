#include "InputAxis.h"
#include "L298N.h"

// Arduino pin assignments:
// Joystick
int ax1Pin = A0;
int ax2Pin = A1;
int trigPin = 13;
// motor driver
int outA1Pin = 4;
int outA2Pin = 2;
int outAEnPin = 6; // Timer0
int outB1Pin = 8;
int outB2Pin = 7;
int outBEnPin = 5; // Timer0

// also available for later use on arm thing:
// 03(PWM T2): thin green
// 11(PWM T2): thin white
// 12: thin yellow
// 10(PWM T1): white jumper
// 09(PWM T1): grey jumper
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

L298N *ax1, *ax2;

void setup() {
  Serial.begin(115200);
  pinMode(trigPin, INPUT_PULLUP); // needs external pullup, actually
  ax1 = new L298N(outA1Pin, outA2Pin, outAEnPin,
      new InputAxis(ax1Pin, 0, centerA, 1023, threshold, 80, 255));
  ax2 = new L298N(outB1Pin, outB2Pin, outBEnPin,
      new InputAxis(ax2Pin, 0, centerB, 1023, threshold, 80, 255));
}

void loop() {
  ax1->update();
  ax2->update();
//  trigVal = digitalRead(trigPin);
//  Serial.println(trigVal);
  
  delay(30);
}
