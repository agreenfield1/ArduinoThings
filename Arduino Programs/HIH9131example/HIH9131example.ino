#include <Wire.h>

void setup() {
  Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(9600);  // start serial for output
}

void loop() {
  Wire.beginTransmission(39);
  //delay(500);
   Wire.endTransmission(); 
   delay(30);
  Wire.requestFrom(39, 4);    // request 6 bytes from slave device #8
  Serial.println("checking..");  
  while (Wire.available()) { // slave may send less than requested
    byte a = Wire.read(); // receive a byte as character
    byte b = Wire.read();
    byte c = Wire.read();
    byte d = Wire.read();
    int bintemp = (unsigned int)c<<6|(unsigned int)d>>2;
    int binhumidity = (a&B00111111)<<8|(unsigned int)b;
    //(unsigned int)a<<6|(unsigned int)d>>2
    //int bintemp = (word((unsigned int)c >> 2,(unsigned int)d >> 2));
    int f = (((bintemp/(pow(2,14)-2))*165-40)*1.8+32)*100;
    int humidity = binhumidity/(pow(2,14)-2)*1000;
   // Serial.print("c & d: "); Serial.print(c,BIN);  Serial.print(" "); Serial.println(d,BIN);
   // Serial.print("bitshifted: "); Serial.print((unsigned int)c<<6,BIN); Serial.print(" "); Serial.println((unsigned int)d>>2,BIN);
   // Serial.print("combined: "); Serial.println(bintemp,BIN);
    Serial.println(f);  
    Serial.println(humidity);
    Serial.println(a,BIN);
    //Serial.println();// print the character
  }

  Serial.println();
  delay(5000);
}
