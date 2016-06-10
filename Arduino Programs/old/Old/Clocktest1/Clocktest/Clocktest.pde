 /*
 Circuit description
 Pin 2:" buzzer
 Pin13: Switch on high power circuit
 Pin 12: Button (Output)
 Pin 11: LED status light (Output)
 Pin 10: Alarm trigger (Input)
 Pin 9-4:LCD (ybggpy)
 Pin 3: pwm for high power led
 Analog 4: RTC pin 5 (blue)
 Analog 5: RTC pin 6 (yellow)
*/

#include <Flash.h>
#include <MemoryFree.h>
#include <Wire.h>
#include <LiquidCrystal.h>
#include <OneWire.h>

#define RTCADDR 0x68
#define ADXLADDR 0x1D

#define BUZZERPIN 2
#define LEDPOWERPIN 13
#define BUTTONPIN 12
#define ALARMENABLELEDPIN 11
#define LEDPWMPIN 3
#define PHOTOPIN A0
#define TEMPPIN A1
#define LEDPOTPIN A2
#define PROXIMITYPIN A3

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
#define ALARMENABLESTATUS int(B1 & rawtimedata[14])
#define ALARMTRIGGERSTATUS int(B1 & rawtimedata[15])

#define PREVIOUSALARMSTATUS 0 // bit references in settingsBits
#define CURRENTBUTTONSTATE 1
#define PREVIOUSBUTTONSTATE 2
#define ALARMMODE 3
#define STATE 4
#define ALARMORTIMEADJUST 5 

byte settingsBits=B00000000; 
byte rawtimedata[20];
byte old_val=0;
unsigned int alarmDelay=0;
unsigned int elapsedAlarmTime;
byte addr[8];
unsigned long originalAlarmTriggerTime=0;
unsigned long previousRunTime;
unsigned long previousRunTime2;
int lightThresh=200;

LiquidCrystal lcd(8, 9, 4, 5, 6, 7);
OneWire ds(TEMPPIN);  // on pin 10


