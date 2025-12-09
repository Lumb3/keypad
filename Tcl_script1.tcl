#============================================================
# FPGA assignments
#============================================================

set_global_assignment -name FAMILY "MAX 10 FPGA"
set_global_assignment -name DEVICE 10M50DAF484C7G
set_global_assignment -name TOP_LEVEL_ENTITY finalproject

#============================================================
# CLOCK
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLK
set_location_assignment PIN_P11 -to CLK

#============================================================
# RESET
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
# HEX0 Display
#============================================================
foreach i {0 1 2 3 4 5 6 7} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[$i]
}

set_location_assignment PIN_C14 -to HEX0[0]
set_location_assignment PIN_E15 -to HEX0[1]
set_location_assignment PIN_C15 -to HEX0[2]
set_location_assignment PIN_C16 -to HEX0[3]
set_location_assignment PIN_E16 -to HEX0[4]
set_location_assignment PIN_D17 -to HEX0[5]
set_location_assignment PIN_C17 -to HEX0[6]
set_location_assignment PIN_D15 -to HEX0[7]

#============================================================
# HEX1 Display
#============================================================
foreach i {0 1 2 3 4 5 6 7} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[$i]
}

set_location_assignment PIN_C18 -to HEX1[0]
set_location_assignment PIN_D18 -to HEX1[1]
set_location_assignment PIN_E18 -to HEX1[2]
set_location_assignment PIN_B16 -to HEX1[3]
set_location_assignment PIN_A17 -to HEX1[4]
set_location_assignment PIN_A18 -to HEX1[5]
set_location_assignment PIN_B17 -to HEX1[6]
set_location_assignment PIN_A16 -to HEX1[7]

#============================================================
# HEX2 Display
#============================================================
foreach i {0 1 2 3 4 5 6 7} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[$i]
}

set_location_assignment PIN_B20 -to HEX2[0]
set_location_assignment PIN_A20 -to HEX2[1]
set_location_assignment PIN_B19 -to HEX2[2]
set_location_assignment PIN_A21 -to HEX2[3]
set_location_assignment PIN_B21 -to HEX2[4]
set_location_assignment PIN_C22 -to HEX2[5]
set_location_assignment PIN_B22 -to HEX2[6]
set_location_assignment PIN_A19 -to HEX2[7]

#============================================================
# Keypad GPIOs
#============================================================
foreach i {0 1 2 3} {
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

#============================================================
# DBG Outputs - FIXED: Explicit pin assignments
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DBG[7]

set_location_assignment PIN_V10 -to DBG[0]
set_location_assignment PIN_V9  -to DBG[1]
set_location_assignment PIN_V8  -to DBG[2]
set_location_assignment PIN_V7  -to DBG[3]
set_location_assignment PIN_W10 -to DBG[4]
set_location_assignment PIN_W9  -to DBG[5]
set_location_assignment PIN_W8  -to DBG[6]
set_location_assignment PIN_W7  -to DBG[7]

#============================================================
# Compilation Settings
#============================================================
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
set_global_assignment -name ENABLE_OCT_DONE ON
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF

# Additional recommended settings for MAX 10
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"