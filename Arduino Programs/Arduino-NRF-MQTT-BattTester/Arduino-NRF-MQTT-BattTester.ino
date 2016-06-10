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




#include <Vcc.h>
#include <SPI.h>
#include <MySensor.h>  

 
MySensor gw;
MyMessage msg0(0, V_VOLTAGE);



const float VccMin   = 2.7;           // Minimum expected Vcc level, in Volts.
const float VccMax   = 3.5;           // Maximum expected Vcc level, in Volts.
const float VccCorrection = 1.0/1.0;  // Measured Vcc by multimeter divided by reported Vcc

Vcc vcc(VccCorrection);


void setup()  
{ 
  gw.begin(NULL,99,0,AUTO);

  gw.sendSketchInfo("Voltage", "1.0");
  gw.present(0, S_MULTIMETER, "Indoor Temp");
 }


void loop()      
{  
    gw.send(msg0.set(vcc.Read_Volts(),2));
    //send(msgTemp.set(vcc.Read_Volts(), 2));
    delay(30000); //sleep a bit
}
