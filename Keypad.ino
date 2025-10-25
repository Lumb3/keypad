#include "arduino_secrets.h"

#include <Keypad.h>
// Using UART protocol to connect with the FPGA
// We will use Arduino Uno R3 Expansion Header in the FPGA to establish the connection
const byte ROWS = 4;
const byte COLS = 4;
char keys[ROWS][COLS] =
{
  // Rows -> x ,  Columns -> y
  //2,  4,   7,   8
  {'1', '2', '3', 'A'}, // 10
  {'4', '5', '6', 'B'}, // 11
  {'7', '8', '9', 'C'}, // 12
  {'*', '0', '#', 'D'} // 13
};

byte colPins[COLS] = {10, 11, 12, 13}; // column PINS
byte rowPins[ROWS] = {2, 4, 7, 8}; // row PINS

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

const int signalPin; // Arduino pin connected to FPGA

void setup() {
  // put your setup code here, to run once:
  Serial.begin(4800);
  while(!Serial) {}
  delay(100);
}

void loop() {
  char key = keypad.getKey();  // stores the key in a single character form
  if (key) {
    Serial.write(key);  // Sends a single byte 'key' to the FPGA through Arduino TX (pin 1), RX (pin 0 GND)
    delay(1000);
    Serial.println(key);
  }
}
