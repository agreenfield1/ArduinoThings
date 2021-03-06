EESchema Schematic File Version 2
LIBS:MS56110 Breakout-rescue
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
LIBS:MS56110 Breakout-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "zondag 28 september 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_01X04 P1
U 1 1 56FF05CC
P 5050 3600
F 0 "P1" H 5050 3850 50  0000 C CNN
F 1 "CONN_01X04" V 5150 3600 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 5050 3600 50  0001 C CNN
F 3 "" H 5050 3600 50  0000 C CNN
	1    5050 3600
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR01
U 1 1 56FF05FB
P 4750 3450
F 0 "#PWR01" H 4750 3300 50  0001 C CNN
F 1 "+3V3" H 4750 3590 50  0000 C CNN
F 2 "" H 4750 3450 50  0000 C CNN
F 3 "" H 4750 3450 50  0000 C CNN
	1    4750 3450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 56FF0613
P 4300 3550
F 0 "#PWR02" H 4300 3300 50  0001 C CNN
F 1 "GND" H 4300 3400 50  0000 C CNN
F 2 "" H 4300 3550 50  0000 C CNN
F 3 "" H 4300 3550 50  0000 C CNN
	1    4300 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 3450 4850 3450
Wire Wire Line
	4850 3550 4300 3550
Wire Wire Line
	4850 3650 4600 3650
Wire Wire Line
	4850 3750 4600 3750
Text Label 4600 3650 0    60   ~ 0
SCL
Text Label 4600 3750 0    60   ~ 0
SDA
$Comp
L MS56110 U1
U 1 1 56FF0805
P 4900 2600
F 0 "U1" H 4900 2750 60  0000 C CNN
F 1 "MS56110" H 4900 2950 60  0000 C CNN
F 2 "AJGFEET:MS56110-QFN" H 4900 2600 60  0001 C CNN
F 3 "" H 4900 2600 60  0000 C CNN
	1    4900 2600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 56FF0842
P 4350 2850
F 0 "#PWR03" H 4350 2600 50  0001 C CNN
F 1 "GND" H 4350 2700 50  0000 C CNN
F 2 "" H 4350 2850 50  0000 C CNN
F 3 "" H 4350 2850 50  0000 C CNN
	1    4350 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 2750 5700 2750
Wire Wire Line
	5500 2450 5700 2450
Text Label 5700 2450 0    60   ~ 0
SDA
Text Label 5700 2750 0    60   ~ 0
SCL
$Comp
L C C1
U 1 1 56FF087C
P 3950 2700
F 0 "C1" H 3975 2800 50  0000 L CNN
F 1 "0.1uf" H 3975 2600 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 3988 2550 50  0001 C CNN
F 3 "" H 3950 2700 50  0000 C CNN
	1    3950 2700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 56FF0902
P 3950 2850
F 0 "#PWR04" H 3950 2600 50  0001 C CNN
F 1 "GND" H 3950 2700 50  0000 C CNN
F 2 "" H 3950 2850 50  0000 C CNN
F 3 "" H 3950 2850 50  0000 C CNN
	1    3950 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 2550 3950 2550
$Comp
L +3V3 #PWR05
U 1 1 56FF0920
P 3950 2550
F 0 "#PWR05" H 3950 2400 50  0001 C CNN
F 1 "+3V3" H 3950 2690 50  0000 C CNN
F 2 "" H 3950 2550 50  0000 C CNN
F 3 "" H 3950 2550 50  0000 C CNN
	1    3950 2550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 56FF0934
P 4250 2350
F 0 "#PWR06" H 4250 2100 50  0001 C CNN
F 1 "GND" H 4250 2200 50  0000 C CNN
F 2 "" H 4250 2350 50  0000 C CNN
F 3 "" H 4250 2350 50  0000 C CNN
	1    4250 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 2350 4350 2350
Wire Wire Line
	4350 2350 4350 2400
Wire Wire Line
	4350 2700 4350 2550
$EndSCHEMATC
