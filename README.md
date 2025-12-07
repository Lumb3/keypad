# Digital Keypad Access Lock System  
**Final Project – ECE 3700**

<p align="center">
  <img src="https://github.com/user-attachments/assets/7446bc23-4ab3-4b67-ad76-9b36b021b658" width="300"/>
</p>

## 📌 Purpose  
This project focuses on building a digital keypad-based encrypted lock system.  
Green and red LEDs act as indicators to show whether the user entered the correct password.

Although the original plan was to use an Arduino (since the 4×4 keypad is commonly designed for it), we were able to take input directly from the FPGA. Thanks to Prof. Benoit’s guidance, we used the fact that each key in the keypad contains a simple switch that connects a row and column when pressed.

---

## 🔍 How the Keypad Works  
We used **column-wise scanning**, where:

- **Columns (C1–C4)** → set as *outputs*  
- **Rows (R1–R4)** → set as *inputs*

When a user presses a key, the switch inside closes, connecting one row to one column.  
We detect that connection and convert it to the correct key value inside **Project.v**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/4401702b-0873-46c3-8f4e-c9a718070aa7" width="350"/>
</p>

---

## ⚙️ System Implementation  
A 1 second delay was required between successive inputs so the FPGA could correctly process each key press. Once implemented, the system behaved exactly as intended.

### Circuit Setup  
<p align="center">
  <img src="https://github.com/user-attachments/assets/4089c8bf-16af-431b-a77f-369f098a8bca" width="350"/>
</p>

---

## 🚀 Future Improvements  
There are several ways this project could be expanded:

- Add more output indicators (e.g., buzzer or display screen)  
- Implement multiple password modes  
- Add lockout timers after incorrect attempts  
- Enhance debouncing and timing models  

This project has been handed over to **Prof. Bhutta** so future students can continue building on it.

---

If you want, I can also help you clean up your **Project.v** file, add a block diagram, or generate an explanation GIF for scanning.
