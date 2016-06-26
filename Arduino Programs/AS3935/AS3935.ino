 
#include <Wire.h>

void setup() {
  // put your setup code here, to run once:
  byte temp=0;
Wire.begin();
 
  Serial.begin(9600);
  Serial.println("\nLightning sensor");

  Wire.beginTransmission(0x03);
  Wire.write(0x3C);  //PRESET_DEFAULT direct command
  Wire.write(0x96);  
  Wire.endTransmission();

  Wire.beginTransmission(0x03);
  Wire.write(0x08);
  Wire.endTransmission(false);
  Wire.requestFrom(0x03,1,true);
  temp = Wire.read();
  Wire.endTransmission();
  Wire.beginTransmission(0x03);
  Wire.write(0x08);  //Calibration
  Wire.write(temp|0b00001110);  //Tune capacitors
  Wire.endTransmission();
  delay(3);

Wire.beginTransmission(0x03);
Wire.write(0x3D);  //CALIB_RCO direct command
Wire.write(0x96);  
Wire.endTransmission();
delay(3);
  




}

void loop() {
    byte temp=0;
  // put your main code here, to run repeatedly:
  Wire.beginTransmission(0x03);
  Wire.write(0x03);
  Wire.endTransmission(false);
  Wire.requestFrom(0x03,1,true);
  temp = Wire.read();
  Wire.endTransmission();

  delay(5000);
  if (bitRead(temp,0)==1) {
    Serial.println("Noise Level too High");
  }
  if (bitRead(temp,2)==1) {
    Serial.println("Distuberer detected");
  }
  if (bitRead(temp,3)==1) {
     Serial.println("Lightening!!!");

      Wire.beginTransmission(0x03);
      Wire.write(0x07);
      Wire.endTransmission(false);
      Wire.requestFrom(0x03,1,true);
      temp = 0b00111111 & Wire.read();
      Wire.endTransmission();
      Serial.print("Distance:");Serial.print(temp,DEC);Serial.print(" km");
      


  
  }
  
}
