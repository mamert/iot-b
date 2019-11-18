#include "Arduino.h"
#include "BTS7960.h"
#include "InputAxis.h"




BTS7960::BTS7960(int enLPin, int pwmLPin, int enRPin, int pwmRPin,
  InputAxis *inputAxis) {
  _enLPin = enLPin;
  _pwmLPin = pwmLPin;
  _enRPin = enRPin;
  _pwmRPin = pwmRPin;
  _inputAxis = inputAxis;
  
  pinMode(_enLPin, OUTPUT);
  pinMode(_pwmLPin, OUTPUT);
  pinMode(_enRPin, OUTPUT);
  pinMode(_pwmRPin, OUTPUT);
  digitalWrite(_enLPin, HIGH);
  digitalWrite(_pwmLPin, LOW);
  if(_enRPin > -1) digitalWrite(_enRPin, HIGH);
  digitalWrite(_pwmRPin, LOW); 
  if(_enLPin > -1) digitalWrite(_enLPin, HIGH);
  digitalWrite(_enRPin, HIGH);  
}
BTS7960::BTS7960(int pwmLPin, int pwmRPin,
  InputAxis *inputAxis): BTS7960::BTS7960(-1, pwmLPin, -1, pwmRPin,
  inputAxis) {}

void BTS7960::update() {
  _inputAxis->update();
  
  analogWrite(_pwmLPin, _inputAxis->isForward ? 0 : _inputAxis->outVal);
  analogWrite(_pwmRPin, _inputAxis->isForward ? _inputAxis->outVal : 0);
// does enabling only 1 direction at a time just not work? Why are there 2 pins, then?
//  digitalWrite(_enLPin, _inputAxis->isForward ? LOW : (_inputAxis->outVal > 0 ? HIGH : LOW));
//  digitalWrite(_enRPin, _inputAxis->isForward ? (_inputAxis->outVal > 0 ? HIGH : LOW) : LOW);
}
