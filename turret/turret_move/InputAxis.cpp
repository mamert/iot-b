#include "Arduino.h"
#include "InputAxis.h"
  

InputAxis::InputAxis(int axisAnalogPin,
      int inValMin, int inValCenter, int inValMax, int inValDeadzone,
      int outValMin, int outValMax) {
  _axisAnalogPin = axisAnalogPin;
  _inValMin = inValMin;
  _inValCenter = inValCenter;
  _inValMax = inValMax;
  _inValDeadzone = inValDeadzone;
  _outValMin = outValMin;
  _outValMax = outValMax;
  
  _inMapInRangeRev = _inValCenter - _inValDeadzone;
  _inMapInRangeFwd = 1023 - _inValCenter - _inValDeadzone;
  
  pinMode(_axisAnalogPin, INPUT);
}

void InputAxis::update() {
  int tmp = analogRead(_axisAnalogPin);
//    Serial.println(tmp);
//    Serial.print("\t");
  tmp = tmp - _inValCenter; // center on 0
  isForward = tmp >= 0;
  tmp = abs(tmp);
  tmp = max(0, tmp - _inValDeadzone); // apply deadzone
  outVal = tmp <= 0 ? 0 : 
    map(tmp, 1, isForward ? _inMapInRangeFwd : _inMapInRangeRev, _outValMin, _outValMax);
}
