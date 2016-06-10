#include <Wire.h>

#define SECOND1 int((B01110000 & rawtimedata[0])>>4)
#define SECOND2 int(B00001111 & rawtimedata[0])
#define MINUTE1 int((B01110000 & rawtimedata[1])>>4)
#define MINUTE2 int(B00001111 & rawtimedata[1])
#define HOUR1 int((B00010000 & rawtimedata[2])>>4)
#define HOUR2 int(B00001111 & rawtimedata[2])
#define AMPM int((B00100000 & rawtimedata[2])>>5)

#define ALARMMINUTE1 int((B01110000 & rawtimedata[8])>>4)
#define ALARMMINUTE2 int(B00001111 & rawtimedata[8])
#define ALARMHOUR1 int((B00010000 & rawtimedata[9])>>4)
#define ALARMHOUR2 int(B00001111 & rawtimedata[9])
#define ALARMAMPM int((B100000 & rawtimedata[9])>>5)
#define ALARMSTATUS int(B1 & rawtimedata[14])

byte rawtimedata[18];

void setup() {
    digitalWrite(2,LOW);
  Serial.begin(9600);
    pinMode(2,OUTPUT);
    pinMode(12,INPUT);
      Wire.begin();
      rawtimedata[7]=B00000000;   //configure alarm to go off on secs/min/hour
  rawtimedata[8]=B01000000; //Set bit 7 to 0
  rawtimedata[9]=B01000000; //Set bit 7 to 0 and bit 6 to 1 
  rawtimedata[10]=B10000000; // Set bit 7 so alarm goes off on secs/min/hour
  rawtimedata[14]=B00001000;  // Disable alarm
  rawtimedata[15]=B10000000;  // Reset Alarm1 flag
  
  updateRTCalarm();
  digitalWrite(2,LOW);
  delay(5000);
  
}
  
  void loop() {
// digitalWrite(2,LOW);
 delay(200);
 digitalWrite(2,HIGH) ;//Serial.println("HIGH");
 delay(200);
  //delay(1000);
  //digitalWrite(2,LOW);
  
//Serial.println("LOW");
//delay(5000);
/*
 Wire.beginTransmission(0x68);
  Wire.send(14);
  Wire.endTransmission();
  Wire.requestFrom(0x68,1);
  Serial.println(Wire.receive(),BIN);
*/
} 
  
  void updateRTCalarm() {
   // setting up alarm defaults

   Wire.beginTransmission(0x68);
   Wire.send(7);  //Send alarm time
   Wire.send(rawtimedata[7]);
   Wire.send(rawtimedata[8]);
   Wire.send(rawtimedata[9]);
   Wire.send(rawtimedata[10]);
   Wire.endTransmission();
   Wire.beginTransmission(0x68);
   Wire.send(14);  //send alarm
   Wire.send(rawtimedata[14]);
   Wire.send(rawtimedata[15]);
   Wire.endTransmission();
   Serial.println("RTC Alarm has been updated");
   
     // EEPROM.write(8,rawtimedata[8]);
    //  EEPROM.write(9,rawtimedata[9]);
   //   EEPROM.write(10,rawtimedata[10]);
    //  Serial.println("New alarm time saved to EEPROM");
   
 }
