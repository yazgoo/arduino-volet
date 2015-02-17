#include "Arduino.h"

/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
/* 4 is up, 2 is down, high is on */
int led = 2;

void any(int up, int down)
{
  pinMode(4, OUTPUT);
  pinMode(2, OUTPUT);
  digitalWrite(4, up);
  digitalWrite(2, down);
}
void up()
{
  any(HIGH, LOW);
}
void down()
{
  any(LOW, HIGH);
}
void stop()
{
  any(LOW, LOW);
}


void setup() {                
    Serial.begin(115200);
    Serial.println("startup");
    stop();
}

void loop() {
     if (Serial.available())
     {
         int c = Serial.read();
         if(c == 'd') down();
         else if(c == 'u') up();
         else if(c == 's') stop();
         Serial.println("a " + c);
     }
}
