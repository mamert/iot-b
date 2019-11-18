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
  digitalWrite(_enRPin, HIGH);
  digitalWrite(_pwmRPin, LOW); 
    digitalWrite(_enLPin, HIGH);
  digitalWrite(_enRPin, HIGH);  
}

void BTS7960::update() {
  _inputAxis->update();
  
  analogWrite(_pwmLPin, _inputAxis->isForward ? 0 : _inputAxis->outVal);
  analogWrite(_pwmRPin, _inputAxis->isForward ? _inputAxis->outVal : 0);
//  digitalWrite(_enLPin, _inputAxis->isForward ? LOW : (_inputAxis->outVal > 0 ? HIGH : LOW));
//  digitalWrite(_enRPin, _inputAxis->isForward ? (_inputAxis->outVal > 0 ? HIGH : LOW) : LOW);  
  digitalWrite(_enLPin, HIGH);
  digitalWrite(_enRPin, HIGH);  
}
