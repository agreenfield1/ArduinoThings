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
#include <OneWire.h>
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

OneWire  ds(A1);  // on pin 10

byte rawtimedata[18];
byte old_val=0;
unsigned long timea=0;
unsigned long alarmdelay=0;
  byte data[12];
  byte addr[8];
  int temp=0;


void setup() {
  Serial.begin(9600);
  pinMode(10, INPUT);
  pinMode(11,OUTPUT);
  pinMode(13,OUTPUT);
  pinMode(12,INPUT);
  pinMode(3,OUTPUT);
  pinMode(2,OUTPUT);
  
  Wire.begin();
    
  lcd.begin(16,2); 
  
  //Load alarm time saved in EEPROM, and reset all relevent alarm settings.
  
  rawtimedata[7]=B00000000;   //configure alarm to go off on secs/min/hour
  rawtimedata[8]=(EEPROM.read(8)&B01111111); //Set bit 7 to 0
  rawtimedata[9]=(EEPROM.read(9)&B01111111)|B01000000; //Set bit 7 to 0 and bit 6 to 1 
  rawtimedata[10]=B10000000; // Set bit 7 so alarm goes off on secs/min/hour
  rawtimedata[14]=B00000000;  // Disable alarm
  rawtimedata[15]=B10000000;  // Reset Alarm1 flag
  
  updateRTCalarm();  //send alarm setting to RTC
  updateArduino();  // Load time values from RTC.  These may or may not be correctly configured (warm or cold reboot?) so we need to reinitialize them.
  
  rawtimedata[2]=rawtimedata[2]|B01000000; //Make sure AMPM bit is 1
  updateRTCtime();
  
    digitalWrite(2,LOW);
  digitalWrite(13,ALARMSTATUS);
  analogWrite(3,255);
 
 ///Wire.beginTransmission(0x1D);
  ///Wire.send(0x2C);
 ///Wire.send(B00001010);
 /// Wire.endTransmission();
 
   Wire.beginTransmission(0x1D);
  Wire.send(0x2D);
  Wire.send(B00001000);
  Wire.endTransmission();
  
  Wire.beginTransmission(0x1D);
  Wire.send(0x31);
  Wire.send(B00000000);
  Wire.endTransmission(); 
     
   Wire.beginTransmission(0x1D);
  Wire.send(0x24);
  Wire.send(B00010110);  //Threshold
  Wire.endTransmission();    
     
   Wire.beginTransmission(0x1D);
  Wire.send(0x27);
  Wire.send(B01110000);  //Axes activate
  Wire.endTransmission();   
     
   Wire.beginTransmission(0x1D);
  Wire.send(0x2F);
  Wire.send(B00000000);  //Interupt Map
  Wire.endTransmission();    
   
  Wire.beginTransmission(0x1D);
  Wire.send(0x2E);
  Wire.send(B00010000);  //Interupt enable
  Wire.endTransmission();     
  
   ds.search(addr);
}



void loop() {


  if ((millis()-timea)>1000)  {
    updateArduino();
    getTemp();
    displayTime();
    displayAlarmTime();
    timea=millis();
  }
  
//  if(digitalRead(10)==LOW&&(millis()>alarmdelay))  
//    triggerAlarm();  
    
  byte buttonStatus = detectButton();
  if (buttonStatus == 1) { //Short press, flip alarm
    rawtimedata[14]=rawtimedata[14]^(1<<0); // Flip alarm bit
    digitalWrite(11,ALARMSTATUS);  //Alarm status LED.  On (1) is enabled
    updateRTCalarm();
  }
  if (buttonStatus==2) 
    adjustAlarm();  //Long press, adujust alarm
}


 
void getTemp () {
        
  while(ds.read()==LOW) {
  Serial.println("Waiting for temp sensor...");
  }
  
  ds.reset();
  ds.select(addr);    
  ds.write(0xBE);         // Read Scratchpad
  for (int i = 0; i < 9; i++) {           // we need 9 bytes
    data[i] = ds.read();
  }
  temp = (((data[1]<<8 | data[0])/16.0*1.8)+32.0)*10;
  
  
  ds.reset();
  ds.select(addr);
  ds.write(0x44);   
//  Serial.print("The temp: "); Serial.print(temp1/10,DEC);Serial.print(".");Serial.println(temp1%10);
}
 
