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
LIBS:pmod
LIBS:ICET99-cache
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
L 74LS245 U2
U 1 1 5A6CB649
P 4000 1300
F 0 "U2" H 4000 1700 50  0000 L BNN
F 1 "74LVC245A" H 3950 900 50  0000 L TNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 4000 1300 50  0001 C CNN
F 3 "" H 4000 1300 50  0001 C CNN
	1    4000 1300
	1    0    0    -1  
$EndComp
Text Notes 3800 700  0    60   ~ 0
Signals
Text Notes 3700 6100 0    60   ~ 0
Data Bus
$Comp
L Conn_02x22_Odd_Even J1
U 1 1 5A6D1DC3
P 1450 6100
F 0 "J1" H 1500 7200 50  0000 C CNN
F 1 "Conn_02x22_Odd_Even" H 1500 4900 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_2x22_Pitch2.54mm" H 1450 6100 50  0001 C CNN
F 3 "" H 1450 6100 50  0001 C CNN
	1    1450 6100
	1    0    0    -1  
$EndComp
Text Label 1850 5100 0    60   ~ 0
SBE
Text Label 900  5100 0    60   ~ 0
PLUS5V
Text Label 900  5200 0    60   ~ 0
RESET*
Text Label 900  5300 0    60   ~ 0
A5
Text Label 900  5400 0    60   ~ 0
A4
Text Label 900  5500 0    60   ~ 0
DBIN
Text Label 900  5600 0    60   ~ 0
A12
Text Label 900  5700 0    60   ~ 0
LOAD*
Text Label 900  5800 0    60   ~ 0
A13
Text Label 900  5900 0    60   ~ 0
A7
Text Label 650  6000 0    60   ~ 0
A15/CRUOUT
Text Label 900  6100 0    60   ~ 0
GND
Text Label 900  6200 0    60   ~ 0
GND
Text Label 900  6300 0    60   ~ 0
GND
Text Label 900  6400 0    60   ~ 0
GND
Text Label 900  6500 0    60   ~ 0
A6
Text Label 900  6600 0    60   ~ 0
A0
Text Label 900  6700 0    60   ~ 0
CRUIN
Text Label 900  6800 0    60   ~ 0
D4
Text Label 900  6900 0    60   ~ 0
D0
Text Label 900  7000 0    60   ~ 0
D2
Text Label 900  7100 0    60   ~ 0
IAQ
Text Label 900  7200 0    60   ~ 0
MINUS5V
Text Label 1850 5200 0    60   ~ 0
EXTINT*
Text Label 1850 5300 0    60   ~ 0
A10
Text Label 1850 5400 0    60   ~ 0
A11
Text Label 1850 5500 0    60   ~ 0
A3
Text Label 1850 5600 0    60   ~ 0
READY
Text Label 1850 5700 0    60   ~ 0
A8
Text Label 1850 5800 0    60   ~ 0
A14
Text Label 1850 5900 0    60   ~ 0
A9
Text Label 1850 6000 0    60   ~ 0
A2
Text Label 1850 6100 0    60   ~ 0
CRUCLK*
Text Label 1850 6200 0    60   ~ 0
PHI3*
Text Label 1850 6300 0    60   ~ 0
WE*
Text Label 1850 6400 0    60   ~ 0
MBE*
Text Label 1850 6500 0    60   ~ 0
A1
Text Label 1850 6600 0    60   ~ 0
MEMEN*
Text Label 1850 6700 0    60   ~ 0
D7
Text Label 1850 6800 0    60   ~ 0
D6
Text Label 1850 6900 0    60   ~ 0
D5
Text Label 1850 7000 0    60   ~ 0
D1
Text Label 1850 7100 0    60   ~ 0
D3
Text Label 1850 7200 0    60   ~ 0
AUDIOIN
Text Label 3000 800  0    60   ~ 0
IAQ
Text Label 2950 6350 0    60   ~ 0
D3
Text Label 2950 6450 0    60   ~ 0
D2
Text Label 2950 6550 0    60   ~ 0
D1
Text Label 2950 6650 0    60   ~ 0
D0
Text Label 2950 6750 0    60   ~ 0
D5
Text Label 2950 6850 0    60   ~ 0
D4
Text Label 2950 6950 0    60   ~ 0
D6
Text Label 2950 7050 0    60   ~ 0
D7
Text Label 3000 900  0    60   ~ 0
MEMEN*
Text Label 3000 1000 0    60   ~ 0
WE*
Text Label 3000 1100 0    60   ~ 0
PHI3*
Text Label 3000 1200 0    60   ~ 0
CRUCLK*
Text Label 3000 1300 0    60   ~ 0
A15/CRUOUT
Text Label 3000 1400 0    60   ~ 0
DBIN
Text Label 3000 1500 0    60   ~ 0
RESET*
Text Label 3000 1700 0    60   ~ 0
VCC
$Comp
L PMOD-Host-x2-GPIO PMOD1/2
U 1 1 5A6D4E25
P 6100 6900
F 0 "PMOD1/2" H 6100 6850 50  0000 C CNN
F 1 "PMOD-Host-x2-GPIO" V 6400 6600 50  0001 C CNN
F 2 "pmod-conn_6x2:pmod_pin_array_6x2" H 6150 7200 60  0001 C CNN
F 3 "" H 6150 7200 60  0000 C CNN
	1    6100 6900
	1    0    0    -1  