void setup() {
  pinMode(ALARMENABLELEDPIN,OUTPUT);
  pinMode(LEDPOWERPIN,OUTPUT);
  pinMode(BUTTONPIN,INPUT);
  pinMode(LEDPWMPIN,OUTPUT);
  pinMode(BUZZERPIN,OUTPUT);
  pinMode(LEDPOTPIN,INPUT);  
  pinMode(PROXIMITYPIN,INPUT);
  
  analogWrite(LEDPWMPIN,0);
  digitalWrite(BUZZERPIN,LOW);
  digitalWrite(ALARMENABLELEDPIN,ALARMENABLESTATUS);
  digitalWrite(LEDPOWERPIN,HIGH);
  
  Serial.begin(9600);
  Wire.begin();
  lcd.begin(16,2); 
  ds.search(addr);

  updateArduino();  // Load time values from RTC.  These may or may not be correctly configured (warm or cold reboot?) so we need to reinitialize them.
  bitSet(rawtimedata[2],6);   // set 12/24
  bitClear(rawtimedata[7],7);  // Clear A1M1
  bitClear(rawtimedata[8],7);  // Clear A1M2
  bitClear(rawtimedata[9],7); bitSet(rawtimedata[9],6); // Clear A1M3, set 12/24;
  bitSet(rawtimedata[10],7); bitSet(rawtimedata[10],6); // Set A1M4, set DY/DT
  bitClear(rawtimedata[11],7); // Clear A2M2
  bitClear(rawtimedata[12],7); // Clear A2M3
  bitClear(rawtimedata[13],7); // Clear A2M4
  rawtimedata[14]=B00001000;
  rawtimedata[15]=B00000000;
  updateRTCtime();
  updateRTCalarm();
  
  byte ADXLDataArray[22]={
    B00111100,      // 0x1D (THRESH_TAP)     Tap threshold
    B00000000,      // 0x1E (OFSX)           X-axis offset 
    B00000000,      // 0x1F (OFSY)           Y-axis offset
    B00000000,      // 0x20 (OFSZ)           Z-axis offset
    B11111111,      // 0x21 (DUR)            Tap duration 
    B00000000,      // 0x22 (Latent)         Tap latency 
    B00000000,      // 0x23 (Window)         Tap window 
    B00111100,      // 0x24 (THRESH_ACT)     Activity threshold 
    B00000000,      // 0x25 (THRESH_INACT)   Inactivity threshold 
    B00000000,      // 0x26 (TIME_INACT)     Inactivity time 
    B11110000,      // 0x27 (ACT_INACT_CTL)  Axis enable control for activity and inactivity detection
    B00000000,      // 0x28 (THRESH_FF)      Free-fall threshold 
    B00000000,      // 0x29 (TIME_FF)        Free-fall time 
    B00000111,      // 0x2A (TAP_AXES)       Axis control for single tap/double tap 
    B11111111,      // 0x2B (ACT_TAP_STATUS) Source of single tap/double tap - READ ONLY
    B00001010,      // 0x2C (BW_RATE)        Data rate and power mode control
    B00001000,      // 0x2D (POWER_CTL)      Power-saving features control 
    B01010000,      // 0x2E (INT_ENABLE)     Interrupt enable control 
    B00000000,      // 0x2F (INT_MAP)        Interrupt mapping control 
    B11111111,      // 0x30 (INT_SOURCE)     Source of interrupts - READ ONLY
    B00000000       // 0x31 (DATA_FORMAT)    Data format control 
  };
  Wire.beginTransmission(ADXLADDR);
  Wire.send(0x1D);
  for(int i=0;i<=21;i++) {
    Wire.send(ADXLDataArray[i]);  
  }
  Wire.endTransmission(); 
}

 
void loop() { 
  if ((millis()-previousRunTime)>1000)  {
    previousRunTime=millis();
    updateArduino();
    getTemp();
    displayTime();
    displayAlarm();
    digitalWrite(ALARMENABLELEDPIN,ALARMENABLESTATUS);

   
    if (ALARMTRIGGERSTATUS==1&&ALARMENABLESTATUS==1)  {  // Alarm is enabled and triggered
      if (bitRead(settingsBits,PREVIOUSALARMSTATUS)==0) {     // Initialize the alarm, it just got triggered)      
         checkADXLActivity();  // Reset activity detection interupt flag
         originalAlarmTriggerTime=millis()/1000;
         analogWrite(LEDPWMPIN,0);
         bitSet(settingsBits,PREVIOUSALARMSTATUS);
         unsigned int ambientLightReading = analogRead(PHOTOPIN);
         if (ambientLightReading > 200) {
            bitClear(settingsBits,ALARMMODE);  //Too much ambient light, use buzzer
            Serial.print(F("Selecting buzzer: "));Serial.println(ambientLightReading);
         }  else {
            bitSet(settingsBits,ALARMMODE);  //Use sunrise simulation
            Serial.print(F("Selecting sunrise simulation: "));Serial.println(ambientLightReading);
         }
         Serial.println(F("Alarm has been triggered (initial activation)"));
      }
      
      if (millis()/1000>=originalAlarmTriggerTime) { //  Update elapsedAlarmTime, with millis() rollover detection
         elapsedAlarmTime=(millis()/1000-originalAlarmTriggerTime);
      } else {  //Timer has rolled over
         elapsedAlarmTime=(millis()/1000 + (2^32-1)/1000-originalAlarmTriggerTime);
         Serial.println(F("Runover of millis has occurred!!!"));
      }

      if (elapsedAlarmTime>alarmDelay) // Alarm is activated         
         triggerAlarm();
      else {  // Alarm is asleep
         checkADXLActivity();  //Reset activity detection interupt flag.  I need this to keep it reset during sleep.          
      }    
    } else {
      if (bitRead(checkADXLActivity(),4)==1)
        displayCalendar(); 
    }
  }

  byte buttonStatus = detectButton();
      
  if (ALARMTRIGGERSTATUS==1&&buttonStatus==1&&ALARMENABLESTATUS==1) {  // Turn off alarm: run if alarm is sounding and button was pressed
    alarmDelay=0;
    analogWrite(3,0);
    bitClear(rawtimedata[15],0); 
    bitClear(settingsBits,PREVIOUSALARMSTATUS);
    Serial.println(F("Alarm has been turned off"));
  }

 switch (buttonStatus) {
   case 1: //Short press, flip alarm
     rawtimedata[14]^=B00000001; // Flip alarm bit
     bitClear(rawtimedata[15],0);
     digitalWrite(ALARMENABLELEDPIN,ALARMENABLESTATUS);
     ackBeep(3);
     updateRTCalarm();
     break;
  case 2:  //Long press, adujust alarm
    lcd.setCursor(9,0);
    lcd.print(F("     <- "));
    adjustByADXL(1);  
    ackBeep(3);  
    break;
  case 3:   //Extra long press, adjust time
    lcd.setCursor(14,1);
    lcd.print(F("<-"));
    adjustByADXL(0); 
    ackBeep(3);
    break;
 }
 
 if (ALARMTRIGGERSTATUS==0|ALARMENABLESTATUS==0) {  // Only run when alarm hasn't tripped, or if it has tripped but isn't enabled
    int PWMValue =(sq((long)analogRead(LEDPOTPIN))/4104);
    analogWrite(LEDPWMPIN,PWMValue);
 } 
}


