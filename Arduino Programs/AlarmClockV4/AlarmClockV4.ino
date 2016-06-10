/*
 * Time_NTP.pde
 * Example showing time sync to NTP time source
 *
 * This sketch uses the Ethernet library
 */
 
#include <TimeLib.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <Wire.h>
#include <DS1307RTC.h> 
#include <SPI.h>
#include <LCD.h>
#include <LiquidCrystal_I2C.h>
#include <Encoder.h>
#include <PubSubClient.h>
#include <HttpClient.h>

#define BUTTONPIN 7

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFA, 0xED }; 

IPAddress mqttServer(10, 20, 30, 8);
IPAddress ntpServer(10, 20, 30, 1); // time-a.timefreq.bldrdoc.gov
const char kHostname[] = "openhab.ajghs.com";

// Number of milliseconds to wait without receiving any data before we give up
const int kNetworkTimeout = 30*1000;
// Number of milliseconds to wait if no data is available before trying again
const int kNetworkDelay = 1000;

const int timeZone = -4;  
EthernetUDP Udp;
unsigned int localPort = 8888;  // local port to listen for UDP packets
Encoder myEnc(2, 6);
LiquidCrystal_I2C lcd(0x27,2,1,0,4,5,6,7);
EthernetClient ethClient;
PubSubClient client(ethClient);
HttpClient http(ethClient);


void setup() 
{
  Serial.begin(9600);
  Serial.println("Booting");
  delay(250);
  lcd.begin(20,2); 
  pinMode(BUTTONPIN,INPUT);
  
  if (Ethernet.begin(mac) == 0) {
      Serial.println("DHCP failed");
      } else {
  Serial.print("DHCP IP:");
  Serial.println(Ethernet.localIP());
  Udp.begin(localPort);
  Serial.println("Getting time from NTP");
  setTime(getNtpTime());  //Get time from NTP
  Serial.println("Updating RTC");
  RTC.set(now());       //Update RTC with time

      }
  
  client.setServer(mqttServer, 1883);
  client.setCallback(callback);   
  Serial.println("Setting sync to RTC");
  setSyncProvider(RTC.get);  // Set updates to come from RTC
  Serial.println("Setup complete");
}

time_t prevDisplay = 0; // when the digital clock was displayed
long oldPosition  = -999;
byte viewPage=1;


void loop()
{  
 // delay(50);
  //Serial.println("Looping");
  long newPosition=myEnc.read();
  //Serial.println(newPosition);
  //delay(50);
  byte difference = (newPosition - oldPosition)/4;
  if (abs(difference) > 0) {
    oldPosition = newPosition;
    viewPage=viewPage+difference;

    if (viewPage>5) {
      viewPage=1;
    }
      if (viewPage<1) {
      viewPage=5;
    }
    
    displayPage(viewPage);
  }

  if (timeStatus() != timeNotSet) {
    if (now() > prevDisplay + 60) { //update the display only if time has changed
      Serial.println("60s elapsed");
      prevDisplay = now();
      /*if (!client.connected()) {
        Serial.println("reconnecting to mqtt...");
        reconnect();
      }*/
      displayPage(viewPage);    
    }
  }
  
  client.loop();   
  
}

void displayPage(byte viewPage) {
    switch (viewPage) {
    case 1:
      lcd.clear();
      displayTime(); 
      displayAlarm(); 
    
    break;
    case 2:
    {
    char temp[5] = "";
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Outdoors: ");


    //lcd.print(""); 
    //lcd.print("%RH");
    lcd.setCursor(19,0);
    lcd.print("2");
    httpGetValue("/rest/items/env_temp_outdoor/state", temp);
    Serial.print("Received from openHab: "); Serial.println(temp);
    lcd.setCursor(10,0);
    lcd.print(temp); 
    lcd.print(" F");
    //lcd.setCursor(0,1);
    //lcd.print("Indoors: ");
  //lcd.print(""); temp
    //lcd.print("F - ");
  //lcd.print(""); RH
    //lcd.print("%RH");
    }
    break;
    
    case 3:
    lcd.clear();
    lcd.print("page 3");

    break;
    case 4:
    lcd.clear();
    lcd.print("page 4");

    break;
    case 5:
    lcd.clear();
    lcd.print("page 5");

    break;
  }
}

