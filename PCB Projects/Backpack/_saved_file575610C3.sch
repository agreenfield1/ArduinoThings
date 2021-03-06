EESchema Schematic File Version 2
LIBS:Backpack-rescue
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:ajglib
LIBS:Backpack-cache
LIBS:ProMiniBackplane-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ArduinoProMini U?
U 1 1 575611DB
P 5250 3450
F 0 "U?" H 5300 3250 60  0000 C CNN
F 1 "ArduinoProMini" H 5300 3500 60  0000 C CNN
F 2 "AJGFEET:ArduinoProMini" H 5550 3350 60  0000 C CNN
F 3 "" H 5550 3350 60  0000 C CNN
	1    5250 3450
	1    0    0    -1  
$EndComp
$Comp
L CONN_02X04 P?
U 1 1 575611DC
P 2800 4550
F 0 "P?" H 2800 4800 50  0000 C CNN
F 1 "CONN_02X04" H 2800 4300 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x04" H 2800 3350 50  0001 C CNN
F 3 "" H 2800 3350 50  0000 C CNN
	1    2800 4550
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 P?
U 1 1 575611DD
P 7600 4350
F 0 "P?" H 7600 4600 50  0000 C CNN
F 1 "CONN_01X04" V 7700 4350 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 7600 4350 50  0001 C CNN
F 3 "" H 7600 4350 50  0000 C CNN
	1    7600 4350
	1    0    0    -1  
$EndComp
$Comp
L C_Small C?
U 1 1 575611DE
P 6850 4300
F 0 "C?" H 6860 4370 50  0000 L CNN
F 1 "C_Small" H 6860 4220 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 6850 4300 50  0001 C CNN
F 3 "" H 6850 4300 50  0000 C CNN
	1    6850 4300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611DF
P 6850 4400
F 0 "#PWR?" H 6850 4150 50  0001 C CNN
F 1 "GND" H 6850 4250 50  0000 C CNN
F 2 "" H 6850 4400 50  0000 C CNN
F 3 "" H 6850 4400 50  0000 C CNN
	1    6850 4400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611E0
P 7000 4400
F 0 "#PWR?" H 7000 4150 50  0001 C CNN
F 1 "GND" H 7000 4250 50  0000 C CNN
F 2 "" H 7000 4400 50  0000 C CNN
F 3 "" H 7000 4400 50  0000 C CNN
	1    7000 4400
	1    0    0    -1  
$EndComp
Text Label 7250 4400 0    60   ~ 0
SCL
Text Label 7250 4500 0    60   ~ 0
SDA
Text Label 5050 5100 1    60   ~ 0
SCL
Text Label 4850 5100 1    60   ~ 0
SDA
$Comp
L R R?
U 1 1 575611E1
P 4700 5100
F 0 "R?" V 4780 5100 50  0000 C CNN
F 1 "R" V 4700 5100 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4630 5100 50  0001 C CNN
F 3 "" H 4700 5100 50  0000 C CNN
	1    4700 5100
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 575611E2
P 5150 5100
F 0 "R?" V 5230 5100 50  0000 C CNN
F 1 "R" V 5150 5100 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 5080 5100 50  0001 C CNN
F 3 "" H 5150 5100 50  0000 C CNN
	1    5150 5100
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR?
U 1 1 575611E3
P 4400 5250
F 0 "#PWR?" H 4400 5100 50  0001 C CNN
F 1 "VCC" H 4400 5400 50  0000 C CNN
F 2 "" H 4400 5250 50  0000 C CNN
F 3 "" H 4400 5250 50  0000 C CNN
	1    4400 5250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611E4
P 4450 3050
F 0 "#PWR?" H 4450 2800 50  0001 C CNN
F 1 "GND" H 4450 2900 50  0000 C CNN
F 2 "" H 4450 3050 50  0000 C CNN
F 3 "" H 4450 3050 50  0000 C CNN
	1    4450 3050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611E5
P 6050 2650
F 0 "#PWR?" H 6050 2400 50  0001 C CNN
F 1 "GND" H 6050 2500 50  0000 C CNN
F 2 "" H 6050 2650 50  0000 C CNN
F 3 "" H 6050 2650 50  0000 C CNN
	1    6050 2650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611E6
