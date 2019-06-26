#include "Arduino.h"
#include "InputAxis.h"

#include <Arduino_I2C_Port_Expander.h>

InputAxis::InputAxis(int axisAnalogPin,
      int inValMin, int inValCenter, int inValMax, int inValDeadzone,
      int outValMin, int outValMax) : InputAxis::InputAxis(axisAnalogPin,
      inValMin, inValCenter, inValMax, inValDeadzone,
      outValMin, outValMax, NULL){}

InputAxis::InputAxis(int axisAnalogPin,
      int inValMin, int inValCenter, int inValMax, int inValDeadzone,
      int outValMin, int outValMax, EXPAND *expander) :
  _axisAnalogPin(axisAnalogPin),
  _inValMin(inValMin),
  _inValCenter(inValCenter),
  _inValMax(inValMax),
  _inValDeadzone(inValDeadzone),
  _outValMin(outValMin),
  _outValMax(outValMax),
  _expander(expander) {
  
  _inMapInRangeRev = _inValCenter - _inValDeadzone;
  _inMapInRangeFwd = 1023 - _inValCenter - _inValDeadzone;
  if(!_expander) {
    pinMode(_axisAnalogPin, INPUT);
  }
}

void InputAxis::update() {
  int tmp;
  if(!_expander) {
    tmp = analogRead(_axisAnalogPin);
  } else {
    tmp = _expander->analogRead(_axisAnalogPin);
  }
//    Serial.println(tmp);
//    Serial.print("\t");
  tmp = tmp - _inValCenter; // center on 0
  isForward = tmp >= 0;
  tmp = abs(tmp);
  tmp = max(0, tmp - _inValDeadzone); // apply deadzone
  outVal = tmp <= 0 ? 0 : 
    map(tmp, 1, isForward ? _inMapInRangeFwd : _inMapInRangeRev, _outValMin, _outValMax);
}