byte checkADXLActivity() {
  Wire.beginTransmission(ADXLADDR);
  Wire.send(0x30);
  Wire.endTransmission();
  Wire.requestFrom(ADXLADDR,1);
  return Wire.receive();
}


void getTemp () {
  while(ds.read()==LOW) {
    Serial.println(F("Waiting for temp sensor..."));
  }
  byte data[12];
  int temp=0;
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
  lcd.setCursor(11,0);
  lcd.print(temp/10,DEC);
  lcd.print(F("."));
  lcd.print(temp%10);
  lcd.print(F("F "));    
}


void triggerAlarm() {  
 if(bitRead(checkADXLActivity(),4)==1) {   //Turn alarm off and delay it for 10 minutes;
    Serial.print(F("Activity dectected, delaying alarm for 10 minutes"));
    alarmDelay=(millis()/1000 - originalAlarmTriggerTime)+600;
    analogWrite(LEDPWMPIN,0);
    ackBeep(2);
    return;
 }
 switch (bitRead(settingsBits,ALARMMODE)) {
   case 1: // Sunrise simulation mode
     if (elapsedAlarmTime<600) {
       int PWMsetting=(sq((long)elapsedAlarmTime))/(360000/255.0) +1;
       analogWrite(LEDPWMPIN,PWMsetting);  
     } else {
     Serial.println(F("Elapsed time over 600; max brightness"));
     analogWrite(LEDPWMPIN,255);
     }
     break;
   case 0: // Buzzer mode
     settingsBits^=1<<STATE;
     digitalWrite(BUZZERPIN,bitRead(settingsBits,STATE));
     break;
 }
}  


int detectButton() {
  bitWrite(settingsBits,CURRENTBUTTONSTATE,digitalRead(BUTTONPIN));
  unsigned long startTime=0;
  unsigned int pressedTime=0;
  if ((bitRead(settingsBits,CURRENTBUTTONSTATE)==HIGH) && (bitRead(settingsBits,PREVIOUSBUTTONSTATE)==LOW)) {
    startTime=millis();
    delay(50);
    do {
      pressedTime=millis()-startTime;
      if (pressedTime>1500&&pressedTime<1540)
        ackBeep(1);
      if (pressedTime>3000&&pressedTime<3050) 
        ackBeep(2);
    } while (digitalRead(BUTTONPIN)==HIGH);
  }
  if ((pressedTime)<1000 && pressedTime !=0) {
    Serial.println(F("Short press registered (<1s)"));  
    return 1;
  } 
  if (pressedTime>1500 && pressedTime<3000) {     
    Serial.println(F("Long press registered (1.5s - 3s)"));     
    return 2;
  }
  if (pressedTime>3000) {     
    Serial.println(F("Extra long press registered (>3s)"));     
    return 3;
  }
  return 0;
}


