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

#define mqttTopic "Kitchen/Lights/Strip"
#define device "WemosD1Mini-4"

/*
 * Kitchen/Lights/Strip WemosD1Mini-4
 * Bedroom/Lights/Strip WemosD1Mini-3
 * Bedroom/Lights/Strip2 WemosD1Mini-2
 * Office/Lights/Strip WemosD1Mini-1
 */
#define ledRedPin D6 
#define ledGreenPin D7
#define ledBluePin D5

#include <ESP8266WiFi.h>
#include <PubSubClient.h>

const char* ssid     = "ajghome2";
const char* password = "1atheist1";
char message_buffer[100];

IPAddress server(10, 20, 30, 8);

int redLevel = 0;          
int blueLevel = 0;        
int greenLevel = 0;        


int pwmFreq = 1000; //hertz
int strobePercentOn = 1; 0-10000
int strobeFreq = 1; //hertz
int strobeEnable = 0; // 0 or 1

int updateCount = 0;

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived  -  ");
  Serial.print(topic);
  Serial.print(": ");

   payload[length] = '\0';
   String value = String((char*)payload);
   Serial.println(value);

    if(String(topic) == (mqttTopic "/level")) {         //Format: R;G;B

      if (value == "OFF") {
        redLevel=0;
        greenLevel=0;
        blueLevel=0;
      } else if (value == "ON") {
        redLevel=1024;
        greenLevel=1024;
        blueLevel=1024;
      }
        else {

          redLevel = value.substring(0,value.indexOf(';')).toInt();
          greenLevel = value.substring(value.indexOf(';')+1,value.lastIndexOf(';')).toInt();
          blueLevel = value.substring(value.lastIndexOf(';')+1).toInt();
      }
      analogWrite(ledRedPin,redLevel);
      analogWrite(ledGreenPin,greenLevel);
      analogWrite(ledBluePin,blueLevel);
      Serial.print("ledRedLevel: ");
      Serial.println(redLevel);
      Serial.print("ledGreenLevel: ");
      Serial.println(greenLevel);
      Serial.print("ledBlueLevel: ");
      Serial.println(blueLevel);
    }


   if(String(topic) == (mqttTopic "/freq")) {         
      pwmFreq=value.toInt();
      analogWriteFreq(pwmFreq); 
      Serial.print("pwmFreq: ");
      Serial.println(pwmFreq);
    }

     if(String(topic) == (String(mqttTopic) + String("/strobe"))) {       // Format: <0 or 1>;<on time in percent>;<freq in hz>
      strobeEnable = value.substring(0,value.indexOf(';')).toInt();
      strobePercentOn = value.substring(value.indexOf(';')+1,value.lastIndexOf(';')).toInt();
      strobeFreq = value.substring(value.lastIndexOf(';')+1).toInt();
//      analogWrite(ledPin,ledLevel);
      Serial.print("StrobeEnable: ");
      Serial.println(strobeEnable);
      Serial.print("StrobeOnTime: ");
      Serial.println(strobeOnTime);
      Serial.print("strobeFreq: ");
      Serial.println(strobeFreq);
    }  
}

//EthernetClient ethClient;
WiFiClient ethClient;
PubSubClient client(ethClient);

void reconnect() {
  // Loop until we're reconnected
  Serial.println("uhoh");
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect(device)) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish(mqttTopic,"Controller present");
      // ... and resubscribe
      client.subscribe(mqttTopic "/#");
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
  analogWriteFreq(pwmFreq);
  pinMode(ledRedPin, OUTPUT);
    pinMode(ledGreenPin, OUTPUT);
      pinMode(ledBluePin, OUTPUT);
  analogWrite(ledRedPin,0);
    analogWrite(ledGreenPin,0);
      analogWrite(ledBluePin,0);
  Serial.begin(9600);
  Serial.println("LED + WIFI + MQTT");
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
}

void loop()
{
  if (!client.connected()) {
    reconnect();
  }
  client.loop();



  if(strobeEnable==1) {
      digitalWrite(ledRedPin,1);
      digitalWrite(ledGreenPin,1);
      digitalWrite(ledBluePin,1);
      delayMicroseconds( ((1000000/strobefreq)*strobeOnTime/10000) ); //
      analogWrite(ledRedPin,0);
      analogWrite(ledGreenPin,0);
      analogWrite(ledBluePin,0);
      delayMicroseconds( (1000000/strobefreq) - (((1000000/strobefreq)*strobeOnTime)/10000) );
  }
}
