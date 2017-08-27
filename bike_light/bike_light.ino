#include "LowPower.h"
#include "LedControl.h"

#include "shapes.h"

int dataPin = 12;
int clkPin = 11;
int csPin = 10;
LedControl lc=LedControl(dataPin, clkPin, csPin, 1);

//unsigned long refreshRate=100;

////////////////////

void drawShape(byte shape[]){
  for(int i=0; i<8; i++){
    lc.setRow(0,i,shape[i]);
  }
}

////////////////////

void setup() {
  lc.shutdown(0,false); // wakeup?
  lc.clearDisplay(0);
  lc.setIntensity(0,1); // up to 15
  drawShape(shapeEvilOtto);
}


void loop() {
  LowPower.powerDown(SLEEP_FOREVER, ADC_OFF, BOD_OFF);
}
