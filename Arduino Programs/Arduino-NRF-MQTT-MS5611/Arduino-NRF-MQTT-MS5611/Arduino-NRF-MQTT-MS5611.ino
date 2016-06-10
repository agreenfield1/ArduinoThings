#define DEBUG
//#define SOFTSPI
//#define MY_RADIO_NRF24
#define MY_RF24_CE_PIN 9
#define MY_RF24_CS_PIN 10
#include <Wire.h>
#include <SPI.h>
#include <MySensor.h>  
#define SENSORNODE 19 // edit node number
#define SENSORLOCATION "Ambient Pressure"

#include <MS5611.h>
MS5611 ms5611;

MySensor gw;
MyMessage msg0(0, V_PRESSURE);

unsigned long SLEEP_TIME = 30000; // Sleep time between reads (in milliseconds)

void setup()  
{ 
    gw.begin(NULL,SENSORNODE,0,AUTO);
  Wire.begin();        // join i2c bus (address optional for master)
  gw.sendSketchInfo(SENSORLOCATION, "1.0");
  gw.present(0, S_BARO, SENSORLOCATION);
  
    // Initialize MS5611 sensor
  Serial.println("Initialize MS5611 Sensor");

  while(!ms5611.begin(MS5611_ULTRA_HIGH_RES))
  {
    Serial.println("Could not find a valid MS5611 sensor, check wiring!");
    delay(500);
  }
  checkSettings();
}


void checkSettings()
{
  Serial.print("Oversampling: ");
  Serial.println(ms5611.getOversampling());
}


void loop()      
{  
  double realTemperature2 = ms5611.readTemperature(true);
  long realPressure2 = ms5611.readPressure(true);
  
  float inchesmg = realPressure2 * 0.000295;
  
  gw.send(msg0.set(inchesmg,3));
  gw.sleep(SLEEP_TIME); //sleep a bit
   
}