#define DEBUG
//#define SOFTSPI
//#define MY_RADIO_NRF24
#define MY_RF24_CE_PIN 9
#define MY_RF24_CS_PIN 10
#include <Wire.h>
#include <SPI.h>
#include <MySensor.h>  
#define SENSORNODE 16 // edit node number
#define SENSORLOCATION "Upstairs Freezer"

#include "Adafruit_MCP9808.h"
Adafruit_MCP9808 tempsensor = Adafruit_MCP9808();

MySensor gw;
MyMessage msg0(0, V_TEMP);

unsigned long SLEEP_TIME = 30000; // Sleep time between reads (in milliseconds)

void setup()  
{ 
    gw.begin(NULL,SENSORNODE,0,AUTO);
  Wire.begin();        // join i2c bus (address optional for master)
  gw.sendSketchInfo(SENSORLOCATION, "1.0");
  gw.present(0, S_TEMP, SENSORLOCATION);
  
  if (!tempsensor.begin()) {
    Serial.println("Couldn't find MCP9808!");
    while (1);
  }


}


void loop()      
{  

 Serial.println("wake up MCP9808.... "); // wake up MSP9808 - power consumption ~200 mikro Ampere
  tempsensor.shutdown_wake(0);   // Don't remove this line! required before reading temp
  // Read and print out the temperature, then convert to *F
   delay(250);
  float c = tempsensor.readTempC();
  float f = c * 9.0 / 5.0 + 32;
  Serial.print("Temp: "); Serial.print(c); Serial.print("*C\t"); 
  Serial.print(f); Serial.println("*F");
  delay(250);
  Serial.println("Shutdown MCP9808.... ");
  tempsensor.shutdown_wake(1); 

       gw.send(msg0.set(f,1));

gw.sleep(SLEEP_TIME); //sleep a bit

    
}
