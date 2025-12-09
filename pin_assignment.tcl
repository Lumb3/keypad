#============================================================
# FPGA assignments
#============================================================

#set_global_assignment -name FAMILY "MAX 10 FPGA"
#set_global_assignment -name DEVICE 10M50DAF484C7G

#============================================================
# CLOCK
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLK
set_location_assignment PIN_P11 -to CLK

#============================================================
# PUSH BUTTONS
#============================================================

set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to RST_N
set_location_assignment PIN_B8 -to RST_N

#============================================================
# LEDS
#============================================================

foreach i {0 1 2 3 4 5 6 7 8 9} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDS[$i]
}

set_location_assignment PIN_A8  -to LEDS[0]
set_location_assignment PIN_A9  -to LEDS[1]
set_location_assignment PIN_A10 -to LEDS[2]
set_location_assignment PIN_B10 -to LEDS[3]
set_location_assignment PIN_D13 -to LEDS[4]
set_location_assignment PIN_C13 -to LEDS[5]
set_location_assignment PIN_E14 -to LEDS[6]
set_location_assignment PIN_D14 -to LEDS[7]
set_location_assignment PIN_A11 -to LEDS[8]
set_location_assignment PIN_B11 -to LEDS[9]

#============================================================
# 7-Segment Display
#============================================================

foreach i {0 1 2 3 4 5 6 7} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[$i]
}

set_location_assignment PIN_C18 -to HEX0[0]
set_location_assignment PIN_D18 -to HEX0[1]
set_location_assignment PIN_E18 -to HEX0[2]
set_location_assignment PIN_B16 -to HEX0[3]
set_location_assignment PIN_A17 -to HEX0[4]
set_location_assignment PIN_A18 -to HEX0[5]
set_location_assignment PIN_B17 -to HEX0[6]
set_location_assignment PIN_A16 -to HEX0[7]

#============================================================
# GPIOs
#============================================================

foreach i {0 1 2 3 } {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COLS[$i]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ROWS[$i]
    set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON  -to ROWS[$i]
}

set_location_assignment PIN_AA15 -to ROWS[0]
set_location_assignment PIN_W13  -to ROWS[1]
set_location_assignment PIN_AB13 -to ROWS[2]
set_location_assignment PIN_Y11  -to ROWS[3]
set_location_assignment PIN_W11  -to COLS[0]
set_location_assignment PIN_AA10 -to COLS[1]
set_location_assignment PIN_Y8   -to COLS[2]
set_location_assignment PIN_Y7   -to COLS[3]


# Assign locations by iterating over both index and pin
set idx 0
foreach pin {PIN_V10 PIN_V9 PIN_V8 PIN_V7 PIN_W10 PIN_W9 PIN_W8 PIN_W7} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[$idx]
    set_location_assignment $pin -to DBG[$idx]
    incr idx
}


# LED Output
set_location_assignment PIN_AA2 -to p1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to p1

set_location_assignment PIN_Y3 -to p2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to p2


