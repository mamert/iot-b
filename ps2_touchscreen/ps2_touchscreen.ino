#include <ps2.h>

PS2 mouse(A2, A3);
#include <Mouse.h>
//#include <AltSoftSerial.h>

char mstat1;
char mstat2;
char mxy;
char mx;
char my;
char mz;


unsigned int cx, cy;

//AltSoftSerial altSerial;


void kaoss_init()
{
  mouse.write(0xff);  // reset
  mouse.read();  // ack byte
  mouse.read();  // blank */
  mouse.read();  // blank */
  mouse.write(0xf0);  // remote mode
  mouse.read();  // ack
  /* // advanced settings
  delayMicroseconds(10);
  mouse.write(0xe8);
  mouse.read();  // ack byte
  mouse.write(0x03); // x1  ( x1 * 64  +  x2 * 16  +  x3 * 4  +  x4   == modebyte )
  mouse.read();  // ack byte
  mouse.write(0xe8);
  mouse.read();  // ack byte
  mouse.write(0x00); // x2
  mouse.read();  // ack byte
  mouse.write(0xe8);
  mouse.read();  // ack byte
  mouse.write(0x01); // x3
  mouse.read();  // ack byte
  mouse.write(0xe8);
  mouse.read();  // ack byte
  mouse.write(0x00); // x4
  mouse.read();  // ack byte
  mouse.write(0xf3); // set samplerate 20 (stores mode)
  mouse.read();  // ack byte
  mouse.write(0x14);
  mouse.read();  // ack byte */
  delayMicroseconds(100);
}

void setup()
{
  Serial.begin(115200);
    // altSerial.begin(9600); // TODO: altSerial.begin(38400);
  
  Serial.println("setup 1");
  kaoss_init();
  Serial.println("setup 2");
}


void loop()
{
//  Serial.println("cp1");
  mouse.write(0xeb); // req data
  mouse.read(); // ignore ack

  mstat1 = mouse.read();
  /* advanced
  mxy = mouse.read();
  mz = mouse.read(); // starts detecting even millimeters above surface
  mstat2 = mouse.read();
  */
  mx = mouse.read();
  my = -mouse.read();


//  absolute values
  // collect the bits for x and y
//  cx = (((mstat2 & 0x10) << 8) | ((mxy & 0x0F) << 8) | mx );
//  cy = (((mstat2 & 0x20) << 7) | ((mxy & 0xF0) << 4) | my );
//  Serial.print(cx);
//  Serial.print(" ");
//  Serial.println(cy);
    if(/* mz > 30 && */(mx != 0 || my != 0)){
      Mouse.move(mx, my);
//      altSerial.print("$M 0 ");
//      altSerial.print(mx);
//      altSerial.print(" ");
//      altSerial.print(my);
//      altSerial.print(" 0\n");
    }

  /* advaced
  Serial.print("\tXY=");
  Serial.print(mxy, DEC);
  Serial.print("\tZ=");
  Serial.print(mz, DEC);
  */
//  Serial.print("\tX=");
//  Serial.print(mx, DEC);
//  Serial.print("\tY=");
//  Serial.print(my, DEC);
//  Serial.println();
  delay(10);
}