P 5250 4950
F 0 "#PWR?" H 5250 4700 50  0001 C CNN
F 1 "GND" H 5250 4800 50  0000 C CNN
F 2 "" H 5250 4950 50  0000 C CNN
F 3 "" H 5250 4950 50  0000 C CNN
	1    5250 4950
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR?
U 1 1 575611E7
P 6500 3050
F 0 "#PWR?" H 6500 2900 50  0001 C CNN
F 1 "VCC" H 6500 3200 50  0000 C CNN
F 2 "" H 6500 3050 50  0000 C CNN
F 3 "" H 6500 3050 50  0000 C CNN
	1    6500 3050
	1    0    0    -1  
$EndComp
$Comp
L C_Small C?
U 1 1 575611E8
P 6350 3150
F 0 "C?" H 6360 3220 50  0000 L CNN
F 1 "C_Small" H 6360 3070 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 6350 3150 50  0001 C CNN
F 3 "" H 6350 3150 50  0000 C CNN
	1    6350 3150
	1    0    0    -1  
$EndComp
$Comp
L C_Small C?
U 1 1 575611E9
P 6600 3150
F 0 "C?" H 6610 3220 50  0000 L CNN
F 1 "C_Small" H 6610 3070 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 6600 3150 50  0001 C CNN
F 3 "" H 6600 3150 50  0000 C CNN
	1    6600 3150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611EA
P 6500 3350
F 0 "#PWR?" H 6500 3100 50  0001 C CNN
F 1 "GND" H 6500 3200 50  0000 C CNN
F 2 "" H 6500 3350 50  0000 C CNN
F 3 "" H 6500 3350 50  0000 C CNN
	1    6500 3350
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR?
U 1 1 575611EB
P 6850 4200
F 0 "#PWR?" H 6850 4050 50  0001 C CNN
F 1 "VCC" H 6850 4350 50  0000 C CNN
F 2 "" H 6850 4200 50  0000 C CNN
F 3 "" H 6850 4200 50  0000 C CNN
	1    6850 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611EC
P 2150 4400
F 0 "#PWR?" H 2150 4150 50  0001 C CNN
F 1 "GND" H 2150 4250 50  0000 C CNN
F 2 "" H 2150 4400 50  0000 C CNN
F 3 "" H 2150 4400 50  0000 C CNN
	1    2150 4400
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR?
U 1 1 575611ED
P 3500 4400
F 0 "#PWR?" H 3500 4250 50  0001 C CNN
F 1 "VCC" H 3500 4550 50  0000 C CNN
F 2 "" H 3500 4400 50  0000 C CNN
F 3 "" H 3500 4400 50  0000 C CNN
	1    3500 4400
	1    0    0    -1  
$EndComp
$Comp
L C_Small C?
U 1 1 575611EE
P 3350 4500
F 0 "C?" H 3360 4570 50  0000 L CNN
F 1 "C_Small" H 3360 4420 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 3350 4500 50  0001 C CNN
F 3 "" H 3350 4500 50  0000 C CNN
	1    3350 4500
	1    0    0    -1  
$EndComp
$Comp
L C_Small C?
U 1 1 575611EF
P 3600 4500
F 0 "C?" H 3610 4570 50  0000 L CNN
F 1 "C_Small" H 3610 4420 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 3600 4500 50  0001 C CNN
F 3 "" H 3600 4500 50  0000 C CNN
	1    3600 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611F0
P 3500 4700
F 0 "#PWR?" H 3500 4450 50  0001 C CNN
F 1 "GND" H 3500 4550 50  0000 C CNN
F 2 "" H 3500 4700 50  0000 C CNN
F 3 "" H 3500 4700 50  0000 C CNN
	1    3500 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 4200 7400 4200
Wire Wire Line
	7400 4300 7000 4300
Wire Wire Line
	7000 4300 7000 4400
Wire Wire Line
	7400 4500 7250 4500
Wire Wire Line
	7400 4400 7250 4400
Wire Wire Line
	4850 4950 4850 5100
Wire Wire Line
	5050 4950 5050 5100
Wire Wire Line
	4400 5250 5150 5250
Connection ~ 4700 5250
Wire Wire Line
	4850 4950 4700 4950
Wire Wire Line
	5150 4950 5050 4950
Wire Wire Line
	6050 3050 6600 3050
Connection ~ 6350 3050
Connection ~ 6500 3050
Wire Wire Line
	6350 3250 6350 3350
Wire Wire Line
	6350 3350 6600 3350
Wire Wire Line
	6600 3350 6600 3250
Connection ~ 6500 3350
Wire Wire Line
	3050 4400 3600 4400
Connection ~ 3350 4400
Connection ~ 3500 4400
Wire Wire Line
	3350 4600 3350 4700
Wire Wire Line
	3350 4700 3600 4700
