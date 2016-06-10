/*
Circuit description
Pin13: Switch on high power circuit
Pin 12: Button (Output)
Pin 11: LED status light (Output)
Pin 10: Alarm trigger (Input)
Pin 9-4:LCD (ybggpy)
Analog 4: RTC pin 5 (blue)
Analog 5: RTC pin 6 (yellow)
:


*/

#include <Wire.h>
#include <LiquidCrystal.h>
#include <Time.h>
#include <EEPROM.h>

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


LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

byte rawtimedata[15];
byte old_val=0;
unsigned long timea=0;
unsigned long alarmdelay=0;


void setup() {
  Serial.begin(9600);
  pinMode(10, INPUT);
  pinMode(11,OUTPUT);
  pinMode(12,INPUT);
  Wire.begin();
    
  lcd.begin(16,2); 
  rawtimedata[8] = EEPROM.read(8);
  rawtimedata[9] = EEPROM.read(9);
  rawtimedata[10] = EEPROM.read(10);
  updateRTCalarm();  //send alarm setting to RTC
  updateArduino();
  digitalWrite(13,LOW);
  
  if (rawtimedata[1]==B00000000&&rawtimedata[2]==B00000000) {
      rawtimedata[1] = EEPROM.read(1);
      rawtimedata[2] = EEPROM.read(2);
      Serial.println("Loaded time from EEPROM");
      updateRTCtime(); 
  } else {
      Serial.println("Time already loaded (warm reboot I guess)");
  }
    Wire.beginTransmission(0x53);
  Wire.send(0x2D);
  Wire.send(B00001000);
  Wire.endTransmission();
  
  Wire.beginTransmission(0x53);
  Wire.send(0x31);
  Wire.send(B00000000);
  Wire.endTransmission(); 
     
      Wire.beginTransmission(0x53);
  Wire.send(0x24);
  Wire.send(B00010110);  //Threshold
  Wire.endTransmission();    
     
         Wire.beginTransmission(0x53);
  Wire.send(0x27);
  Wire.send(B01110000);  //Axes activate
  Wire.endTransmission();   
     
     Wire.beginTransmission(0x53);
  Wire.send(0x2F);
  Wire.send(B00000000);  //Interupt Map
  Wire.endTransmission();    
   
       Wire.beginTransmission(0x53);
  Wire.send(0x2E);
  Wire.send(B00010000);  //Interupt enable
  Wire.endTransmission();     
}