void adjustByADXL(int settingToAdjust)  {  
  unsigned long lastUpdateTime=0;
  int delayTime = 0;

  while(digitalRead(BUTTONPIN)==LOW) { //Adjusting alarm
    int ADXLangle=getADXLangle(1);
      if ((millis()-lastUpdateTime)>delayTime) {
        if (ADXLangle > 20) {
          switch (settingToAdjust) {
            case 0:
              decrementTime();
              break;
            case 1:
              decrementAlarm();
              break;
            case 2: 
              decrementMonth();
              break;
            case 3:
              decrementDate();
              break;
            case 4:
              decrementYear();
              break;
            case 5:
              decrementDay();
              break;
          }
        }       
        if (ADXLangle < -20) {
          switch (settingToAdjust) {
            case 0:
              incrementTime();
              break;
            case 1:
              incrementAlarm();
              break;
            case 2: 
              incrementMonth();
              break;
            case 3:
              incrementDate();
              break;
            case 4:
              incrementYear();
              break;
            case 5:
              incrementDay();
              break;
        }
      }
      lastUpdateTime=millis();
    }    
    if (abs(ADXLangle)>245) {
      delayTime=0;          
    } else if (abs(ADXLangle)<20) {
      delayTime=600;
    } else if (abs(ADXLangle)>19) {
      delayTime=(250-abs(ADXLangle))*2;  
    }   
  }
  updateRTCalarm();
  updateRTCtime();
  while(digitalRead(BUTTONPIN)==HIGH) {};
}











void ADXLDiagnoser() {
  byte sensitivity=analogRead(LEDPOTPIN)/4;
  byte activityTest=checkADXLActivity();
  
  lcd.setCursor(0,0);
  lcd.print(F("                "));
  lcd.setCursor(0,0);
  lcd.print(bitRead(activityTest,4));
  lcd.print(F("-"));
  lcd.print(bitRead(activityTest,6));
  lcd.print(F("  "));
  lcd.print(sensitivity,BIN);
  Wire.beginTransmission(ADXLADDR);
  Wire.send(0x24);
  Wire.send(sensitivity);  //Set activity detection threshold
  Wire.endTransmission();    
  Wire.beginTransmission(ADXLADDR);
  Wire.send(0x1D);
  Wire.send(sensitivity);  //Set activity detection threshold
  Wire.endTransmission();
  
  
  
}


void updateArduino() {
  Wire.beginTransmission(RTCADDR);
  Wire.send(0);
  Wire.endTransmission();
  Wire.requestFrom(RTCADDR,19);
  for(int i=0;i<19;i++) {
    rawtimedata[i]=Wire.receive();
  }
}


void updateRTCtime() {
  Wire.beginTransmission(RTCADDR);
  Wire.send(1);
  Wire.send(rawtimedata[1]);
  Wire.send(rawtimedata[2]);
  Wire.send(rawtimedata[3]);
  Wire.send(rawtimedata[4]);
  Wire.send(rawtimedata[5]);
  Wire.send(rawtimedata[6]);
  Wire.endTransmission();
  Serial.println(F("RTC Time has been updated"));
}


void updateRTCalarm() {
  Wire.beginTransmission(RTCADDR);
  Wire.send(7);  //Send alarm time
  Wire.send(rawtimedata[7]);
  Wire.send(rawtimedata[8]);
  Wire.send(rawtimedata[9]);
  Wire.send(rawtimedata[10]);
  Wire.send(rawtimedata[11]);
  Wire.send(rawtimedata[12]);
  Wire.send(rawtimedata[13]);
  Wire.send(rawtimedata[14]);
  Wire.send(rawtimedata[15]);
  Wire.endTransmission();
  Serial.print(F("RTC Alarm has been updated.  Alarm status: "));
  Serial.println(ALARMENABLESTATUS);
}


void debug() {
  Serial.print(F("7: "));
  Serial.println(rawtimedata[7],BIN);
  Serial.print(F("8: "));
  Serial.println(rawtimedata[8],BIN);
  Serial.print(F("9: ")); 
  Serial.println(rawtimedata[9],BIN);
  Serial.print(F("10: ")); 
  Serial.println(rawtimedata[10],BIN);
  Serial.print(F("11: ")); 
  Serial.println(rawtimedata[11],BIN);
  Serial.print(F("12: ")); 
  Serial.println(rawtimedata[12],BIN);
  Serial.print(F("13: ")); 
  Serial.println(rawtimedata[13],BIN);
  Serial.print(F("14: ")); 
  Serial.println(rawtimedata[14],BIN);
  Serial.print(F("15: "));
  Serial.println(rawtimedata[15],BIN);
  Serial.println(F(""));
}