$EndComp
$Comp
L PMOD-Host-x2-GPIO PMOD5/6
U 1 1 5A6D4E61
P 6550 3650
F 0 "PMOD5/6" H 6550 3600 50  0000 C CNN
F 1 "PMOD-Host-x2-GPIO" V 6850 3350 50  0001 C CNN
F 2 "pmod-conn_6x2:pmod_pin_array_6x2" H 6600 3950 60  0001 C CNN
F 3 "" H 6600 3950 60  0000 C CNN
	1    6550 3650
	1    0    0    -1  
$EndComp
Text Label 5600 7550 0    60   ~ 0
VCC
Text Label 5600 7450 0    60   ~ 0
GND
Text Label 5650 6750 0    60   ~ 0
GND
Text Label 5650 6850 0    60   ~ 0
VCC
Text Label 2950 7350 0    60   ~ 0
RDBENA*
$Comp
L PMOD-Host-x2-GPIO PMOD3/4
U 1 1 5A6D6D18
P 6550 1350
F 0 "PMOD3/4" H 6550 1300 50  0000 C CNN
F 1 "PMOD-Host-x2-GPIO" V 6850 1050 50  0001 C CNN
F 2 "pmod-conn_6x2:pmod_pin_array_6x2" H 6750 550 60  0000 C CNN
F 3 "" H 6600 1650 60  0000 C CNN
	1    6550 1350
	1    0    0    -1  
$EndComp
Text Label 6050 1200 0    60   ~ 0
GND
Text Label 6050 1900 0    60   ~ 0
GND
Text Label 6050 1300 0    60   ~ 0
VCC
Text Label 6050 2000 0    60   ~ 0
VCC
Text Label 6050 3500 0    60   ~ 0
GND
Text Label 6050 4200 0    60   ~ 0
GND
Text Label 6050 3600 0    60   ~ 0
VCC
Text Label 6050 4300 0    60   ~ 0
VCC
Text Label 3000 1800 0    60   ~ 0
GND
$Comp
L R_Small R1
U 1 1 5A6D7B33
P 3250 7500
F 0 "R1" H 3280 7520 50  0000 L CNN
F 1 "3.3K" H 3280 7460 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 3250 7500 50  0001 C CNN
F 3 "" H 3250 7500 50  0001 C CNN
	1    3250 7500
	1    0    0    -1  
