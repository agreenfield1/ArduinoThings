#define DEBUG
//#define SOFTSPI
//#define MY_RADIO_NRF24
//#define MY_RF24_CE_PIN 6
//#define MY_RF24_CS_PIN 7

#define SENSORNODE 18 // edit node number
#define SENSORLOCATION "Basement"

#include <Wire.h>
#include <SPI.h>
#include <MySensor.h>  

MySensor gw;
MyMessage msg0(0, V_TEMP);
MyMessage msg1(1, V_HUM);

unsigned long SLEEP_TIME = 30000; // Sleep time between reads (in milliseconds)

void setup() {
  gw.begin(NULL,18,0,AUTO);
  Wire.begin();        // join i2c bus (address optional for master)
 // Serial.begin(9600);  // start serial for output
  gw.sendSketchInfo("Temp+Humidity", "1.0");
  gw.present(0, S_TEMP, "Indoor Temp");
  gw.present(1, S_HUM, "Indoor Humidity");
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
    gw.sleep(SLEEP_TIME); //sleep a bit
}
