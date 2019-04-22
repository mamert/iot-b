#ifndef L298N_h
#define L298N_h
#include "Arduino.h"
#include "InputAxis.h"

/*
 * Motor driver.
 * in: direction & PWM
 */
class L298N {

  public:
    L298N(int directionPinA, int directionPinB, int enablePin,
  InputAxis *inputAxis);

    void update();
    
  private:
    int _directionPinA;
    int _directionPinB;
    int _enablePin; // pwm
    InputAxis *_inputAxis;
};

#endif
