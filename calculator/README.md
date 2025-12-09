# FPGA Keypad Calculator – Final Project

This project is a **hardware-based calculator system** implemented in **Verilog** using the **Altera MAX 10 FPGA Development Board** and a **4×4 matrix keypad (Arduino keypad)** as input. The system performs **basic arithmetic operations between two 2-digit numbers** and displays a **2-digit result on 7-segment displays**.

This project was developed in collaboration with **Nana Ogawa**.

---

## 🧠 Project Overview

This calculator allows users to:
- Enter **two 2-digit operands** using a 4×4 keypad  
- Select one of four operations:
  - ➕ Addition (`+`)
  - ➖ Subtraction (`-`)
  - ✖️ Multiplication (`*`)
  - ➗ Division (`/`)
- Display:
  - Input digits during entry
  - Selected operation symbol
  - Final **2-digit result**
- Handle **division-by-zero errors**
- Reset the system using a dedicated reset key

All functionality is implemented fully in **Verilog**, including:
- Keypad scanning
- Debouncing
- Operand construction (2 digits only)
- Arithmetic execution
- 7-segment encoding and display control
- Status LEDs and debug outputs

---

## 🛠 Hardware Used

- **Altera MAX 10 FPGA Development Board**
- **4×4 Matrix Keypad (Arduino compatible)**
- Onboard:
  - 7-segment HEX displays
  - LEDs for system state indication

---

## ⚙️ Features

- ✅ Clock-based keypad scanning
- ✅ Debounced input detection
- ✅ Two-digit operand input only
- ✅ Supported operations: `+`, `-`, `*`, `/`
- ✅ Two-digit output display only
- ✅ Real-time digit preview
- ✅ Operation symbol display
- ✅ Division-by-zero protection
- ✅ 1-second input delay for stable user input
- ✅ Debug and state indicators using LEDs

---

## ▶️ Usage Guide (Quartus + FPGA Upload)

1. Open **Intel Quartus Prime**.
2. Create or open the project folder.
3. Go to **Device Setup** and select: `10M50DAF484C7G`
4. Run the following TCL setup script: `Tcl_script1.tcl`
5. Add and compile the **Verilog source file**: `finalproject.v`
6. Open **Programmer**.
7. Select the compiled output file.
8. **Upload the design to the FPGA board**.
9. Use the keypad to enter two 2-digit numbers, select an operation (`+ - * /`), and view the 2-digit result on the HEX display.

<img src="https://github.com/user-attachments/assets/05839987-3b56-43a6-b98c-b852bee607d6" width="400">


---

## 👥 Contributors

- **Erdembileg Ariunbold**
- **Nana Ogawa**

---

## 🎯 Purpose

This project was developed as a **digital systems / FPGA final project** to demonstrate:
- Real-time keypad interfacing
- State-based control logic in hardware
- Arithmetic processing using Verilog
- FPGA display control using 7-segment outputs
- Embedded system input/output integration

---
