#include <Keypad.h>

// UART connection: Arduino Uno <-> FPGA via TX (pin 1) and RX (pin 0)

const byte ROWS = 4;
const byte COLS = 4;

const char keys[ROWS][COLS] = {
  { '1', '2', '3', 'A' }, // 10 COLS
  { '4', '5', '6', 'B' }, // 11
  { '7', '8', '9', 'C' }, // 12
  { '*', '0', '#', 'D' } // 13
  // 2.   4.  7.   8 ROWS
};

byte rowPins[ROWS] = { 2, 4, 7, 8 };      // Bosoo (Yellow wires)
byte colPins[COLS] = { 10, 11, 12, 13 };  // Hevtee (Red wires)

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  Serial.begin(9600);          // Faster communication speed
  keypad.setDebounceTime(50);  // Debounce delay (prevents double key reads)
}

void loop() {
  char key = keypad.getKey();  // Check for pressed key
  int keyInt;
  if (key) {  // If any key is pressed
    if (key >= '0' && key <= '9') {
      keyInt = key - '0';   // Converting the character type data into integer
      //Serial.write(keyInt);    // Send the key to FPGA through UART (Digital Output PIN: 1, Orange Wire)
      Serial.print("Sent: ");
      Serial.println(keyInt);
    }
  }
}