$EndComp
Text Label 2950 7600 0    60   ~ 0
VCC
Text Label 6050 1800 0    60   ~ 0
BRESET*
Text Label 5750 1700 0    60   ~ 0
BA15/CRUOUT
Text Label 6050 1600 0    60   ~ 0
BPHI3*
Text Label 6050 1500 0    60   ~ 0
BMEMEN*
Text Label 6050 1100 0    60   ~ 0
BDBIN
Text Label 4650 7050 0    60   ~ 0
BD7
Text Label 4650 6950 0    60   ~ 0
BD6
Text Label 4650 6750 0    60   ~ 0
BD5
Text Label 4650 6850 0    60   ~ 0
BD4
Text Label 4650 6650 0    60   ~ 0
BD0
Text Label 4650 6550 0    60   ~ 0
BD1
Text Label 4650 6450 0    60   ~ 0
BD2
Text Label 4650 6350 0    60   ~ 0
BD3
$Comp
L 74LS165 U3
U 1 1 5A6DAF2D
P 3950 3750
F 0 "U3" H 4000 3700 50  0000 C CNN
F 1 "74LV165A" H 4100 3250 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-16_3.9x9.9mm_Pitch1.27mm" H 3950 3750 50  0001 C CNN
F 3 "" H 3950 3750 50  0001 C CNN
	1    3950 3750
	1    0    0    -1  
$EndComp
$Comp
L 74LS165 U4
U 1 1 5A6DAFD3
P 3950 5200
F 0 "U4" H 4000 5250 50  0000 C CNN
F 1 "74LV165A" H 4100 4650 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-16_3.9x9.9mm_Pitch1.27mm" H 3950 5200 50  0001 C CNN
F 3 "" H 3950 5200 50  0001 C CNN
	1    3950 5200
	1    0    0    -1  
$EndComp
Text Label 4800 4700 0    60   ~ 0
ADRIN2
Text Label 4800 3250 0    60   ~ 0
ADRIN1
Text Label 6050 3200 0    60   ~ 0
ADRIN1
Text Label 6050 4000 0    60   ~ 0
ADRIN2
Text Label 2850 3550 0    60   ~ 0
A0
Text Label 2850 3650 0    60   ~ 0
A1
Text Label 2850 3850 0    60   ~ 0
A2
Text Label 2850 4900 0    60   ~ 0
A3
Text Label 2850 5300 0    60   ~ 0
A4
Text Label 2850 5400 0    60   ~ 0
A5
Text Label 2850 3750 0    60   ~ 0
A6
Text Label 2850 3350 0    60   ~ 0
A7
Text Label 2850 3450 0    60   ~ 0
A15/CRUOUT
Text Label 2850 5100 0    60   ~ 0
A14
Text Label 2850 5000 0    60   ~ 0
A13
Text Label 2850 5200 0    60   ~ 0
A12
Text Label 2850 4800 0    60   ~ 0
A11
Text Label 2850 4700 0    60   ~ 0
A10
Text Label 2850 3950 0    60   ~ 0
A9
Text Label 2850 3250 0    60   ~ 0
A8
Text Label 2850 3150 0    60   ~ 0
GND
Text Label 2850 4600 0    60   ~ 0
GND
Text Label 2850 4100 0    60   ~ 0
SHLD*
Text Label 2850 4250 0    60   ~ 0
SRCLK
Text Label 2850 5700 0    60   ~ 0
SRCLK
Text Label 2850 5550 0    60   ~ 0
SHLD*
Text Label 2850 4350 0    60   ~ 0
GND
Text Label 2850 5800 0    60   ~ 0
GND
Text Label 6050 3900 0    60   ~ 0
SHLD*
Text Label 6050 3300 0    60   ~ 0
SRCLK
Text Label 6050 3800 0    60   ~ 0
DBDIR
Text Label 6050 3100 0    60   ~ 0
RDBENA*
Text Label 6050 800  0    60   ~ 0
BIAQ
Text Label 6050 900  0    60   ~ 0
BWE*
Text Label 6050 1000 0    60   ~ 0
BCRUCLK*
Text Notes 3700 3000 0    60   ~ 0
Address Bus\n
$Comp
L Conn_01x02 J2
U 1 1 5A6E45B3
P 1600 4600
F 0 "J2" H 1600 4700 50  0000 C CNN
F 1 "Conn_01x02" H 1600 4400 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 1600 4600 50  0001 C CNN
F 3 "" H 1600 4600 50  0001 C CNN
	1    1600 4600
	1    0    0    -1  