void ackBeep(int count) {
  for(int i=1;i<=count;i++)  {
    digitalWrite(BUZZERPIN,HIGH);
    delay(50);
    digitalWrite(BUZZERPIN,LOW);
    delay(30); 
  }
}


void timeCheck() {
  Serial.print(F("The execution time is: ")); Serial.println(millis()-previousRunTime2);
  previousRunTime2=millis();
}


void displayCalendar() {
   byte button=0;
   lcd.clear();
   displayMonth();
   lcd.print(F(". "));
   displayDate();
   lcd.print(F(", "));
   displayYear();
   displayDay();
   unsigned long startRunTime = millis();
   
   do {  //Window 1: Showing date info
      button=detectButton();
      if ((millis()-startRunTime)>5000) {
        lcd.clear();
        return;
      }
      if (button==2) 
        adjustCalendar();       
   } while(button!=1);
   
   delay(20);
   while(digitalRead(BUTTONPIN)==HIGH) {}  
   ackBeep(1);
   delay(100);
   startRunTime = millis();
  
   do {  //Window 2: Showing sensor values
     if ((millis()-startRunTime)>50) {
       startRunTime=millis();
       lcd.clear();
       lcd.print(F("Pot:"));
       lcd.print(analogRead(LEDPOTPIN));
       lcd.setCursor(9,0);
       lcd.print(F("Prx:"));
       lcd.print(analogRead(PROXIMITYPIN));
       lcd.setCursor(0,1);
       lcd.print(F("Lgt:"));
       lcd.print(analogRead(PHOTOPIN));
     }
   } while(detectButton()==0); 
   
   ackBeep(1);
   delay(100);
   startRunTime = millis();

    int cursorPosition=0;
   byte oldsensitivity=0;
   Wire.beginTransmission(ADXLADDR);
   Wire.send(0x24);
   Wire.endTransmission();
   Wire.requestFrom(ADXLADDR,1);
   oldsensitivity=Wire.receive();
   do {  //Window 3:  Activity diagnosing screen
     ADXLDiagnoser();
     delay(250);
   } while (detectButton()==0);
        delay(100);
    lcd.clear();
    lcd.print(F("Yes   Save?   No"));
   do {  //Window 3.5:  Activity diagnosing screen
     cursorPosition=-getADXLangle(1)/15+7;
     if (cursorPosition<0)
       cursorPosition=0;
     if (cursorPosition>15)
       cursorPosition=15;
     lcd.setCursor(cursorPosition,1);
     lcd.print(F("-"));  
     delay(100);
     lcd.setCursor(cursorPosition,1);
     lcd.print(F(" "));
   } while (cursorPosition>0 && cursorPosition<15);
   if (cursorPosition==15) {
         Wire.beginTransmission(ADXLADDR);
      Wire.send(0x24);
      Wire.send(oldsensitivity);  //return old value
      Wire.endTransmission();   
   }
   
   ackBeep(1);
   delay(100);
   startRunTime = millis();

   do {  //Window 4:  Showing ADXL tilt data
     if ((millis()-startRunTime)>200) {  //run every 100ms
       startRunTime=millis();
       byte activityTest=checkADXLActivity();
       
       lcd.clear();
       lcd.print(F("Tap: "));
       lcd.print(bitRead(activityTest,4));
       lcd.setCursor(8,0);
       lcd.print(F("Act: "));
       lcd.print(bitRead(activityTest,6));
       lcd.setCursor(0,1);
       lcd.print(getADXLangle(0));
       lcd.setCursor(5,1);
       lcd.print(getADXLangle(1));
       lcd.setCursor(10,1);
       lcd.print(getADXLangle(2));
     }
   } while(detectButton()==LOW); 
   
   ackBeep(1);
   delay(100);
   startRunTime = millis();
        
   lcd.clear();
   lcd.setCursor(0,0);
   lcd.print(F("Strobe mode!"));
   do {  //Window 5   
       int potValue = analogRead(LEDPOTPIN);
       analogWrite(LEDPWMPIN,255);
       delay(5);
       analogWrite(LEDPWMPIN,0);
       delay(potValue/4);        
   } while(detectButton()==LOW); 
   
   ackBeep(1);
   lcd.clear();
}
 
  
void adjustCalendar() {
    lcd.setCursor(3,0);
    lcd.print(F("<"));
    adjustByADXL(2); //Adjust the month
    lcd.setCursor(3,0);
    lcd.print(F("."));
    ackBeep(1);
    while((digitalRead(BUTTONPIN))==HIGH) {}
    delay(100); 
    
    lcd.setCursor(7,0);
    lcd.print(F("<"));
    adjustByADXL(3); //Adjust the Date
    lcd.setCursor(7,0);
    lcd.print(F(","));
    ackBeep(1);
    while((digitalRead(BUTTONPIN))==HIGH) {}
    delay(100); 
    
    lcd.setCursor(13,0);
    lcd.print(F("<"));
    adjustByADXL(4); //Adjust the Year
    lcd.setCursor(13,0);
    lcd.print(F(" "));
    ackBeep(1);
    while((digitalRead(BUTTONPIN))==HIGH) {}
    delay(100); 
    
    lcd.setCursor(9,1);
    lcd.print(F("<"));    
    adjustByADXL(5); //Adjust the Day
    lcd.setCursor(9,1);
    lcd.print(F("<")); 
    ackBeep(3);
    while((digitalRead(BUTTONPIN))==HIGH) {}
    delay(100); 
}
  
  
int getADXLangle(byte axis) { // 0=X axis, 1=Y axis, 2=Z axis
       byte ADXLdata[2];
       Wire.beginTransmission(ADXLADDR);
       Wire.send(0x32+(axis*2)); 
       Wire.endTransmission();
       Wire.requestFrom(ADXLADDR,2);
       for(int i=0;i<2;i++) {
         ADXLdata[i]=Wire.receive();
       }
       int ADXLangle=ADXLdata[1]<<8|ADXLdata[0];
       return ADXLangle;
}





