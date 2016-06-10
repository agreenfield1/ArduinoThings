#include <Wire.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>

   int brightness=0;
void setup() {
  Serial.begin(9600);
pinMode(13,OUTPUT);
     pinMode(3,OUTPUT);
     pinMode(A2,INPUT);

     digitalWrite(13,HIGH);
     
   }

void loop() {
  brightness=analogRead(A2)/4;
   analogWrite(3,brightness);
//   delay(100);
// for(int i=0;i<266;i++) {
//    analogWrite(3,i);
//   delay(1000);
  //}





}
