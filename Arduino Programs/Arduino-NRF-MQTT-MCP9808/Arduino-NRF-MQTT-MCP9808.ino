//#define DEBUG
//#define SOFTSPI
//#define MY_RADIO_NRF24
#define MY_RF24_CE_PIN 9
#define MY_RF24_CS_PIN 10
#include <Wire.h>
#include <SPI.h>
#include <Streaming.h>
#include <MySensor.h>  
#include <Vcc.h>

#define SENSORNODE 16 // edit node number
#define SENSORLOCATION "Upstairs Freezer"

#include <MCP9808.h>      //http://github.com/JChristensen/MCP9808

//#include "Adafruit_MCP9808.h"
//
MCP9808 myTempSensor(0);

MySensor gw;
MyMessage msg0(0, V_TEMP);
MyMessage msg1(1, V_VOLTAGE);

const float VccMin   = 2.7;           // Minimum expected Vcc level, in Volts.
const float VccMax   = 3.5;           // Maximum expected Vcc level, in Volts.
const float VccCorrection = 1.0/1.0;  // Measured Vcc by multimeter divided by reported Vcc

Vcc vcc(VccCorrection);

unsigned long SLEEP_TIME = 29500; // Sleep time between reads (in milliseconds)

void setup()  
{ 
  delay(500);
  gw.begin(NULL,SENSORNODE,0,AUTO);
  Wire.begin();        // join i2c bus (address optional for master)
  gw.sendSketchInfo(SENSORLOCATION, "1.0");
  gw.present(0, S_TEMP, SENSORLOCATION);
  gw.present(1, S_MULTIMETER, SENSORLOCATION);
   uint8_t status = myTempSensor.begin();
    if ( status != 0 )
    {
        Serial << "Error reading sensor, status=" << status << endl;
        Serial.flush();
        while (1);                      //loop until reset
    }

}


void loop()      
{  

    float C, F;
    uint8_t status;
 
    
    
    if ( (status = myTempSensor.read()) == 0 )
    {
        C = myTempSensor.tAmbient / 16.0;
        F = C * 9.0 / 5.0 + 32.0;
        Serial << F("Ambient\t\t") << C << F("C\t") << F << F("F\n");
        Serial << F("Config 0x") << _HEX(myTempSensor.config) << F(" Resolution 0x") << _HEX(myTempSensor.resolution) << endl;
        Serial << F("Mfr ID 0x") << _HEX(myTempSensor.mfrID) << F( " Device ID 0x") << _HEX(myTempSensor.deviceID) << F( " Device Rev 0x") << _HEX(myTempSensor.deviceRev) << endl;
        
    }
    else
    {
        Serial << "Error reading sensor, status=" << status << endl;
    }

      gw.send(msg0.set(F,1));
      gw.send(msg1.set(vcc.Read_Volts(),3));
      
      myTempSensor.config = 256;  //Shutdown
      myTempSensor.write();  
      gw.sleep(SLEEP_TIME); //sleep a bit
      myTempSensor.config = 0;  //Wake
      myTempSensor.write(); 
      gw.sleep(500); //wait for conversion 
    
}
