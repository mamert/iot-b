#include "Arduino.h"
#include "InputAxis.h"

#include <Arduino_I2C_Port_Expander.h>

InputAxis::InputAxis(int axisAnalogPin,
      long inValMin, long inValCenter, long inValMax, long inValDeadzone,
      long outValMin, long outValMax) : InputAxis::InputAxis(axisAnalogPin,
      inValMin, inValCenter, inValMax, inValDeadzone,
      outValMin, outValMax, NULL, NULL){}

InputAxis::InputAxis(
      long inValMin, long inValCenter, long inValMax, long inValDeadzone,
      long outValMin, long outValMax, InputSource *inputSource) : InputAxis::InputAxis(-1,
      inValMin, inValCenter, inValMax, inValDeadzone,
      outValMin, outValMax, NULL, inputSource){}

InputAxis::InputAxis(int axisAnalogPin, // Great FSM but this has gotten ugly TODO: refactor
      long inValMin, long inValCenter, long inValMax, long inValDeadzone,
      long outValMin, long outValMax, EXPAND *expander, InputSource *inputSource) :
  _axisAnalogPin(axisAnalogPin),
  _inValMin(inValMin),
  _inValCenter(inValCenter),
  _inValMax(inValMax),
  _inValDeadzone(inValDeadzone),
  _outValMin(outValMin),
  _outValMax(outValMax),
  _inputSource(inputSource),
  _expander(expander) {
  _inMapInRangeRev = _inValCenter - inValMin - _inValDeadzone;
  _inMapInRangeFwd = inValMax - _inValCenter - _inValDeadzone;
  if(_inputSource) {
    _inputSource->setup();
  } else if(!_expander) {
    pinMode(_axisAnalogPin, INPUT);
  }
}

InputAxis& InputAxis::curve(boolean value) {
  _curve = value;
  return *this;
}

long InputAxis::_curve_it(long val, long limit) {
  unsigned long tmp = (((unsigned long)val) << 10) / limit; // unsigned long, 0-1 * 1024
  return (long)((tmp*val) >> 10); // square & divide. *val is equal to *tmp*limit
}

void InputAxis::update() {
  long tmp;
  if(_expander) {
    tmp = _expander->analogRead(_axisAnalogPin);
  } else if(_inputSource) {
    tmp = _inputSource->get();
  } else {
    tmp = analogRead(_axisAnalogPin);
  }
  Serial.print("tmp=");
  Serial.println(tmp);
  tmp = max(tmp, _inValMin);
  tmp = min(tmp, _inValMax);
  tmp = tmp - _inValCenter; // center on 0
  isForward = tmp >= 0;
  tmp = abs(tmp);
  tmp = max(0, tmp - _inValDeadzone); // apply deadzone
  if(_curve) {
    tmp = _curve_it(tmp, isForward ? _inMapInRangeFwd : _inMapInRangeRev);
  }
  outVal = tmp <= 0 ? 0 : 
    map(tmp, 1, isForward ? _inMapInRangeFwd : _inMapInRangeRev, _outValMin, _outValMax);
  Serial.print("outVal=");
  Serial.println(outVal);
}
