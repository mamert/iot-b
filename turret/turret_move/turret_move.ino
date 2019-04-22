#include "InputAxis.h"

// Arduino pin assignments:
// Joystick
int ax1Pin = A0;
int ax2Pin = A1;
int trigPin = 13;
// motor driver
int outA1Pin = 2;
int outA2Pin = 4;
int outAEnPin = 6;
int outB1Pin = 8;
int outB2Pin = 7;
int outBEnPin = 5;

// also available for later use on arm thing: GPIO10(PWM), 11(PWM), 12 as green, white & yellow cable

// joystick input values
int ax1Val = 0;
int ax2Val = 0;
int trigVal = 0;

// hardware calibration
int threshold = 80;
// wrist thing
//int centerA = 480;
//int centerB = 530;
// turret
int centerA = 509;
int centerB = 523;

InputAxis *ax1, *ax2;

void setup() {
  Serial.begin(115200);
  pinMode(trigPin, INPUT_PULLUP); // needs external pullup, actually
  pinMode(outA1Pin, OUTPUT);
  pinMode(outA2Pin, OUTPUT);
  pinMode(outAEnPin, OUTPUT);
  pinMode(outB1Pin, OUTPUT);
  pinMode(outB2Pin, OUTPUT);
  pinMode(outBEnPin, OUTPUT);
  ax1 = new InputAxis(ax1Pin, 0, centerA, 1023, threshold, 80, 255);
  ax2 = new InputAxis(ax2Pin, 0, centerB, 1023, threshold, 80, 255);
}

void loop() {
  ax1->refresh();
  ax2->refresh();
//  trigVal = digitalRead(trigPin);
//  Serial.println(trigVal);
  
  delay(30);
  moveA(ax1);
  moveB(ax2);
}


void moveA(InputAxis *axis) {
  move(outA1Pin, outA2Pin, outAEnPin, axis);
}

void moveB(InputAxis *axis) {
  move(outB1Pin, outB2Pin, outBEnPin, axis);
}

void move(int pin1, int pin2, int pwmPin, InputAxis *axis) {
  analogWrite(pwmPin, axis->outVal);
  
  digitalWrite(pin1, axis->isForward ? LOW : (axis->outVal > 0 ? HIGH : LOW));
  digitalWrite(pin2, axis->isForward ? (axis->outVal > 0 ? HIGH : LOW) : LOW);  
}
