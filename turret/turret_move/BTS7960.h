#ifndef BTS7960_h
#define BTS7960_h
#include "Arduino.h"
#include "InputAxis.h"

/*
 * Motor driver.
 * in: direction & PWM
 */
class BTS7960 {

  public:
    BTS7960(int enLPin, int pwmLPin, int enRPin, int pwmRPin,
  InputAxis *inputAxis);
    BTS7960(int pwmLPin, int pwmRPin,
  InputAxis *inputAxis); // pull up both EN pins

    void update();
    
  private:
    int _enLPin;
    int _pwmLPin;
    int _enRPin;
    int _pwmRPin;
    InputAxis *_inputAxis;
};

#endif