char httpGetValue(char kPath[], char c[]) {
     int err =0;

 Serial.println(kPath);

  
  err = http.get(kHostname, kPath);
  if (err == 0)
  {
    Serial.println("startedRequest ok");

    err = http.responseStatusCode();
    if (err >= 0)
    {
      Serial.print("Got status code: ");
      Serial.println(err);

      // Usually you'd check that the response code is 200 or a
      // similar "success" code (200-299) before carrying on,
      // but we'll print out whatever response we get

      err = http.skipResponseHeaders();
      if (err >= 0)
      {
        int bodyLen = http.contentLength();
        //Serial.print("Content length is: ");
        //Serial.println(bodyLen);
        //Serial.println();
        //Serial.println("Body returned follows:");
      
        // Now we've got to the body, so we can print it out
        unsigned long timeoutStart = millis();
        int i = 0;
        // Whilst we haven't timed out & haven't reached the end of the body
        while ( (http.connected() || http.available()) &&
               ((millis() - timeoutStart) < kNetworkTimeout) )
        {
            if (http.available())
            {
                c[i] = http.read();
                i++;
                // Print out this character
                //Serial.print(c);
               
                bodyLen--;
                // We read something, reset the timeout counter
                timeoutStart = millis();
            }
            else
            {
                // We haven't got any data, so let's pause to allow some to
                // arrive
                delay(kNetworkDelay);
            }
        }
      }
      else
      {
        Serial.print("Failed to skip response headers: ");
        Serial.println(err);
      }
    }
    else
    {    
      Serial.print("Getting response failed: ");
      Serial.println(err);
    }
  }
  else
  {
    Serial.print("Connect failed: ");
    Serial.println(err);
  }
  http.stop();
  Serial.print("value: ");
  Serial.println(c);
 //eturn c;
}

void displayTime() {
    lcd.setCursor(0,0);
    if (hour()>12) {
       lcd.print(hour()-12);
    } else {
       lcd.print(hour());
    }
    lcd.print(":");
    if (minute()<10) {
      lcd.print("0");
    }
    lcd.print(minute());
     if (hour()>12) {
       lcd.print(" PM");
    } else {
       lcd.print(" AM");
    }
    lcd.setCursor(0,1);
    lcd.print(month());
    lcd.print("/");
    lcd.print(day());
    lcd.print("/");
    lcd.print(year());
} 

void displayAlarm() {
    lcd.setCursor(12,0);
    if (hour()>12) {
       lcd.print(hour()-12);
    } else {
       lcd.print(hour());
    }
    lcd.print(":");
    if (minute()<10) {
      lcd.print("0");
    }
    lcd.print(minute());
     if (hour()>12) {
       lcd.print(" PM");
    } else {
       lcd.print(" AM");
    }
} 



/*-------- NTP code ----------*/

const int NTP_PACKET_SIZE = 48; // NTP time is in the first 48 bytes of message
byte packetBuffer[NTP_PACKET_SIZE]; //buffer to hold incoming & outgoing packets

time_t getNtpTime()
{
  while (Udp.parsePacket() > 0) ; // discard any previously received packets
  //Serial.println("Transmit NTP Request");
  sendNTPpacket(ntpServer);
  uint32_t beginWait = millis();
  while (millis() - beginWait < 1500) {
    int size = Udp.parsePacket();
    if (size >= NTP_PACKET_SIZE) {
      //Serial.println("Receive NTP Response");
      Udp.read(packetBuffer, NTP_PACKET_SIZE);  // read packet into the buffer
      unsigned long secsSince1900;
      // convert four bytes starting at location 40 to a long integer
      secsSince1900 =  (unsigned long)packetBuffer[40] << 24;
      secsSince1900 |= (unsigned long)packetBuffer[41] << 16;
      secsSince1900 |= (unsigned long)packetBuffer[42] << 8;
      secsSince1900 |= (unsigned long)packetBuffer[43];
      return secsSince1900 - 2208988800UL + timeZone * SECS_PER_HOUR;
    }
  }
  Serial.println("No NTP Response :-(");
  return 0; // return 0 if unable to get the time
}

// send an NTP request to the time server at the given address
void sendNTPpacket(IPAddress &address)
{
  // set all bytes in the buffer to 0
  memset(packetBuffer, 0, NTP_PACKET_SIZE);
  // Initialize values needed to form NTP request
  // (see URL above for details on the packets)
  packetBuffer[0] = 0b11100011;   // LI, Version, Mode
  packetBuffer[1] = 0;     // Stratum, or type of clock
  packetBuffer[2] = 6;     // Polling Interval
  packetBuffer[3] = 0xEC;  // Peer Clock Precision
  // 8 bytes of zero for Root Delay & Root Dispersion
  packetBuffer[12]  = 49;
  packetBuffer[13]  = 0x4E;
  packetBuffer[14]  = 49;
  packetBuffer[15]  = 52;
  // all NTP fields have been given values, now
  // you can send a packet requesting a timestamp:                 
  Udp.beginPacket(address, 123); //NTP requests are to port 123
  Udp.write(packetBuffer, NTP_PACKET_SIZE);
  Udp.endPacket();
}


void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i=0;i<length;i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

void reconnect() {
  // Loop until we're reconnected

    Serial.print("Connecting to mqtt: ");
    // Attempt to connect
    if (client.connect("arduinoClient")) {
      Serial.println("done");
      // Once connected, publish an announcement...
      client.publish("AlarmClock","hello world");
      // ... and resubscribe
      client.subscribe("AlarmClock/In/#");
    } else {
      Serial.print("failed, rc=");
      Serial.println(client.state());   
    }
  }

