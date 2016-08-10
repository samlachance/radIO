
#include <LiquidCrystal.h>

LiquidCrystal lcd(7,6,5,4,3,2);
int led = 12;
int btn = 11;
String inputString = "";
boolean stringComplete = false;
String firstLine;
String secondLine;

void setup() {                
  pinMode(led, OUTPUT);
  pinMode(btn, INPUT);
  lcd.begin(16, 2);
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Welcome to radIO");
  lcd.setCursor(0,1);
  lcd.print("-Start radIO.rb-");
  Serial.begin(9600);  
}



void loop() {
  int currentButtonState = digitalRead(btn);
  if (currentButtonState == LOW){ 
    digitalWrite(led, HIGH);
    Serial.println("fuck");
    delay(200);
  } else {
    digitalWrite(led, LOW);
  }
  
  if (stringComplete) {
    lcd.setCursor(0,0);
    lcd.print(inputString);
    lcd.setCursor(0,1);
    lcd.print(secondLine);
    inputString = "";
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    inputString += inChar;
    firstLine = inputString.substring(0,16);
    secondLine = inputString.substring(16,33);    
    
    if (inChar == '\n') {
      stringComplete = true;
    }
  }
}