void triggerAlarm() {
  byte ADXLActivity = 0;
  unsigned long alarmTime=millis()/1000;
  unsigned long currentTime=0;
  unsigned long elapsedTime=0;
  
  Wire.beginTransmission(0x1D);  //Reset activity detection interupt flag
  Wire.send(0x30);
  Wire.endTransmission();
  Wire.requestFrom(0x1D,1);
 
  Wire.receive();
  analogWrite(3,255);
  
  Serial.println("Alarm has been triggered");
  while(digitalRead(12)==LOW) { //
    digitalWrite(13,HIGH);
    lcd.setCursor(9,0);
    lcd.print("ALARM");
    delay(500);
    
    Wire.beginTransmission(0x1D);  //Check activity detection interupt flag
    Wire.send(0x30);
    Wire.endTransmission();
    Wire.requestFrom(0x1D,1);
    ADXLActivity=Wire.receive();

    if(((B00010000&ADXLActivity)>>4)==1) {
      Serial.println("Activity dectected, delaying alarm");
      alarmdelay=millis()+60000;
      digitalWrite(13,LOW);
      lcd.setCursor(9,0);
      lcd.print("     ");
      return;
    }
    currentTime=millis()/1000;
    if (currentTime-alarmTime<300) {
      elapsedTime=currentTime-alarmTime;
    } else {
    elapsedTime= 300;
    }
    Serial.print("The PWM value is:  ");Serial.println((millis()-alarmTime)/1.18);
    analogWrite(3,((millis()-alarmTime)/1.18));
    delay(5000);
    
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
       int delaylength = 0;
     // Serial.println(numb);
      digitalWrite(11, HIGH); 
      while(digitalRead(12)==HIGH) {} //wait for button release
      delay(50); //debounce time
      
          lcd.setCursor(14,0);
          lcd.print("<-");
      while(digitalRead(12)==LOW) { //Adjusting alarm

        Wire.beginTransmission(0x1D);
        Wire.send(0x34); 
        Wire.endTransmission();
        Wire.requestFrom(0x1D,2);
        ADXLdata[0]=Wire.receive();
        ADXLdata[1]=Wire.receive();
        ADXLangle=ADXLdata[1]<<8|ADXLdata[0];
         
       
       
    //    Serial.print("The angle is:  ");
    //   Serial.print(ADXLangle,DEC);
    //   Serial.print(" - ");
    //   Serial.print(ADXLdata[1],BIN);
    //   Serial.print(" ");
    //   Serial.println(ADXLdata[0],BIN);
        
        
        
        
        if (ADXLangle > 10)
          incrementAlarm();
        if (ADXLangle < -10)
          decrementAlarm();
        delaylength = (long)(250-abs(ADXLangle)) * (250-abs(ADXLangle)) / 100;
        delay(delaylength);
         }
      
      
      delay(50); //debounce time; button was pressed
          lcd.setCursor(14,0);
          lcd.print("  ");
          lcd.setCursor(14,1);
          lcd.print("<-");
          
      while(digitalRead(12)==HIGH) {
       Wire.beginTransmission(0x1D);
        Wire.send(0x34);
        Wire.endTransmission();
        Wire.requestFrom(0x1D,2);
        ADXLdata[0]=Wire.receive();
        ADXLdata[1]=Wire.receive();
        ADXLangle=ADXLdata[1]<<8|ADXLdata[0];
        //Serial.print("The angle is:  ");Serial.println(ADXLangle);
        
        if (ADXLangle > 10)
          incrementTime();
        if (ADXLangle < -10)
          decrementTime();
        delaylength = (long)(250-abs(ADXLangle)) * (250-abs(ADXLangle)) / 100;
        delay(delaylength);
      }
      
      
      
          lcd.setCursor(14,1);
          lcd.print("  ");
      updateRTCalarm();
      updateRTCtime();
      
      digitalWrite(11, LOW);
}  



  
void incrementAlarm() {
    if (ALARMMINUTE1*10+ALARMMINUTE2<59)  {
       rawtimedata[8]=(ALARMMINUTE1*10+ALARMMINUTE2+1)/10<<4 | (ALARMMINUTE1*10+ALARMMINUTE2+1)%10;
    } else {
        rawtimedata[8]=B10000000;
        if (ALARMHOUR1*10+ALARMHOUR2<11) {
           rawtimedata[9]=(rawtimedata[9]&B11100000)|((ALARMHOUR1*10+ALARMHOUR2+1)/10<<4 | (ALARMHOUR1*10+ALARMHOUR2+1)%10);
        }  else {
           rawtimedata[9]=(rawtimedata[9] & B11100000) | B00000001;
           rawtimedata[9]=(rawtimedata[9] & B11011111) | ((1-ALARMAMPM)<<5);
           }
       }
    displayAlarmTime();
}
         
              
  

void incrementTime() {
    if (MINUTE1*10+MINUTE2<59)  {
       rawtimedata[1]=(MINUTE1*10+MINUTE2+1)/10<<4 | (MINUTE1*10+MINUTE2+1)%10;
    } else {
        rawtimedata[1]=B10000000;
        if (HOUR1*10+HOUR2<11) {
           rawtimedata[2]=(rawtimedata[2]&B11100000)|((HOUR1*10+HOUR2+1)/10<<4 | (HOUR1*10+HOUR2+1)%10);
        } else {
           rawtimedata[2]=(rawtimedata[2] & B11100000) | B00000000;
           rawtimedata[2]=(rawtimedata[2]&B11011111) | ((1-AMPM)<<5);
        }
    }
    displayTime();
}
  
void decrementAlarm() {
    if (ALARMMINUTE1*10+ALARMMINUTE2>0)  {   // Minute between 1 and 59
       rawtimedata[8]=(ALARMMINUTE1*10+ALARMMINUTE2-1)/10<<4 | (ALARMMINUTE1*10+ALARMMINUTE2-1)%10;  // decrease time by 1
    } else {                                                                            // Minute is 0
        rawtimedata[8]=B11011001;                                                      // set minute to 59
        if (ALARMHOUR1*10+ALARMHOUR2>0) {                                             // Hour is between 1 and 11
           rawtimedata[9]=(rawtimedata[9]&B11100000)|((ALARMHOUR1*10+ALARMHOUR2-1)/10<<4 | (ALARMHOUR1*10+ALARMHOUR2-1)%10); //Decrease hour by 1
        } else {                                                                                  // Hour is 11
             rawtimedata[9]=(rawtimedata[9] & B11100000) | B00010001;
             rawtimedata[9]=(rawtimedata[9]&B11011111) | ((1-ALARMAMPM)<<5);
        } 
     }
   displayAlarmTime();
}

void decrementTime() {
    if (MINUTE1*10+MINUTE2>0)  {
       rawtimedata[1]=(MINUTE1*10+MINUTE2-1)/10<<4 | (MINUTE1*10+MINUTE2-1)%10;
    } else {
        rawtimedata[1]=B11011001;
        if (HOUR1*10+HOUR2>0) {
           Serial.println("Hour rollover");
           rawtimedata[2]=(rawtimedata[2]&B11100000)|((HOUR1*10+HOUR2-1)/10<<4 | (HOUR1*10+HOUR2-1)%10);
        } else {
           rawtimedata[2]=(rawtimedata[2] & B11100000) | B00010001;
           rawtimedata[2]=(rawtimedata[2] & B11011111) | ((1-AMPM)<<5);
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
  lcd.print("  ");
    
  int RTCtemp = (((rawtimedata[17]<<8)|rawtimedata[18])>>6)/4*1.8+32;
  //Serial.print(RTCtemp);Serial.print(" ");Serial.print(rawtimedata[17],BIN);Serial.print(" ");Serial.println(rawtimedata[18],BIN);
  lcd.print(RTCtemp);
  lcd.print("F");  
    
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
  lcd.print(" ");
  lcd.print(temp/10,DEC);lcd.print(".");lcd.print(temp%10);lcd.print("F ");  
  
 // Serial.print("The temp: "); Serial.print(temp1/10,DEC);
 
}  
 
 
 
void updateArduino() {
  Wire.beginTransmission(0x68);
  Wire.send(0);
  Wire.endTransmission();
  Wire.requestFrom(0x68,19);
  for(int i=0;i<19;i++) {
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
   
      EEPROM.write(8,rawtimedata[8]);
      EEPROM.write(9,rawtimedata[9]);
   //   EEPROM.write(10,rawtimedata[10]);
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


