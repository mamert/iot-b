#ifndef InputSource_h
#define InputSource_h

#include "HX711.h"

class InputSource {
    public:
        virtual long get() = 0;
        virtual void setup() = 0;
        virtual void finish() = 0;
};

 

class HX711InputSource: public InputSource {
    public:
        HX711InputSource(int dataPin, int clkPin);
        long get();
        void setup();
        void finish();

    protected:
        int _dataPin, _clkPin;
        HX711 _scale;
};

#endif
