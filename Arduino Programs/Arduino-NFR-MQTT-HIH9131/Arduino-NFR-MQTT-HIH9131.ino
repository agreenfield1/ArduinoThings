//#define DEBUG
//#define SOFTSPI
//#define MY_RADIO_NRF24
//#define RF24_CE_PIN 9
//#define RF24_CS_PIN 10

#define SENSORNODE 12 // edit node number
#define SENSORLOCATION "Outside"

#include <Wire.h>
#include <SPI.h>
#include <MySensor.h>  
#include <Vcc.h>

MySensor gw;
MyMessage msg0(0, V_TEMP);
MyMessage msg1(1, V_HUM);
MyMessage msg2(2, V_VOLTAGE);

const float VccMin   = 2.7;           // Minimum expected Vcc level, in Volts.
const float VccMax   = 3.5;           // Maximum expected Vcc level, in Volts.
const float VccCorrection = 1.0/1.0;  // Measured Vcc by multimeter divided by reported Vcc

Vcc vcc(VccCorrection);

unsigned long SLEEP_TIME = 30000; // Sleep time between reads (in milliseconds)

void setup() {
  gw.begin(NULL,SENSORNODE,0,AUTO);
  Wire.begin();        // join i2c bus (address optional for master)
 // Serial.begin(9600);  // start serial for output
  gw.sendSketchInfo("Temp+Humidity", "1.0");
  gw.present(0, S_TEMP, "Temp");
  gw.present(1, S_HUM, "Humidity");
  gw.present(2, S_MULTIMETER, "Battery Voltage");
}


void loop() {
  Wire.beginTransmission(39);
   Wire.endTransmission(); 
   gw.wait(30);
  Wire.requestFrom(39, 4);    // request 6 bytes from slave device #8

    byte a = Wire.read(); // receive a byte as character
    byte b = Wire.read();
    byte c = Wire.read();
    byte d = Wire.read();
    int bintemp = (unsigned int)c<<6|(unsigned int)d>>2;
    int binhumidity = (a&B00111111)<<8|(unsigned int)b;
    float f = (((bintemp/(pow(2,14)-2))*165-40)*1.8+32);
    float humid = binhumidity/(pow(2,14)-2)*100;
    Serial.println(f);  
    Serial.println(humid);
    
    Serial.println();
    gw.send(msg0.set(f,1));
    gw.send(msg1.set(humid,1));
    gw.send(msg2.set(vcc.Read_Volts(),3));
    gw.sleep(SLEEP_TIME); //sleep a bit
}
