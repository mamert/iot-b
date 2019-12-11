#include "HX711.h"
#include "InputSource.h"



HX711InputSource::HX711InputSource(int dataPin, int clkPin){
      _dataPin = dataPin;
      _clkPin = clkPin;
}
long HX711InputSource::get() { 
    return _scale.read(); 
}
void HX711InputSource::setup(){
    _scale.begin(_dataPin, _clkPin);
}
void HX711InputSource::finish(){
    _scale.power_down();
}
