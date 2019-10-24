#include "LedControl.h"

#include "shapes.h"

int dataPin = 12;
int clkPin = 11;
int csPin = 10;
LedControl lc=LedControl(dataPin, clkPin, csPin, 1);

int hshift = 0;

unsigned long interval=40;

////////////////////

void drawShape(byte shape[]){
  int hshift1 = hshift-7;
  for(int i=0; i<8; i = i+1){
    byte row = 0;
    if(hshift1+i >= 0 && hshift1+i <= 7)
      row = shape[hshift1+i];
//    row = shape[i];
    lc.setRow(0,i,row);
  }
}

////////////////////

void setup() {
  lc.shutdown(0,false); // wakeup?
  lc.clearDisplay(0);
  lc.setIntensity(0,1); // up to 15
}

void drawFrame(byte shape[]) {
  drawShape(shape);
  delay(interval);
}

void loop() {
  drawFrame(Pacman1);
  drawFrame(Pacman2);
  drawFrame(Pacman3);
  drawFrame(Pacman4);
  drawFrame(Pacman3);
  drawFrame(Pacman2);
  hshift = hshift+1;
  hshift = hshift % 15;
}