void incrementAlarm() {
  if (ALARMMINUTE1*10+ALARMMINUTE2<59)  {  // no hour rollover
    rawtimedata[8]=(ALARMMINUTE1*10+ALARMMINUTE2+1)/10<<4 | (ALARMMINUTE1*10+ALARMMINUTE2+1)%10;
  } else { //hour rollover has occured (minute from 59 to 0)
    rawtimedata[8]=B10000000;
    if (ALARMHOUR1*10+ALARMHOUR2<11) { // the hour is from 0 (12) to 10, so we can just increment it
      rawtimedata[9]=(rawtimedata[9]&B11100000)|((ALARMHOUR1*10+ALARMHOUR2+1)/10<<4 | (ALARMHOUR1*10+ALARMHOUR2+1)%10);
    } else {  //the hour is 11, so we need to roll it over to 0 (AKA 12)
      rawtimedata[9]=(rawtimedata[9] & B11100000)^B00100000;
    }
  }
  displayAlarm();
}
void decrementAlarm() {
  if (ALARMMINUTE1*10+ALARMMINUTE2>0)  {   // Minute between 1 and 59
    rawtimedata[8]=(ALARMMINUTE1*10+ALARMMINUTE2-1)/10<<4 | (ALARMMINUTE1*10+ALARMMINUTE2-1)%10;  // decrease time by 1
  } else {  // Minute is 0
    rawtimedata[8]=B11011001;  // set minute to 59
    if (ALARMHOUR1*10+ALARMHOUR2>0) {   // Hour is between 1 and 11
      rawtimedata[9]=(rawtimedata[9]&B11100000)|((ALARMHOUR1*10+ALARMHOUR2-1)/10<<4 | (ALARMHOUR1*10+ALARMHOUR2-1)%10); //Decrease hour by 1
    } else {  //Hour is 0, so we need to set it to 11
      Serial.println(F("should print"));
      rawtimedata[9]=((rawtimedata[9]&B11100000)|B00010001)^B00100000;
    }
  }
  displayAlarm();
}
void displayAlarm() {
  lcd.setCursor(0,0);
  if (ALARMHOUR1==0 && ALARMHOUR2==0) {
    lcd.print(F("12"));
  } else if (ALARMHOUR1==0) {
    lcd.print(F(" "));
    lcd.print(ALARMHOUR2);
  } else {
    lcd.print(ALARMHOUR1);
    lcd.print(ALARMHOUR2);
  }
  lcd.print(F(":"));
  lcd.print(ALARMMINUTE1);
  lcd.print(ALARMMINUTE2);
  lcd.print(F(" "));
  if (ALARMAMPM==0)
    lcd.print(F("am"));
  if (ALARMAMPM==1)
    lcd.print(F("pm"));
}  


