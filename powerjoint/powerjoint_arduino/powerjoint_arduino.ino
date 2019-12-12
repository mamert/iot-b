#include "InputAxis.h"
#include "InputSource.h"
#include "BTS7960.h"
// BTS7960 motor driver
int outCLPwmPin = 10;
int outCRPwmPin = 11;
int inHX711DataPin = 12;
int inHX711ClkPin = 13;

// hardware calibration
const long val_deadzoneRadius = 150000l;
const long val_noLoad = 195046l;
const long val_max = 1802393l;
const long val_radius = (val_max - val_noLoad) >> 1;
const long val_desiredPressure = val_noLoad + val_radius;
const int minPwm = 22;
const int maxPwm = 230; // never full duty, leave some to power the buck regulator

BTS7960 *ax1;
InputSource *source;

void setup() {
  Serial.begin(115200);
  // change PWM frequency: timer0: pins 5 & 6;
  // why do it? No high-pitched noise, better torque @ low duty
  // WARNING! Also affects TIME (millis(), and delay()).
  TCCR0B = (TCCR0B & 0b11111000) | 0x04;
  // 0x01, prescaler 1,		62500Hz
  // 0x02, prescaler 8,		7812.5Hz
  // 0x03, prescaler 64,	976.5625Hz; default
  // 0x04, prescaler 256,	244.140625Hz
  // 0x05, prescaler 1024,	61.03515625Hz


  source = new HX711InputSource(inHX711DataPin, inHX711ClkPin);
  ax1 = new BTS7960(outCLPwmPin, outCRPwmPin,
      &((new InputAxis(val_noLoad, val_desiredPressure, val_max, val_deadzoneRadius, minPwm, maxPwm, source))->curve(true)));

}

void loop() {
  ax1->update();
  delay(1); // see timer0 prescaler change in setup()
}
