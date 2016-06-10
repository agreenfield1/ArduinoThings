EESchema Schematic File Version 2
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
LIBS:mylib
LIBS:sensorbreakouts-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
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
L +3V3 #PWR01
U 1 1 56D78E6E
P 3700 3200
F 0 "#PWR01" H 3700 3050 50  0001 C CNN
F 1 "+3V3" H 3700 3340 50  0000 C CNN
F 2 "" H 3700 3200 50  0000 C CNN
F 3 "" H 3700 3200 50  0000 C CNN
	1    3700 3200
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 P1
U 1 1 56D78E82
P 4050 3350
F 0 "P1" H 4050 3600 50  0000 C CNN
F 1 "CONN_01X04" V 4150 3350 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 4050 3350 50  0001 C CNN
F 3 "" H 4050 3350 50  0000 C CNN
	1    4050 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 56D78EC1
P 950 3300
F 0 "#PWR02" H 950 3050 50  0001 C CNN
F 1 "GND" H 950 3150 50  0000 C CNN
F 2 "" H 950 3300 50  0000 C CNN
F 3 "" H 950 3300 50  0000 C CNN
	1    950  3300
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 56D78EF4
P 1250 3100
F 0 "C2" H 1275 3200 50  0000 L CNN
F 1 "0.1uf" H 1275 3000 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 1288 2950 50  0001 C CNN
F 3 "" H 1250 3100 50  0000 C CNN
	1    1250 3100
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 56D78F59
P 950 3100
F 0 "C1" H 975 3200 50  0000 L CNN
F 1 "0.22uf" H 975 3000 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 988 2950 50  0001 C CNN
F 3 "" H 950 3100 50  0000 C CNN
	1    950  3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 3200 3850 3200
Connection ~ 950  2950
Connection ~ 950  3250
Text Label 3700 3400 0    60   ~ 0
SCL
Text Label 3700 3500 0    60   ~ 0
SDA
Wire Wire Line
	3850 3400 3700 3400
Wire Wire Line
	3850 3500 3700 3500
$Comp
L HIH9131 U1
U 1 1 56D7941D
P 2100 3100
F 0 "U1" H 1900 3400 60  0000 C CNN
F 1 "HIH9131" H 1900 3200 60  0000 C CNN
F 2 "Housings_SOIC:SOIC-8_3.9x4.9mm_Pitch1.27mm" H 1900 3400 60  0001 C CNN
F 3 "" H 1900 3400 60  0000 C CNN
	1    2100 3100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 56D79574
P 1250 3250
F 0 "#PWR03" H 1250 3000 50  0001 C CNN
F 1 "GND" H 1250 3100 50  0000 C CNN
F 2 "" H 1250 3250 50  0000 C CNN
F 3 "" H 1250 3250 50  0000 C CNN
	1    1250 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  3250 1450 3250
Wire Wire Line
	1250 2950 1450 2950
Wire Wire Line
	1450 2950 1450 3050
Connection ~ 1250 3250
Wire Wire Line
	950  2950 950  2900
Wire Wire Line
	950  2900 1450 2900
$Comp
L +3V3 #PWR04
U 1 1 56D79921
P 950 2900
F 0 "#PWR04" H 950 2750 50  0001 C CNN
F 1 "+3V3" H 950 3040 50  0000 C CNN
F 2 "" H 950 2900 50  0000 C CNN
F 3 "" H 950 2900 50  0000 C CNN
	1    950  2900
	1    0    0    -1  
$EndComp
Text Label 2350 2900 0    60   ~ 0
SCL
Text Label 2350 3150 0    60   ~ 0
SDA
$Comp
L GND #PWR05
U 1 1 56D79BD7
P 3550 3300
F 0 "#PWR05" H 3550 3050 50  0001 C CNN
F 1 "GND" H 3550 3150 50  0000 C CNN
F 2 "" H 3550 3300 50  0000 C CNN
F 3 "" H 3550 3300 50  0000 C CNN
	1    3550 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 3300 3850 3300
Wire Wire Line
	950  3250 950  3300
$EndSCHEMATC