$EndComp
Text Label 950  4600 0    60   ~ 0
AUDIOIN
Text Label 950  4700 0    60   ~ 0
GND
$Comp
L C C1
U 1 1 5A6F3336
P 950 3650
F 0 "C1" H 975 3750 50  0000 L CNN
F 1 ".1uF" H 975 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 988 3500 50  0001 C CNN
F 3 "" H 950 3650 50  0001 C CNN
	1    950  3650
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 5A6F3395
P 1250 3650
F 0 "C2" H 1275 3750 50  0000 L CNN
F 1 ".1uF" H 1275 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 1288 3500 50  0001 C CNN
F 3 "" H 1250 3650 50  0001 C CNN
	1    1250 3650
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 5A6F342D
P 1550 3650
F 0 "C3" H 1575 3750 50  0000 L CNN
F 1 ".1uF" H 1575 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 1588 3500 50  0001 C CNN
F 3 "" H 1550 3650 50  0001 C CNN
	1    1550 3650
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 5A6F346E
P 1850 3650
F 0 "C4" H 1875 3750 50  0000 L CNN
F 1 ".1uF" H 1875 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 1888 3500 50  0001 C CNN
F 3 "" H 1850 3650 50  0001 C CNN
	1    1850 3650
	1    0    0    -1  
$EndComp
Text Label 1250 3500 0    60   ~ 0
VCC
Text Label 1250 3950 0    60   ~ 0
GND
$Comp
L 74LS245 U1
U 1 1 5A6D1947
P 3950 6850
F 0 "U1" H 4000 6650 50  0000 C CNN
F 1 "74LVC245A" H 4050 6450 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 3950 6850 50  0001 C CNN
F 3 "" H 3950 6850 50  0001 C CNN
	1    3950 6850
	1    0    0    -1  
$EndComp
Text Label 2950 7250 0    60   ~ 0
DBDIR
Wire Wire Line
	2950 7250 3250 7250
Wire Wire Line
	3250 6550 2950 6550
Wire Wire Line
	3250 7050 2950 7050
Wire Wire Line
	1250 3800 1250 3950
Connection ~ 1550 3800
Connection ~ 1250 3800
Wire Wire Line
	950  3800 2100 3800
Connection ~ 1550 3500
Connection ~ 1250 3500
Wire Wire Line
	950  3500 2100 3500
Wire Wire Line
	1400 4700 950  4700
Wire Wire Line
	950  4600 1400 4600
Wire Wire Line
	3250 3150 2850 3150
Wire Wire Line
	3250 5800 2850 5800
Wire Wire Line
	3250 5700 2850 5700
Wire Wire Line
	3250 5550 2850 5550
Wire Wire Line
	3250 5400 2850 5400
Wire Wire Line
	3250 5300 2850 5300
Wire Wire Line
	3250 5200 2850 5200
Wire Wire Line
	3250 5100 2850 5100
Wire Wire Line
	3250 5000 2850 5000
Wire Wire Line
	3250 4900 2850 4900
Wire Wire Line
	3250 4800 2850 4800
Wire Wire Line
	3250 4700 2850 4700
Wire Wire Line
	3250 4600 2850 4600
Wire Wire Line
	3250 4350 2850 4350
Wire Wire Line
	3250 4250 2850 4250
Wire Wire Line
	3250 4100 2850 4100
Wire Wire Line
	3250 3950 2850 3950
Wire Wire Line
	3250 3850 2850 3850
Wire Wire Line
	3250 3750 2850 3750
Wire Wire Line
	3250 3650 2850 3650
Wire Wire Line
	3250 3550 2850 3550
Wire Wire Line
	3250 3450 2850 3450
Wire Wire Line
	3250 3350 2850 3350
Wire Wire Line
	3250 3250 2850 3250
Wire Wire Line
	6400 4100 6050 4100
Wire Wire Line
	6400 4000 6050 4000
Wire Wire Line
	6400 3900 6050 3900
Wire Wire Line
	6050 3800 6400 3800
Wire Wire Line
	6400 3400 6050 3400
Wire Wire Line
	6400 3300 6050 3300
Wire Wire Line
	6400 3200 6050 3200
