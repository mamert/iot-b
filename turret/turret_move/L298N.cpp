#include "Arduino.h"
#include "L298N.h"
#include "InputAxis.h"

L298N::L298N(int directionPinA, int directionPinB, int enablePin,
  InputAxis *inputAxis) {
  _directionPinA = directionPinA;
  _directionPinB = directionPinB;
  _enablePin = enablePin;
  _inputAxis = inputAxis;
  
  pinMode(directionPinA, OUTPUT);
  pinMode(directionPinB, OUTPUT);
  pinMode(enablePin, OUTPUT);
}

void L298N::update() {
  _inputAxis->update();
  
  analogWrite(_enablePin, _inputAxis->outVal);
  digitalWrite(_directionPinA, _inputAxis->isForward ? LOW : (_inputAxis->outVal > 0 ? HIGH : LOW));
  digitalWrite(_directionPinB, _inputAxis->isForward ? (_inputAxis->outVal > 0 ? HIGH : LOW) : LOW);  
}