void loop() {


  if ((millis()-timea)>1000)  {
    updateArduino();
    displayTime();
    displayAlarmTime();
    timea=millis();
  }
  
  if(digitalRead(10)==LOW&&(millis()>alarmdelay))  
    triggerAlarm();  
    
  byte buttonStatus = detectButton();
  if (buttonStatus == 1) { //Short press, flip alarm
    rawtimedata[14]=B00011100 | (1-ALARMSTATUS);
    digitalWrite(11,ALARMSTATUS);
    updateRTCalarm();
  }
  if (buttonStatus==2) 
    adjustAlarm();  //Long press, adujust alarm
}
 
 
void triggerAlarm() {
  
  Wire.beginTransmission(0x53);  //Reset activity detection interupt flag
  Wire.send(0x30);
  Wire.endTransmission();
  Wire.requestFrom(0x53,1);
  //if((B01000000&&>>6)==1);
  Wire.receive();
  
  Serial.println("Alarm has been triggered");
  while(digitalRead(10)==LOW) {
    digitalWrite(13,HIGH);
    lcd.setCursor(9,0);
    lcd.print("ALARM");
    delay(500);
    
    Wire.beginTransmission(0x53);  /Check activity detection interupt flag
    Wire.send(0x30);
    Wire.endTransmission();
    Wire.requestFrom(0x53,1);
    if((B01000000&Wire.receive()>>4)==1) {
      Serial.println("Activity dectected, delaying alarm);
      alarmdelay=millis()+60000;
      digitalWrite(13,LOW);
      lcd.setCursor(9,0);
      lcd.print("     ");
      return();
    
    }
  
    
  }
  alarmdelay=0;
}  
 
 
int detectButton() {
   int val = digitalRead(12);
   unsigned long startTime=0;
   unsigned long pressedTime=0;
   
   if ((val==HIGH) && (old_val==LOW)) {
     delay(50);
     startTime=millis();
     do {
       pressedTime=millis();
     } while (digitalRead(12)==HIGH && (pressedTime-startTime)<3000);
   }
   
   if ((pressedTime-startTime)<1000 && pressedTime !=0) {
     Serial.println("Short press registered");  
     old_val=val;
     return 1;
   } 
   
   if ((pressedTime-startTime)>=3000 && pressedTime !=0) {     
       Serial.println("Long press registered:  ");     
       old_val=val;
       return 2;
   }
old_val=val;
return 0;
}


 
  
void adjustAlarm()  {
      byte ADXLdata[2];
      int ADXLangle=0;
     // Serial.println(numb);
      digitalWrite(13, HIGH); 
      while(digitalRead(12)==HIGH) {} //wait for button release
      delay(50); //debounce time
      
          lcd.setCursor(14,0);
          lcd.print("<-");
      while(digitalRead(12)==LOW) { //Adjusting alarm

        Wire.beginTransmission(0x53);
        Wire.send(0x32); 
        Wire.endTransmission();
        Wire.requestFrom(0x53,2);
        ADXLdata[0]=Wire.receive();
        ADXLdata[1]=Wire.receive();
        ADXLangle=ADXLdata[1]<<8|ADXLdata[0];
       
        //Serial.print("The angle is:  ");Serial.println(ADXLangle);
        
        if (ADXLangle > 20)
          incrementAlarm();
        if (ADXLangle < -20)
          decrementAlarm();
        if ((ADXLangle>250)||(ADXLangle<-250)) {
           // No delay           
         } else {
           delay(250-abs(ADXLangle));
         }
      }
      
      delay(50); //debounce time; button was pressed
          lcd.setCursor(14,0);
          lcd.print("  ");
          lcd.setCursor(14,1);
          lcd.print("<-");
          
      while(digitalRead(12)==HIGH) {
       Wire.beginTransmission(0x53);
        Wire.send(0x32);
        Wire.endTransmission();
        Wire.requestFrom(0x53,2);
        ADXLdata[0]=Wire.receive();
        ADXLdata[1]=Wire.receive();
        ADXLangle=ADXLdata[1]<<8|ADXLdata[0];
        //Serial.print("The angle is:  ");Serial.println(ADXLangle);
        
        if (ADXLangle > 20)
          incrementTime();
        if (ADXLangle < -20)
          decrementTime();
        if ((ADXLangle>250)||(ADXLangle<-250)) {
           // No delay           
         } else {
           delay(250-abs(ADXLangle));
      }
      
      }
      
          lcd.setCursor(14,1);
          lcd.print("  ");
      updateRTCalarm();
      updateRTCtime();
      
      digitalWrite(13, LOW);
}  



  
void incrementAlarm() {
    if (ALARMMINUTE1*10+ALARMMINUTE2<59)  {
       rawtimedata[8]=(ALARMMINUTE1*10+ALARMMINUTE2+1)/10<<4 | (ALARMMINUTE1*10+ALARMMINUTE2+1)%10;
    } else if (ALARMMINUTE1*10+ALARMMINUTE2==59) {
        rawtimedata[8]=B10000000;
        if (ALARMHOUR1*10+ALARMHOUR2<12) {
           rawtimedata[9]=(rawtimedata[9]&B11100000)|((ALARMHOUR1*10+ALARMHOUR2+1)/10<<4 | (ALARMHOUR1*10+ALARMHOUR2+1)%10);
           if ((ALARMHOUR1*10+ALARMHOUR2)==12) {
              rawtimedata[9]=(rawtimedata[9]&B11011111) | ((1-ALARMAMPM)<<5);
           }
         } else if ((ALARMHOUR1*10+ALARMHOUR2)==12) {
           rawtimedata[9]=(rawtimedata[9] & B11100000) | B00000001;
           }
       }
    displayAlarmTime();
}

void incrementTime() {
    if (MINUTE1*10+MINUTE2<59)  {
       rawtimedata[1]=(MINUTE1*10+MINUTE2+1)/10<<4 | (MINUTE1*10+MINUTE2+1)%10;
    } else if (MINUTE1*10+MINUTE2==59) {
        rawtimedata[1]=B10000000;
        if (HOUR1*10+HOUR2<12) {
           rawtimedata[2]=(rawtimedata[2]&B11100000)|((HOUR1*10+HOUR2+1)/10<<4 | (HOUR1*10+HOUR2+1)%10);
           if ((HOUR1*10+HOUR2)==12) {
              rawtimedata[2]=(rawtimedata[2]&B11011111) | ((1-AMPM)<<5);
           }
         } else if ((HOUR1*10+HOUR2)==12) {
           rawtimedata[2]=(rawtimedata[2] & B11100000) | B00000001;
           }
       }
    displayTime();
}
  
void decrementAlarm() {
    if (ALARMMINUTE1*10+ALARMMINUTE2>0)  {
       rawtimedata[8]=(ALARMMINUTE1*10+ALARMMINUTE2-1)/10<<4 | (ALARMMINUTE1*10+ALARMMINUTE2-1)%10;
    } else if (ALARMMINUTE1*10+ALARMMINUTE2==0) {
        rawtimedata[8]=B11011001;
        if (ALARMHOUR1*10+ALARMHOUR2>1) {
           rawtimedata[9]=(rawtimedata[9]&B11100000)|((ALARMHOUR1*10+ALARMHOUR2-1)/10<<4 | (ALARMHOUR1*10+ALARMHOUR2-1)%10);
           if ((ALARMHOUR1*10+ALARMHOUR2) == 11) 
             rawtimedata[9]=(rawtimedata[9]&B11011111) | ((1-ALARMAMPM)<<5);
        } else if ((ALARMHOUR1*10+ALARMHOUR2)==1) {
           rawtimedata[9]=(rawtimedata[9] & B11100000) | B00010010;
           }
       }
    displayAlarmTime();
}

void decrementTime() {
    if (MINUTE1*10+MINUTE2>0)  {
       rawtimedata[1]=(MINUTE1*10+MINUTE2-1)/10<<4 | (MINUTE1*10+MINUTE2-1)%10;
    } else if (MINUTE1*10+MINUTE2==0) {
        rawtimedata[1]=B11011001;
        if (HOUR1*10+HOUR2>1) {
           rawtimedata[2]=(rawtimedata[9]&B11100000)|((HOUR1*10+HOUR2-1)/10<<4 | (HOUR1*10+HOUR2-1)%10);
           if ((HOUR1*10+HOUR2) == 11) 
             rawtimedata[2]=(rawtimedata[2]&B11011111) | ((1-AMPM)<<5);
        } else if ((HOUR1*10+HOUR2)==1) {
           rawtimedata[2]=(rawtimedata[2] & B11100000) | B00010010;
           }
       }
    displayTime();
}

 
void displayTime() {
  lcd.setCursor(0,1);
  if (HOUR1==0 && HOUR2==0) {
    lcd.print("12");
  } else if (HOUR1==0) {
    lcd.print(" ");
    lcd.print(HOUR2);
  } else {
    lcd.print(HOUR1);
    lcd.print(HOUR2);
  }
  
  lcd.print(":");
  lcd.print(MINUTE1);
  lcd.print(MINUTE2);
  lcd.print(":");
  lcd.print(SECOND1);
  lcd.print(SECOND2); 
  lcd.print(" ");
  if (AMPM==1)
    lcd.print("pm");
  if (AMPM==0)
    lcd.print("am");
    
} 
 
 
 
void displayAlarmTime() {
  lcd.setCursor(0,0);

  if (ALARMHOUR1==0 && ALARMHOUR2==0) {
    lcd.print("12");
  } else if (ALARMHOUR1==0) {
    lcd.print(" ");
    lcd.print(ALARMHOUR2);
  } else {
    lcd.print(ALARMHOUR1);
    lcd.print(ALARMHOUR2);
  }
  
  lcd.print(":");
  lcd.print(ALARMMINUTE1);
  lcd.print(ALARMMINUTE2);
  lcd.print(" ");
  if (ALARMAMPM==0)
    lcd.print("am");
  if (ALARMAMPM==1)
    lcd.print("pm");
}  
 
 
 
void updateArduino() {
  Wire.beginTransmission(0x68);
  Wire.send(0);
  Wire.endTransmission();
  Wire.requestFrom(0x68,16);
  for(int i=0;i<16;i++) {
    rawtimedata[i]=Wire.receive();
  }
}



void updateRTCtime() {
  Wire.beginTransmission(0x68);
  Wire.send(1);
  Wire.send(rawtimedata[1]);
  Wire.send(rawtimedata[2]);
  Wire.endTransmission();
  Serial.println("RTC Time has been updated");
  
        EEPROM.write(1,rawtimedata[1]);
      EEPROM.write(2,rawtimedata[2]);
     
      Serial.println("New time saved to EEPROM");
  
}



void updateRTCalarm() {
   rawtimedata[7]=B00000000;   //configure alarm to go off on secs/min/hour
   rawtimedata[8]=rawtimedata[8]&B01111111;
   rawtimedata[9]=rawtimedata[9]&B01111111;
   rawtimedata[10]=rawtimedata[10]|B10000000;
   
   rawtimedata[15]=B10000000;  // Reset Alarm1 flag
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
   
      EEPROM.write(8,rawtimedata[8]);
      EEPROM.write(9,rawtimedata[9]);
      EEPROM.write(10,rawtimedata[10]);
      Serial.println("New alarm time saved to EEPROM");
   
 }


 


void debug() {
  
    Serial.print("7: ");Serial.println(rawtimedata[7],BIN);
    Serial.print("8: ");Serial.println(rawtimedata[8],BIN);
    Serial.print("9: "); Serial.println(rawtimedata[9],BIN);
    Serial.print("10: "); Serial.println(rawtimedata[10],BIN);
    Serial.print("11: "); Serial.println(rawtimedata[11],BIN);
    Serial.print("12: "); Serial.println(rawtimedata[12],BIN);
    Serial.print("13: "); Serial.println(rawtimedata[13],BIN);
    Serial.print("14: "); Serial.println(rawtimedata[14],BIN);
    Serial.print("15: ");Serial.println(rawtimedata[15],BIN);
    Serial.println("");
    
}


