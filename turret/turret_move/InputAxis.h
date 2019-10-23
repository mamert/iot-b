#ifndef InputAxis_h
#define InputAxis_h
#include "Arduino.h"

#include <Arduino_I2C_Port_Expander.h>

/*
 * distance sensor or joystick.
 * in: analog pin & calibration data
 * out: direction and PWM magnitude
 */
class InputAxis {

  public:
    boolean isForward = true;
    int outVal = 0;

    InputAxis(int axisAnalogPin,
          int inValMin, int inValCenter, int inValMax, int inValDeadzone,
          int outValMin, int outValMax);

    InputAxis(int axisAnalogPin,
          int inValMin, int inValCenter, int inValMax, int inValDeadzone,
          int outValMin, int outValMax, EXPAND *expander);

    InputAxis& curve(boolean value);
    
    void update();
    
  private:
    int _axisAnalogPin;
    int _inValMin;
    int _inValCenter;
    int _inValMax;
    int _inValDeadzone;
    int _outValMin;
    int _outValMax;
    EXPAND *_expander;
    // for map(): where the mapping starts
    int _inMapInRangeRev;
    int _inMapInRangeFwd;
    boolean _curve;
    
    int _curve_it(int val, int limit);
};

#endif
