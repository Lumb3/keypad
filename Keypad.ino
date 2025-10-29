#include <Keypad.h>

// UART connection: Arduino Uno <-> FPGA via TX (pin 1) and RX (pin 0)

const byte ROWS = 4;
const byte COLS = 4;

const char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

byte rowPins[ROWS] = {2, 4, 7, 8};
byte colPins[COLS] = {10, 11, 12, 13};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  Serial.begin(9600);           // Faster communication speed
  keypad.setDebounceTime(50);   // Debounce delay (prevents double key reads)
}

void loop() {
  char key = keypad.getKey();   // Check for pressed key

  if (key) {                    // If any key is pressed
    Serial.write(key);          // Send the key to FPGA through UART
    Serial.println(key);        // (Optional) Print for debugging
  }
}
