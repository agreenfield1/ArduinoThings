
#include <Wire.h>
#include "LowPower.h"

#include <MCP9808.h>      //http://github.com/JChristensen/MCP9808

MCP9808 myTempSensor(0);

void setup()  
{ 
  delay(500);
  Serial.begin(9600);
  Wire.begin();        // join i2c bus (address optional for master)
  uint8_t status = myTempSensor.begin();
   myTempSensor.config = 256;  //Shutdown
   myTempSensor.write();
}


void loop()      
{  
    LowPower.powerDown(SLEEP_8S, ADC_OFF, BOD_OFF);  
    
}
