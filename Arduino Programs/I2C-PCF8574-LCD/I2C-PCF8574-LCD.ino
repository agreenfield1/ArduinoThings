/* Demonstration sketch for PCF8574T I2C LCD Backpack 
Uses library from https://bitbucket.org/fmalpartida/new-liquidcrystal/downloads GNU General Public License, version 3 (GPL-3.0) */
#include <Wire.h>
#include <LCD.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C  lcd(0x27,2,1,0,4,5,6,7); // 0x27 is the I2C bus address for an unmodified backpack

void setup()
{
  // activate LCD module
  lcd.begin (20,2); // for 16 x 2 LCD module
  lcd.setBacklightPin(3,POSITIVE);
  lcd.setBacklight(HIGH);
}

void loop()
{
  lcd.home (); // set cursor to 0,0

  lcd.print(" tronixlabs.com"); 
  //lcd.setCursor (0,1);        // go to start of 2nd line
   // lcd.print("1234");
    //delay(50);
  //lcd.print(" 3456");
  delay(500);
}
