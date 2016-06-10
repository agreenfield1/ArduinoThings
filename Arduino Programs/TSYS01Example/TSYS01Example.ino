#include <Wire.h>
unsigned int k1;
unsigned int k2;
unsigned int k3;
unsigned int k4;
unsigned int k0;




void setup() {
  Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(9600);  // start serial for output

      Wire.beginTransmission(119);
  Wire.write(0x1E);  //RESET
   Wire.endTransmission(); 
delay(300);

  Wire.beginTransmission(119);
  Wire.write(0xA2);  //READ PROM
   Wire.endTransmission(); 

   Wire.requestFrom(119,2);
  while (Wire.available()) {
   byte a = Wire.read();
   byte b = Wire.read();
   k4 = (((unsigned int)a<<8)|(unsigned int)b);
  }

  Wire.beginTransmission(119);
  Wire.write(0xA4);  //READ PROM
   Wire.endTransmission(); 

   Wire.requestFrom(119,2);
  while (Wire.available()) {
   byte a = Wire.read();
   byte b = Wire.read();
   k3 = (((unsigned int)a<<8)|(unsigned int)b);
  }

    Wire.beginTransmission(119);
  Wire.write(0xA6);  //READ PROM
   Wire.endTransmission(); 

   Wire.requestFrom(119,2);
  while (Wire.available()) {
   byte a = Wire.read();
   byte b = Wire.read();
   k2 = (((unsigned int)a<<8)|(unsigned int)b);
  }

    Wire.beginTransmission(119);
  Wire.write(0xA8);  //READ PROM
   Wire.endTransmission(); 

   Wire.requestFrom(119,2);
  while (Wire.available()) {
   byte a = Wire.read();
   byte b = Wire.read();
   k1 = (((unsigned int)a<<8)|(unsigned int)b);
  }


       Wire.beginTransmission(119);
  Wire.write(0xAA);  //READ PROM
   Wire.endTransmission(); 

   Wire.requestFrom(119,2);
  while (Wire.available()) {
   byte a = Wire.read();
   byte b = Wire.read();
   k0 = (((unsigned int)a<<8)|(unsigned int)b);
  }
   



     
}

void loop() {
  byte a;
  byte b;
  byte c;


  Wire.beginTransmission(119);
  Wire.write(0x48);
   Wire.endTransmission(); 

     delay(300);
     Wire.beginTransmission(119);
  Wire.write(0x00);
   Wire.endTransmission(); 
      delay(300);
  Wire.requestFrom(119, 3);    // request 6 bytes from slave device #8

  while (Wire.available()) { // slave may send less than requested
    a = Wire.read(); // receive a byte as character
    b = Wire.read();
    c = Wire.read();
    //byte bintemp = (unsigned int)c<<6|(unsigned int)d>>2;
   // byte binhumidity = (a&B00111111)<<8|(unsigned int)b;
    //(unsigned int)a<<6|(unsigned int)d>>2
    //byte bintemp = (word((unsigned int)c >> 2,(unsigned int)d >> 2));
    //int f = (((bintemp/(pow(2,14)-2))*165-40)*1.8+32)*100;
    //int humidity = binhumidity/(pow(2,14)-2)*1000;
   // Serial.print("c & d: "); Serial.print(c,BIN);  Serial.print(" "); Serial.println(d,BIN);
   // Serial.print("bitshifted: "); Serial.print((unsigned int)c<<6,BIN); Serial.print(" "); Serial.println((unsigned int)d>>2,BIN);
   // Serial.print("combined: "); Serial.println(bintemp,BIN);
    //Serial.println(f);  
    //Serial.println(humidity);

    //Serial.println();// print the character
 }
 //long adc24 = (((unsigned int)a<<8|(unsigned int)b)<<8|(unsigned int)c);
 long adc24 = (((unsigned long)a<<8|(unsigned long)b)<<8|(unsigned long)c);
 long adc16 = adc24 / 256;
 float tempc =  ((-2)*  (long long)k4*pow(10,-21)* pow(adc16,4)) + 
                (4*     (long long)k3*pow(10,-16)* pow(adc16,3)) + 
                ((-2)*  (long long)k2*pow(10,-11)* pow(adc16,2)) + 
                (1*     (long long)k1*pow(10,-6)*  adc16) + 
                ((-1.5)*(long long)k0*pow(10,-2));
  Serial.println(tempc);
  Serial.println(adc24);
  
    Serial.println(k4);
        Serial.println(k3);
            Serial.println(k2);
                Serial.println(k1);
Serial.println(k0);
  Serial.println();

  delay(5000);
}
