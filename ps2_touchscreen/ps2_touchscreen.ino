#include <ps2.h>

PS2 mouse(A2, A3);
unsigned int maxx, minx, maxy, miny, maxz, minz;

byte mstat1;
byte mstat2;
byte mxy;
byte mx;
byte my;
byte mz;


unsigned int cx, cy;



void kaoss_init()
{
  mouse.write(0xff);  // reset
  mouse.read();  // ack byte
  mouse.read();  // blank */
  mouse.read();  // blank */
  mouse.write(0xf0);  // remote mode
  mouse.read();  // ack
  delayMicroseconds(100);
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
  mouse.read();  // ack byte
  delayMicroseconds(100);
}

void setup()
{
  Serial.begin(115200);
  
  Serial.println("setup 1");
  kaoss_init();
  Serial.println("setup 2");
}


void loop()
{
//  Serial.println("cp1");
  mouse.write(0xeb);
  mouse.read();

  mstat1 = mouse.read();
  mxy = mouse.read();
  mz = mouse.read();
  mstat2 = mouse.read();
  mx = mouse.read();
  my = mouse.read();


//  Serial.println("cp2");
  // collect the bits for x and y
  cx = (((mstat2 & 0x10) << 8) | ((mxy & 0x0F) << 8) | mx );
  cy = (((mstat2 & 0x20) << 7) | ((mxy & 0xF0) << 4) | my );

  
  Serial.print(cx);
  Serial.print(" ");
  Serial.println(cy);
//  Serial.println();
  delay(60);
//  delay(20);
}
