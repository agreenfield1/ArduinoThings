/**
 * The MySensors Arduino library handles the wireless radio link and protocol
 * between your home built sensors/actuators and HA controller of choice.
 * The sensors forms a self healing radio network with optional repeaters. Each
 * repeater and gateway builds a routing tables in EEPROM which keeps track of the
 * network topology allowing messages to be routed to nodes.
 *
 * Created by Henrik Ekblad <henrik.ekblad@mysensors.org>
 * Copyright (C) 2013-2015 Sensnology AB
 * Full contributor list: https://github.com/mysensors/Arduino/graphs/contributors
 *
 * Documentation: http://www.mysensors.org
 * Support Forum: http://forum.mysensors.org
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 *******************************
 *
 * REVISION HISTORY
 * Version 1.0 - Henrik EKblad
 * 
 * DESCRIPTION
 * This sketch provides an example how to implement a humidity/temperature
 * sensor using DHT11/DHT-22 
 * http://www.mysensors.org/build/humidity
 */
 
// Enable debug prints
#define MY_DEBUG

// Enable and select radio type attached
#define MY_RADIO_NRF24
//#define MY_W5100_SPI_EN 4  

//#if !defined(MY_W5100_SPI_EN) && !defined(ARDUINO_ARCH_SAMD)
// #define MY_SOFTSPI
  //#define MY_SOFT_SPI_SCK_PIN 13
 // #define MY_SOFT_SPI_MISO_PIN 12
//  #define MY_SOFT_SPI_MOSI_PIN 11
//#endif  
//#define MY_RF24_CE_PIN 5
//#define MY_RF24_CS_PIN 6


#include <Wire.h>
#include "Adafruit_MCP9808.h"
Adafruit_MCP9808 tempsensor = Adafruit_MCP9808();


#include <SPI.h>
#include <MySensor.h>  

  float temperature = 55;  
#define CHILD_ID_TEMP 0
MyMessage msgTemp(CHILD_ID_TEMP, V_TEMP);

unsigned long SLEEP_TIME = 10000; // Sleep time between reads (in milliseconds)


void setup()  
{ 
//msgTemp.begin(NULL, 10);
}

void presentation()  
{ 
  // Send the Sketch Version Information to the Gateway
  sendSketchInfo("Humidity", "1.0");

  present(CHILD_ID_TEMP, S_TEMP);
}

void loop()      
{  

 Serial.println("wake up MCP9808.... "); // wake up MSP9808 - power consumption ~200 mikro Ampere
  tempsensor.shutdown_wake(0);   // Don't remove this line! required before reading temp
  // Read and print out the temperature, then convert to *F
  float c = tempsensor.readTempC();
  float f = c * 9.0 / 5.0 + 32;
  Serial.print("Temp: "); Serial.print(c); Serial.print("*C\t"); 
  Serial.print(f); Serial.println("*F");
  delay(250);
  Serial.println("Shutdown MCP9808.... ");
  tempsensor.shutdown_wake(1); 

 
    send(msgTemp.set(f, 1));
    Serial.print("T: ");
    Serial.println(temperature);
    sleep(SLEEP_TIME); //sleep a bit
}