void incrementTime() {
  if (MINUTE1*10+MINUTE2<59)  {   // no hour rollover
    rawtimedata[1]=(MINUTE1*10+MINUTE2+1)/10<<4 | (MINUTE1*10+MINUTE2+1)%10;
  } else {   //hour rollover has occured (minute from 59 to 0)
    rawtimedata[1]=B10000000;
    if (HOUR1*10+HOUR2<11) {   // the hour is from 0 (12) to 10, so we can just increment it
      rawtimedata[2]=(rawtimedata[2]&B11100000)|((HOUR1*10+HOUR2+1)/10<<4 | (HOUR1*10+HOUR2+1)%10);
    } else {  // the hour is 11, so we need to set it to 0 (AKA 12)
      rawtimedata[2]=(rawtimedata[2] & B11100000)^B00100000;
    }
  }
  displayTime();
}
void decrementTime() {
  if (MINUTE1*10+MINUTE2>0)  {
    rawtimedata[1]=(MINUTE1*10+MINUTE2-1)/10<<4 | (MINUTE1*10+MINUTE2-1)%10;
  } else {
    rawtimedata[1]=B11011001;
    if (HOUR1*10+HOUR2>0) {
      Serial.println(F("Hour rollover"));
      rawtimedata[2]=(rawtimedata[2]&B11100000)|((HOUR1*10+HOUR2-1)/10<<4 | (HOUR1*10+HOUR2-1)%10);
    } else {
      rawtimedata[2]=(rawtimedata[2] & B11100000) | B00010001;
      rawtimedata[2]=(rawtimedata[2] & B11011111) | ((1-AMPM)<<5);
      Serial.println(F("from 12 to 11"));
    }
  }            
  displayTime();
}
void displayTime() {
  lcd.setCursor(0,1);
  if (HOUR1==0 && HOUR2==0) {
    lcd.print(F("12"));
  } else if (HOUR1==0) {
    lcd.print(F(" "));
    lcd.print(HOUR2);
  } else {
    lcd.print(HOUR1);
    lcd.print(HOUR2);
  }
  lcd.print(F(":"));
  lcd.print(MINUTE1);
  lcd.print(MINUTE2);
  lcd.print(F(":"));
  lcd.print(SECOND1);
  lcd.print(SECOND2); 
  lcd.print(F(" "));
  if (AMPM==1)
    lcd.print(F("pm"));
  if (AMPM==0)
    lcd.print(F("am"));
} 


