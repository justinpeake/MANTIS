#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

// GUItool: begin automatically generated code
AudioSynthWaveformSine   sine1;          //xy=308,398
AudioEffectEnvelope      envelope1;      //xy=622,400
AudioOutputI2S           i2s1;           //xy=1023,399
AudioConnection          patchCord1(sine1, envelope1);
AudioConnection          patchCord2(envelope1, 0, i2s1, 0);
AudioConnection          patchCord3(envelope1, 0, i2s1, 1);
AudioControlSGTL5000     sgtl5000_1;     //xy=635,711
// GUItool: end automatically generated code

// GUItool: end automatically generated code

int n;

float breath = 0;     
float heart = 0; 
float breathVol;
float previous=0;  // timer
float current=0;  // timer
int counter = 0;  // number of heart beats total
float intervalTime=0; // interval in ms between heart beats
float bpm=0; // heart rate in bpm
float aoc=0;  // amount of change in bpm / per beat
float prebpm=0; // previous bpm
float tminterval;
float tmprevious;
boolean tamer;


// THIS IS WORKING WELL WITH EASY PULSE




void setup() {

  AudioMemory(10);
  Serial.begin(115200);
  sgtl5000_1.enable();
  sgtl5000_1.volume(0.7);

}

void loop() {
heart = analogRead(3);

  if (heart > 240) {
    tminterval = millis() - tmprevious;
    tmprevious = millis();
  }

    if (tminterval > 250) {
    tamer = true;
  } else { 
    tamer = false;
  }

    if (heart > 240 && tamer) {
    counter ++;       // CHANGE TO CELLNUM
    intervalTime = millis() - previous;
    previous = millis();

    bpm = (60/intervalTime*1000);
    aoc =  abs(bpm - prebpm);
    prebpm = bpm;

    sine1.frequency(bpm);
    envelope1.noteOn();
    delay(500);
    envelope1.noteOff();

    Serial.print("(");
    Serial.print(counter);
     Serial.print(")");
     Serial.print("  ");
       Serial.print(intervalTime);
     Serial.print(", ");
       Serial.print(bpm);
     Serial.print(", ");
       Serial.print(aoc);
     Serial.print(", ");
       Serial.println(breathVol);
    
  }
//heartBeatData();

sine1.amplitude(.5);
//sine1.frequency(bpm);

//envelope1.noteOn();
//delay(500);
//envelope1.noteOff();
//delay(1000);

//Serial.println("hello");
}

//void heartBeatData() {
//  if (heart > 240) {
//    tminterval = millis() - tmprevious;
//    tmprevious = millis();
//  }
//
//  if (tminterval > 250) {
//    tamer = true;
//  } else { 
//    tamer = false;
//  }
//  if (heart > 240 && tamer) {
//    counter ++;       // CHANGE TO CELLNUM
//    interval1 = millis() - previous;
//    previous = millis();
//
//    bpm = (60/interval1*1000);
//    aoc =  abs(bpm - prebpm);
//    prebpm = bpm;
//
//   
//    Serial.println(counter, ",", interval1, ",", bpm, ",", aoc, ",", breathVol);
//  }
//}
