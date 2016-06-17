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
LIBS:ajglib
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
L Led_Small D?
U 1 1 57609A3D
P 4600 2550
F 0 "D?" H 4550 2675 50  0001 L CNN
F 1 "Led_Small" H 4425 2450 50  0001 L CNN
F 2 "" V 4600 2550 50  0000 C CNN
F 3 "" V 4600 2550 50  0000 C CNN
	1    4600 2550
	0    -1   -1   0   
$EndComp
$Comp
L Led_Small D?
U 1 1 57609AE9
P 4600 2750
F 0 "D?" H 4550 2875 50  0001 L CNN
F 1 "Led_Small" H 4425 2650 50  0001 L CNN
F 2 "" V 4600 2750 50  0000 C CNN
F 3 "" V 4600 2750 50  0000 C CNN
	1    4600 2750
	0    -1   -1   0   
$EndComp
$Comp
L Led_Small D?
U 1 1 57609AF4
P 4600 2950
F 0 "D?" H 4550 3075 50  0001 L CNN
F 1 "Led_Small" H 4425 2850 50  0001 L CNN
F 2 "" V 4600 2950 50  0000 C CNN
F 3 "" V 4600 2950 50  0000 C CNN
	1    4600 2950
	0    -1   -1   0   
$EndComp
$Comp
L Q_NMOS_DGS Q?
U 1 1 57609B01
P 4700 3300
F 0 "Q?" H 5000 3350 50  0001 R CNN
F 1 "Q_NMOS_DGS" H 5350 3250 50  0001 R CNN
F 2 "" H 4900 3400 50  0000 C CNN
F 3 "" H 4700 3300 50  0000 C CNN
	1    4700 3300
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4600 3100 4600 3050
$Comp
L GND #PWR?
U 1 1 57609B4A
P 4600 3600
F 0 "#PWR?" H 4600 3350 50  0001 C CNN
F 1 "GND" H 4600 3450 50  0000 C CNN
F 2 "" H 4600 3600 50  0000 C CNN
F 3 "" H 4600 3600 50  0000 C CNN
	1    4600 3600
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR?
U 1 1 57609B95
P 4600 2350
F 0 "#PWR?" H 4600 2200 50  0001 C CNN
F 1 "+24V" H 4600 2490 50  0000 C CNN
F 2 "" H 4600 2350 50  0000 C CNN
F 3 "" H 4600 2350 50  0000 C CNN
	1    4600 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 2450 4600 2350
Wire Wire Line
	4900 3300 5150 3300
Text Label 5000 3300 0    60   ~ 0
PWM
$Comp
L MP2359-BuckReg U?
U 1 1 57609BBA
P 6100 2450
F 0 "U?" H 6100 2350 60  0000 C CNN
F 1 "MP2359 Buck Regulator" H 6100 2700 60  0000 C CNN
F 2 "" H 5900 2400 60  0000 C CNN
F 3 "" H 5900 2400 60  0000 C CNN
	1    6100 2450
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 57609BF7
P 5350 2550
F 0 "C?" H 5375 2650 50  0001 L CNN
F 1 "10uF" H 5050 2550 50  0000 L CNN
F 2 "" H 5388 2400 50  0000 C CNN
F 3 "" H 5350 2550 50  0000 C CNN
	1    5350 2550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 57609C5B
P 5350 2700
F 0 "#PWR?" H 5350 2450 50  0001 C CNN
F 1 "GND" H 5350 2550 50  0000 C CNN
F 2 "" H 5350 2700 50  0000 C CNN
F 3 "" H 5350 2700 50  0000 C CNN
	1    5350 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 2400 5600 2400
Connection ~ 4600 2400
Connection ~ 5350 2400
Wire Wire Line
	4600 3600 4600 3500
Wire Notes Line
	5000 2450 5550 2450
Wire Notes Line
	5000 2450 5000 2700
Wire Notes Line
	5000 2700 5550 2700
Wire Notes Line
	5550 2700 5550 2450
Wire Notes Line
	5000 2450 4700 1900
Text Notes 4250 1900 0    60   ~ 0
Noise during PWM
Text Notes 4500 3000 1    60   ~ 0
LED String
$EndSCHEMATC