void incrementDay() {
  if (rawtimedata[3]==B00000111) {
     rawtimedata[3]=B00000001;
  } else {
     rawtimedata[3]=rawtimedata[3]+1;
  }
  displayDay();
}           
void decrementDay() {       
  if (rawtimedata[3]==B00000001) {
     rawtimedata[3]=B00000111;
  } else {
     rawtimedata[3]=rawtimedata[3]-1;
  }
  displayDay();
}
void displayDay() { 
  lcd.setCursor(0,1);
  switch (int(rawtimedata[3]&B00000111)) {
     case 1:
       lcd.print(F("Sunday   "));
       break;
     case 2:
       lcd.print(F("Monday   "));
       break;
     case 3:
       lcd.print(F("Tuesday  "));
       break;
     case 4:
       lcd.print(F("Wednesday"));
       break;       
     case 5:
       lcd.print(F("Thursday "));
       break;   
     case 6:
       lcd.print(F("Friday   "));
       break;   
     case 7:
       lcd.print(F("Saturday "));
       break;
   }
}

  
void incrementMonth() {
  if((rawtimedata[5]&B01111111)==B00010010) {
     rawtimedata[5]=(rawtimedata[5]&B1000000)|B00000001;
  } else if ((rawtimedata[5]&B00001111)==B00001001) {
     rawtimedata[5]=(rawtimedata[5]&B10000000)|B00010000;          
  } else {
     rawtimedata[5]=(rawtimedata[5]&B11110000)|(B00001111&rawtimedata[5]+1);
  }
  displayMonth();
}         
void decrementMonth() {    
  if ((rawtimedata[5]&B01111111)==B00000001) {
     rawtimedata[5]=(rawtimedata[5]&B1000000)|B00010010;    
  } else if ((rawtimedata[5]&B00011111)==B00010000) {
     rawtimedata[5]=(rawtimedata[5]&B10000000)|B00001001;          
  } else {
     rawtimedata[5]=(rawtimedata[5]&B11110000)|(B00001111&rawtimedata[5]-1);
  }
  displayMonth();
}
void displayMonth() {
   lcd.setCursor(0,0);
   switch(int(rawtimedata[5]&B00001111)+10*bitRead(rawtimedata[5],4)) {
     case 1:
       lcd.print(F("Jan"));
       break;
     case 2:
       lcd.print(F("Feb"));
       break;
     case 3:
       lcd.print(F("Mar"));
       break;
     case 4:
       lcd.print(F("Apr"));
       break;       
     case 5:
       lcd.print(F("May"));
       break;   
     case 6:
       lcd.print(F("Jun"));
       break;   
     case 7:
       lcd.print(F("Jul"));
       break;
     case 8:
       lcd.print(F("Aug"));
       break;
     case 9:
       lcd.print(F("Sep"));
       break;
     case 10:
       lcd.print(F("Oct"));
       break;   
     case 11:
       lcd.print(F("Nov"));
       break; 
     case 12:
       lcd.print(F("Dec"));
       break;
   }    
}

  
void incrementYear() {
  if ((rawtimedata[6]==B10011001)) {
     rawtimedata[6]=B00000000;
     rawtimedata[5]^=B10000000;
  } else if ((rawtimedata[6]&B00001111)==B00001001) {                      
     rawtimedata[6]=(((rawtimedata[6]>>4)+1)<<4);              
  } else {
     rawtimedata[6]=(rawtimedata[6]&B11110000)|(B00001111&rawtimedata[6]+1);      
  }
  displayYear();
}
void decrementYear() {       
  if (rawtimedata[6]==B00000000) {
     rawtimedata[6]=B10011001;
     rawtimedata[5]^=B10000000; 
  } else if ((rawtimedata[6]&B00001111)==B00000000) {
     rawtimedata[6]=(((rawtimedata[6]>>4)-1)<<4)|B00001001;          
  } else {
     rawtimedata[6]=(rawtimedata[6]&B11110000)|(B00001111&rawtimedata[6]-1);
  }
  displayYear();
}  
void displayYear() {  
   lcd.setCursor(9,0);
   if (bitRead(rawtimedata[5],7)==1) {
     lcd.print(F("19"));
   } else {
     lcd.print(F("20"));
   }
   if ((rawtimedata[6]&B11110000)==0)
     lcd.print(F("0"));
   lcd.print(int(rawtimedata[6]&B00001111)+10*int(rawtimedata[6]>>4));
}
  

void incrementDate() {
  if (rawtimedata[4]==B00110001) {
     rawtimedata[4]=B00000001;    
  } else if ((rawtimedata[4]&B00001111)==B00001001) {
     Serial.print(rawtimedata[4],BIN);Serial.print(F("  ")); 
     rawtimedata[4]=(((rawtimedata[4]>>4)+1)<<4);  
     Serial.println(rawtimedata[4],BIN);        
  } else {
     rawtimedata[4]=(rawtimedata[4]&B11110000)|(B00001111&rawtimedata[4]+1);     
  }
  displayDate();
} 
void decrementDate() {      
    if (rawtimedata[4]==B00000001) {
       rawtimedata[4]=B00110001;       
    } else if ((rawtimedata[4]&B00001111)==B00000000) {
       rawtimedata[4]=(((rawtimedata[4]>>4)-1)<<4)|B00001001;          
    } else {
       rawtimedata[4]=(rawtimedata[4]&B11110000)|(B00001111&rawtimedata[4]-1);
    }
    displayDate();
}
void  displayDate() {
   lcd.setCursor(5,0);
   if ((rawtimedata[4]&B00110000)==0)
      lcd.print(F(" "));
   lcd.print(int(rawtimedata[4]&B00001111)+10*int(rawtimedata[4]>>4));
}