Wire Wire Line
	3600 4700 3600 4600
Connection ~ 3500 4700
Wire Wire Line
	2150 4400 2550 4400
Wire Wire Line
	3050 4500 3200 4500
Wire Wire Line
	3050 4600 3200 4600
Wire Wire Line
	3050 4700 3200 4700
Wire Wire Line
	2400 4700 2550 4700
Wire Wire Line
	2550 4600 2400 4600
Wire Wire Line
	2550 4500 2400 4500
Text Label 2400 4500 0    60   ~ 0
D9
Text Label 2400 4600 0    60   ~ 0
D13
Text Label 2400 4700 0    60   ~ 0
D12
Text Label 3100 4500 0    60   ~ 0
D10
Text Label 3100 4600 0    60   ~ 0
D11
Text Label 4200 3250 0    60   ~ 0
D2
Text Label 4250 4650 0    60   ~ 0
D9
Text Label 6050 4450 0    60   ~ 0
D11
Text Label 6050 4250 0    60   ~ 0
D12
Text Label 6050 4050 0    60   ~ 0
D13
Wire Wire Line
	4200 3250 4450 3250
Wire Wire Line
	4450 4650 4250 4650
$Comp
L CONN_01X04 P?
U 1 1 575611F1
P 7600 5050
F 0 "P?" H 7600 5300 50  0000 C CNN
F 1 "CONN_01X04" V 7700 5050 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 7600 5050 50  0001 C CNN
F 3 "" H 7600 5050 50  0000 C CNN
	1    7600 5050
	1    0    0    -1  
$EndComp
$Comp
L C_Small C?
U 1 1 575611F2
P 6850 5000
F 0 "C?" H 6860 5070 50  0000 L CNN
F 1 "C_Small" H 6860 4920 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 6850 5000 50  0001 C CNN
F 3 "" H 6850 5000 50  0000 C CNN
	1    6850 5000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611F3
P 6850 5100
F 0 "#PWR?" H 6850 4850 50  0001 C CNN
F 1 "GND" H 6850 4950 50  0000 C CNN
F 2 "" H 6850 5100 50  0000 C CNN
F 3 "" H 6850 5100 50  0000 C CNN
	1    6850 5100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611F4
P 7000 5100
F 0 "#PWR?" H 7000 4850 50  0001 C CNN
F 1 "GND" H 7000 4950 50  0000 C CNN
F 2 "" H 7000 5100 50  0000 C CNN
F 3 "" H 7000 5100 50  0000 C CNN
	1    7000 5100
	1    0    0    -1  
$EndComp
Text Label 7250 5100 0    60   ~ 0
SCL
Text Label 7250 5200 0    60   ~ 0
SDA
$Comp
L VCC #PWR?
U 1 1 575611F5
P 6850 4900
F 0 "#PWR?" H 6850 4750 50  0001 C CNN
F 1 "VCC" H 6850 5050 50  0000 C CNN
F 2 "" H 6850 4900 50  0000 C CNN
F 3 "" H 6850 4900 50  0000 C CNN
	1    6850 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 4900 7400 4900
Wire Wire Line
	7400 5000 7000 5000
Wire Wire Line
	7000 5000 7000 5100
Wire Wire Line
	7400 5200 7250 5200
Wire Wire Line
	7400 5100 7250 5100
$Comp
L Battery BT?
U 1 1 575611F6
P 2750 3050
F 0 "BT?" H 2850 3100 50  0000 L CNN
F 1 "Battery" H 2850 3000 50  0000 L CNN
F 2 "AJGFEET:CR123Holder" V 2750 3090 50  0001 C CNN
F 3 "" V 2750 3090 50  0000 C CNN
	1    2750 3050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 575611F7
P 2750 3200
F 0 "#PWR?" H 2750 2950 50  0001 C CNN
F 1 "GND" H 2750 3050 50  0000 C CNN
F 2 "" H 2750 3200 50  0000 C CNN
F 3 "" H 2750 3200 50  0000 C CNN
	1    2750 3200
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR?
U 1 1 575611F8
P 2750 2900
F 0 "#PWR?" H 2750 2750 50  0001 C CNN
F 1 "VCC" H 2750 3050 50  0000 C CNN
F 2 "" H 2750 2900 50  0000 C CNN
F 3 "" H 2750 2900 50  0000 C CNN
	1    2750 2900
	1    0    0    -1  
$EndComp
Text Label 6050 4650 0    60   ~ 0
D10
$EndSCHEMATC