Wire Wire Line
	6400 3100 6050 3100
Wire Wire Line
	4650 4700 4800 4700
Wire Wire Line
	4650 3250 4800 3250
Wire Wire Line
	6400 800  6050 800 
Wire Wire Line
	6400 900  6050 900 
Wire Wire Line
	6400 1000 6050 1000
Wire Wire Line
	6400 1100 6050 1100
Wire Wire Line
	6400 1500 6050 1500
Wire Wire Line
	6050 1600 6400 1600
Wire Wire Line
	5750 1700 6400 1700
Wire Wire Line
	6050 1800 6400 1800
Wire Wire Line
	3250 7600 2950 7600
Wire Wire Line
	6400 3600 6050 3600
Wire Wire Line
	6400 3500 6050 3500
Wire Wire Line
	6400 4300 6050 4300
Wire Wire Line
	6400 4200 6050 4200
Wire Wire Line
	6400 2000 6050 2000
Wire Wire Line
	6400 1900 6050 1900
Wire Wire Line
	6400 1300 6050 1300
Wire Wire Line
	6400 1200 6050 1200
Wire Wire Line
	5950 6850 5650 6850
Wire Wire Line
	5950 6750 5650 6750
Wire Wire Line
	5600 7550 5950 7550
Wire Wire Line
	5600 7450 5950 7450
Wire Wire Line
	3250 6350 2950 6350
Wire Wire Line
	3250 6450 2950 6450
Wire Wire Line
	3250 6650 2950 6650
Wire Wire Line
	3250 6750 2950 6750
Wire Wire Line
	3250 6850 2950 6850
Wire Wire Line
	3250 6950 2950 6950
Wire Wire Line
	3300 1700 3000 1700
Wire Wire Line
	3300 1500 3000 1500
Wire Wire Line
	3300 1400 3000 1400
Wire Wire Line
	3300 1300 3000 1300
Wire Wire Line
	3300 1200 3000 1200
Wire Wire Line
	3300 1100 3000 1100
Wire Wire Line
	3300 1000 3000 1000
Wire Wire Line
	3000 900  3300 900 
Wire Wire Line
	3000 800  3300 800 
Wire Wire Line
	1750 7200 1850 7200
Wire Wire Line
	1750 7100 1850 7100
Wire Wire Line
	1750 7000 1850 7000
Wire Wire Line
	1750 6900 1850 6900
Wire Wire Line
	1750 6800 1850 6800
Wire Wire Line
	1750 6700 1850 6700
Wire Wire Line
	1750 6600 1850 6600
Wire Wire Line
	1750 6500 1850 6500
Wire Wire Line
	1750 6400 1850 6400
Wire Wire Line
	1750 6300 1850 6300
Wire Wire Line
	1750 6200 1850 6200
Wire Wire Line
	1750 6100 1850 6100
Wire Wire Line
	1750 6000 1850 6000
Wire Wire Line
	1750 5900 1850 5900
Wire Wire Line
	1750 5800 1850 5800
Wire Wire Line
	1750 5700 1850 5700
Wire Wire Line
	1750 5600 1850 5600
Wire Wire Line
	1750 5500 1850 5500
Wire Wire Line
	1750 5400 1850 5400
Wire Wire Line
	1750 5300 1850 5300
Wire Wire Line
	1750 5200 1850 5200
Wire Wire Line
	1750 5100 1850 5100
Wire Wire Line
	1250 5100 900  5100
Wire Wire Line
	1250 5200 900  5200
Wire Wire Line
	1250 5300 900  5300
Wire Wire Line
	1250 5400 900  5400
Wire Wire Line
	1250 5500 900  5500
Wire Wire Line
	1250 5600 900  5600
Wire Wire Line
	1250 5700 900  5700
Wire Wire Line
	1250 5800 900  5800
Wire Wire Line
	1250 5900 900  5900
Wire Wire Line
	1250 6000 650  6000
Wire Wire Line
	1250 6100 900  6100
Wire Wire Line
	1250 6200 900  6200
Wire Wire Line
	1250 6300 900  6300
Wire Wire Line
	1250 6400 900  6400
