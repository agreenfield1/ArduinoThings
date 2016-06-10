/*
 Basic MQTT example

 This sketch demonstrates the basic capabilities of the library.
 It connects to an MQTT server then:
  - publishes "hello world" to the topic "outTopic"
  - subscribes to the topic "inTopic", printing out any messages
    it receives. NB - it assumes the received payloads are strings not binary

 It will reconnect to the server if the connection is lost using a blocking
 reconnect function. See the 'mqtt_reconnect_nonblocking' example for how to
 achieve the same result without blocking the main loop.
 
*/
#include <Wire.h>
#include "Adafruit_MCP9808.h"
#include <SPI.h>
//#include <Ethernet.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
Adafruit_MCP9808 tempsensor = Adafruit_MCP9808();

const char* ssid     = "ajghome2";
const char* password = "1atheist1";
char message_buffer[100];

IPAddress server(10, 20, 30, 8);

//int red=D3
//int blue=D5
//int green=D7


void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i=0;i<length;i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

//EthernetClient ethClient;
WiFiClient ethClient;
PubSubClient client(ethClient);

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("NodeMCU1")) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish("NodeMCU1-status","hello world");
      // ... and resubscribe
      client.subscribe("inTopic");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}



void setup()
{

  
  
  Serial.begin(9600);
  Serial.println("MCP9808 + WIFI + MQTT");
  client.setServer(server, 1883);
  client.setCallback(callback);

  //Ethernet.begin(mac, ip);
  // Allow the hardware to sort itself out

  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  delay(500);

    if (!tempsensor.begin()) {
    Serial.println("Couldn't find MCP9808!");
    while (1);
  }
  
}

void loop()
{
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  
  Serial.println("wake up MCP9808.... "); // wake up MSP9808 - power consumption ~200 mikro Ampere
  tempsensor.shutdown_wake(0);   // Don't remove this line! required before reading temp
  // Read and print out the temperature, then convert to *F
  float c = tempsensor.readTempC();
  float f = c * 9.0 / 5.0 + 32;
  Serial.print("Temp: "); Serial.print(c); Serial.print("*C\t"); 
  Serial.print(f); Serial.println("*F");
  client.publish("NodeMCU1-status",dtostrf(f, 5, 2, message_buffer));
  delay(250);
  Serial.println("Shutdown MCP9808.... ");
  tempsensor.shutdown_wake(1); // shutdown MSP9808 - power consumption ~0.1 mikro Ampere
  analogWrite(D3, 1);
  analogWrite(D5, 1);
  analogWrite(D7, 1023);
  delay(2000);
  analogWrite(D7, 512);
  delay(2000);
   analogWrite(D7, 255);
  delay(2000);
   analogWrite(D7, 1);
  delay(2000);
 // delay(59750);
}
