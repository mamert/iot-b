#ifndef InputAxis_h
#define InputAxis_h
#include "Arduino.h"
#include "HX711.h"
#include "InputSource.h"

#include <Arduino_I2C_Port_Expander.h>

/*
 * distance sensor or joystick.
 * in: analog pin & calibration data
 * out: direction and PWM magnitude
 */
class InputAxis {

  public:
    boolean isForward = true;
    long outVal = 0;

    InputAxis(int axisAnalogPin,
          long inValMin, long inValCenter, long inValMax, long inValDeadzone,
          long outValMin, long outValMax);
          
    InputAxis::InputAxis(
          long inValMin, long inValCenter, long inValMax, long inValDeadzone,
          long outValMin, long outValMax, InputSource *inputSource);
      
    InputAxis(int axisAnalogPin,
          long inValMin, long inValCenter, long inValMax, long inValDeadzone,
          long outValMin, long outValMax, EXPAND *expander, InputSource *inputSource);

    InputAxis& curve(boolean value);
    
    void update();
    
  private:
    int  _axisAnalogPin;
    long _inValMin;
    long _inValCenter;
    long _inValMax;
    long _inValDeadzone;
    long _outValMin;
    long _outValMax;
    EXPAND *_expander;
    InputSource *_inputSource;
    // for map(): where the mapping starts
    long _inMapInRangeRev;
    long _inMapInRangeFwd;
    boolean _curve;
    
    long _curve_it(long val, long limit);
};

#endif
