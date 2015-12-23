

int heartPin = A0;	
int heart;

int breathPin = A1;
int breath;		



void setup()
{
  Serial.begin(115200);
}

void loop() {

  heart = analogRead(heartPin);
  // delay(10);
  breath = analogRead(breathPin);
  // delay(10);


    Serial.print(heart);
    Serial.print(" ");
  Serial.println(breath);
  //  Serial.print(",");
  //  Serial.println(analogRead(bluePin));
}


