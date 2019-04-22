// Arduino pin assignments:
// Joystick
int ax1Pin = A0;
int ax2Pin = A1;
int trigPin = 13;
// motor driver
int outA1Pin = 2;
int outA2Pin = 4;
int outAEnPin = 6;
int outB1Pin = 8;
int outB2Pin = 7;
int outBEnPin = 5;

// also available for later use on arm thing: GPIO10(PWM), 11(PWM), 12 as green, white & yellow cable

// joystick input values
int ax1Val = 0;
int ax2Val = 0;
int trigVal = 0;

// hardware calibration
int threshold = 80;
// wrist thing
//int centerA = 480;
//int centerB = 530;
// turret
int centerA = 509;
int centerB = 523;

// for map(): where the mapping starts
int inMapInRangeAL = centerA-threshold;
int inMapInRangeAR = 1023-centerA-threshold;
int inMapInRangeBL = centerB-threshold;
int inMapInRangeBR = 1023-centerB-threshold;


void setup() {
  Serial.begin(115200);
  pinMode(ax1Pin, INPUT);
  pinMode(ax2Pin, INPUT);
  pinMode(trigPin, INPUT_PULLUP); // needs external pullup, actually
  pinMode(outA1Pin, OUTPUT);
  pinMode(outA2Pin, OUTPUT);
  pinMode(outAEnPin, OUTPUT);
  pinMode(outB1Pin, OUTPUT);
  pinMode(outB2Pin, OUTPUT);
  pinMode(outBEnPin, OUTPUT);
}

void loop() {
  ax1Val = analogRead(ax1Pin);
  ax2Val = analogRead(ax2Pin);
  trigVal = digitalRead(trigPin);
  
  Serial.print(ax1Val);
  Serial.print("\t");
  Serial.print(ax2Val);
  Serial.print("\t");
  Serial.println(trigVal);
  
//  delay(100);
  delay(30);
  moveA(ax1Val);
  moveB(ax2Val);
}


void moveA(int val) {
  move(outA1Pin, outA2Pin, outAEnPin, centerA, inMapInRangeAL, inMapInRangeAR, val);
}

void moveB(int val) {
  move(outB1Pin, outB2Pin, outBEnPin, centerB, inMapInRangeBL, inMapInRangeBR, val);
}

void move(int pin1, int pin2, int pwmPin, int center, int inMapInRangeL, int inMapInRangeR, int val) {
  int tmp = val - center;
  bool isRight = tmp >= 0;
  int absVal = abs(tmp);
  absVal = max(0, absVal-threshold);
  
  analogWrite(pwmPin, map(absVal, 0, isRight ? inMapInRangeR : inMapInRangeL, 80, 255));
  
  digitalWrite(pin1, isRight ? LOW : (absVal>0 ? HIGH : LOW));
  digitalWrite(pin2, isRight ? (absVal>0 ? HIGH : LOW) : LOW);  
}
