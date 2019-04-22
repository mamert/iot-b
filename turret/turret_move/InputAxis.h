#ifndef InputAxis_h
#define InputAxis_h
#include "Arduino.h"

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

    void update();
    
  private:
    int _axisAnalogPin;
    int _inValMin;
    int _inValCenter;
    int _inValMax;
    int _inValDeadzone;
    int _outValMin;
    int _outValMax;
    // for map(): where the mapping starts
    int _inMapInRangeRev;
    int _inMapInRangeFwd;
};

#endif