Wire Wire Line
	1250 6500 900  6500
Wire Wire Line
	1250 6600 900  6600
Wire Wire Line
	1250 6700 900  6700
Wire Wire Line
	1250 6800 900  6800
Wire Wire Line
	1250 6900 900  6900
Wire Wire Line
	1250 7000 900  7000
Wire Wire Line
	1250 7100 900  7100
Wire Wire Line
	1250 7200 900  7200
Wire Wire Line
	3000 1800 3300 1800
Wire Wire Line
	2950 7350 3250 7350
Wire Wire Line
	3250 7350 3250 7400
Connection ~ 3250 7350
Text Label 5700 6350 0    60   ~ 0
BD3
Text Label 5700 7050 0    60   ~ 0
BD2
Text Label 5700 6450 0    60   ~ 0
BD1
Text Label 5700 7150 0    60   ~ 0
BD0
Text Label 5700 6550 0    60   ~ 0
BD4
Text Label 5700 7250 0    60   ~ 0
BD5
Text Label 5700 6650 0    60   ~ 0
BD7
Text Label 5700 7350 0    60   ~ 0
BD6
Wire Wire Line
	5700 6350 5950 6350
Wire Wire Line
	5700 6450 5950 6450
Wire Wire Line
	5700 6550 5950 6550
Wire Wire Line
	5700 6650 5950 6650
Wire Wire Line
	5700 7050 5950 7050
Wire Wire Line
	5700 7150 5950 7150
Wire Wire Line
	5700 7250 5950 7250
Wire Wire Line
	5700 7350 5950 7350
Text Label 4700 800  0    60   ~ 0
BIAQ
Text Label 4700 900  0    60   ~ 0
BMEMEN*
Text Label 4700 1000 0    60   ~ 0
BWE*
Text Label 4700 1100 0    60   ~ 0
BPHI3*
Text Label 4700 1200 0    60   ~ 0
BCRUCLK*
Text Label 4700 1300 0    60   ~ 0
BA15/CRUOUT
Text Label 4700 1400 0    60   ~ 0
BDBIN
Text Label 4700 1500 0    60   ~ 0
BRESET*
$Comp
L 74LVC125 U5
U 1 1 5A73A87E
P 3850 2200
F 0 "U5" H 3850 2300 50  0000 L BNN
F 1 "74LVC125" H 3900 2050 50  0000 L TNN
F 2 "Housings_SOIC:SOIC-14_3.9x8.7mm_Pitch1.27mm" H 3850 2200 50  0001 C CNN
F 3 "" H 3850 2200 50  0001 C CNN
	1    3850 2200
	-1   0    0    -1  
$EndComp
Text Label 4300 2200 0    60   ~ 0
BCRUIN
Text Label 6050 3400 0    60   ~ 0
BCRUIN
Text Label 6050 4100 0    60   ~ 0
EN_CRUIN*
Text Label 4300 2500 0    60   ~ 0
EN_CRUIN*
Wire Wire Line
	3400 2200 3000 2200
Text Label 3000 2200 0    60   ~ 0
CRUIN
$Comp
L C C5
U 1 1 5A73B531
P 2100 3650
F 0 "C5" H 2125 3750 50  0000 L CNN
F 1 ".1uF" H 2125 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 2138 3500 50  0001 C CNN
F 3 "" H 2100 3650 50  0001 C CNN
	1    2100 3650
	1    0    0    -1  
$EndComp
Connection ~ 1850 3500
Connection ~ 1850 3800
$Comp
L R_Small R2
U 1 1 5A73B7FA
P 4200 2600
F 0 "R2" H 4230 2620 50  0000 L CNN
F 1 "3.3K" H 4230 2560 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 4200 2600 50  0001 C CNN
F 3 "" H 4200 2600 50  0001 C CNN
	1    4200 2600
	-1   0    0    1   
$EndComp
Wire Wire Line
	3850 2500 4300 2500
Connection ~ 4200 2500
Wire Wire Line
	4200 2700 4550 2700
Text Label 4550 2700 0    60   ~ 0
VCC
$EndSCHEMATC
