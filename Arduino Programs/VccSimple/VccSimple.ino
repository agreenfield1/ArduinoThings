#include <Vcc.h>

const float VccMin   = 2.7;           // Minimum expected Vcc level, in Volts.
const float VccMax   = 3.5;           // Maximum expected Vcc level, in Volts.
const float VccCorrection = 1.0/1.0;  // Measured Vcc by multimeter divided by reported Vcc

Vcc vcc(VccCorrection);

void setup()
{
  //Serial.begin(115200);
}

void loop()
{  
  float v = vcc.Read_Volts();
  Serial.print("VCC = ");
  Serial.print(v);
  Serial.println(" Volts");

  float p = vcc.Read_Perc(VccMin, VccMax);
  Serial.print("VCC = ");
  Serial.print(p);
  Serial.println(" %");

  delay(1000);
}
