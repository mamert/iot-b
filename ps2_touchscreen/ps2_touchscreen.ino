#include <ps2.h>
#include <Mouse.h>
#include <Keyboard.h>
//#include <AltSoftSerial.h>

PS2 touchpad(A2, A3);

byte mstat1;
byte mstat2;
byte mxy;
byte mx;
byte my;
byte mz;

#define TOUCH_X_MIN 960
#define TOUCH_X_MAX 5971
#define TOUCH_Y_MIN 522
#define TOUCH_Y_MAX 5370
#define PAD_MAPPED_RANGE 255

// drew button symbols on it: L/R Mouse; Space & Enter; Ctrl+C & Up & Ctrl+V; Left & Down & Right
// These help know where we pressed
unsigned int pad_1_4 = PAD_MAPPED_RANGE >> 2;
unsigned int pad_1_2 = PAD_MAPPED_RANGE >> 1;
unsigned int pad_3_4 = PAD_MAPPED_RANGE - pad_1_4;
unsigned int pad_1_3 = PAD_MAPPED_RANGE / 3;
unsigned int pad_2_3 = PAD_MAPPED_RANGE * 2 / 3;


unsigned int cx, cy;

char pressedKey = 0;
char pressedMouse = 0;

//AltSoftSerial altSerial;


void kaoss_init()
{
  touchpad.write(0xff);  // reset
  touchpad.read();  // ack byte
  touchpad.read();  // blank */
  touchpad.read();  // blank */
  touchpad.write(0xf0);  // remote mode
  touchpad.read();  // ack
  // advanced settings
  touchpad.write(0xe8);
  touchpad.read();  // ack byte
  touchpad.write(0x03); // x1  ( x1 * 64  +  x2 * 16  +  x3 * 4  +  x4   == modebyte )
  touchpad.read();  // ack byte
  touchpad.write(0xe8);
  touchpad.read();  // ack byte
  touchpad.write(0x00); // x2
  touchpad.read();  // ack byte
  touchpad.write(0xe8);
  touchpad.read();  // ack byte
  touchpad.write(0x01); // x3
  touchpad.read();  // ack byte
  touchpad.write(0xe8);
  touchpad.read();  // ack byte
  touchpad.write(0x00); // x4
  touchpad.read();  // ack byte
  touchpad.write(0xf3); // set samplerate 20 (stores mode)
  touchpad.read();  // ack byte
  touchpad.write(0x14);
  touchpad.read();  // ack byte
  delayMicroseconds(100);
}

void setup()
{
  Serial.begin(115200);
    // altSerial.begin(9600); // TODO: altSerial.begin(38400);
  Keyboard.begin();
  Mouse.begin();
  kaoss_init();
}


void process_release() {
  Mouse.release(MOUSE_ALL);
  Keyboard.releaseAll();
  pressedKey = 0;
  pressedMouse = 0;
}

void process_press(unsigned int x, unsigned int y) {
  // select buttons
  bool useCtrlMod = false;
  if(x >= pad_1_2) { // "top" buttons
    if(x >= pad_3_4) // mouse btns
      pressedMouse = (y > pad_1_2) ? MOUSE_LEFT : MOUSE_RIGHT;
    else // "space/enter"
      pressedKey = (y >= pad_1_2) ? ' ' : KEY_RETURN;
  } else { // "bottom"
    if(y >= pad_2_3){ // copy/left
      if(x >= pad_1_4) {
        useCtrlMod = true;
        pressedKey = 'c';
      } else {
        pressedKey = KEY_LEFT_ARROW;
      }
    } else if(y >= pad_1_3) { // up/down
      pressedKey = (x >= pad_1_4) ? KEY_UP_ARROW : KEY_DOWN_ARROW;
    } else { // paste/right
      if(x >= pad_1_4) {
        useCtrlMod = true;
        pressedKey = 'v';
      } else {
        pressedKey = KEY_RIGHT_ARROW;
      }
    }
  }
  // press them
  if(useCtrlMod)
    Keyboard.press(KEY_LEFT_CTRL);
  if(pressedMouse != 0)
    Mouse.press(pressedMouse);
  if(pressedKey != 0)
    Keyboard.press(pressedKey);
}

void loop()
{
  touchpad.write(0xeb); // req data
  touchpad.read(); // ignore ack

  mstat1 = touchpad.read();
  mxy = touchpad.read();
  mz = touchpad.read(); // starts detecting even millimeters above surface
  mstat2 = touchpad.read();
  mx = touchpad.read();
  my = -touchpad.read();


  if( mz > 30 && (mx != 0 || my != 0)){ // pressed
    Serial.print("pressed \t");
    if(pressedKey == 0) { // not yet pressed 
      // calc absolute values
      cx = (((mstat2 & 0x10) << 8) | ((mxy & 0x0F) << 8) | mx );
      cy = (((mstat2 & 0x20) << 7) | ((mxy & 0xF0) << 4) | my );
  //    // "raw" values for calibration
  //    Serial.print(cx);
  //    Serial.print("\t");
  //    Serial.print(cy);
  //    Serial.print("\t");
      cx = map(cx, TOUCH_X_MIN, TOUCH_X_MAX, 0, 255);
      cy = map(cy, TOUCH_Y_MIN, TOUCH_Y_MAX, 0, 255); // rectangular, but who cares; input ranges are square
  //    Serial.print(cx);
  //    Serial.print("\t");
  //    Serial.println(cy);
      process_press(cx, cy);
    }
  } else { // released
    Serial.print("released \t");
    if(pressedKey != 0 || pressedMouse != 0) {
      process_release();
    }
  }
  Serial.print(pressedKey, DEC);
  Serial.print("\t");
  Serial.println(pressedMouse, DEC);
  delay(100);
}
