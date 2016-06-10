/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
int analogPins[6];
void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
 Serial.begin(9600);

 pinMode(A0,INPUT);
 pinMode(A1,INPUT);
 pinMode(A2,INPUT);
 pinMode(A3,INPUT);
 pinMode(A4,INPUT);
 pinMode(A5,INPUT);
 
 
 
 
 }

void loop() {
 
 analogPins[0]=analogRead(A0);
  analogPins[1]=analogRead(A1);
   analogPins[2]=analogRead(A2);
    analogPins[3]=analogRead(A3);
     analogPins[4]=analogRead(A4);
      analogPins[5]=analogRead(A5);
      Serial.print(analogPins[0],DEC);Serial.print("  ");
        Serial.print(analogPins[1],DEC);Serial.print("  ");
          Serial.print(analogPins[2],DEC);Serial.print("  ");
            Serial.print(analogPins[3],DEC);Serial.print("  ");
              Serial.print(analogPins[4],DEC);Serial.print("  ");
                Serial.print(analogPins[5],DEC);Serial.print("  ");
                Serial.println();
                delay(100);
}
