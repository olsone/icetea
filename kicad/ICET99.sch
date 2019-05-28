EESchema Schematic File Version 4
LIBS:ICET99-cache
EELAYER 29 0
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
Text Notes 1450 850  0    60   ~ 0
Signals
Text Notes 4050 3000 0    60   ~ 0
Data Bus
Text Label 3450 3250 0    60   ~ 0
D3
Text Label 3450 3350 0    60   ~ 0
D2
Text Label 3450 3450 0    60   ~ 0
D1
Text Label 3450 3550 0    60   ~ 0
D0
Text Label 3450 3650 0    60   ~ 0
D5
Text Label 3450 3750 0    60   ~ 0
D4
Text Label 3450 3850 0    60   ~ 0
D6
Text Label 3450 3950 0    60   ~ 0
D7
Text Label 8350 3850 0    60   ~ 0
VCC
Text Label 8350 3950 0    60   ~ 0
GND
Text Label 7500 3950 0    60   ~ 0
GND
$Comp
L Device:C C2
U 1 1 5A6F3336
P 950 3650
F 0 "C2" H 975 3750 50  0000 L CNN
F 1 ".1uF" H 975 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 988 3500 50  0001 C CNN
F 3 "" H 950 3650 50  0001 C CNN
	1    950  3650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 5A6F3395
P 1250 3650
F 0 "C6" H 1275 3750 50  0000 L CNN
F 1 ".1uF" H 1275 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 1288 3500 50  0001 C CNN
F 3 "" H 1250 3650 50  0001 C CNN
	1    1250 3650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 5A6F342D
P 1550 3650
F 0 "C5" H 1575 3750 50  0000 L CNN
F 1 ".1uF" H 1575 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 1588 3500 50  0001 C CNN
F 3 "" H 1550 3650 50  0001 C CNN
	1    1550 3650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 5A6F346E
P 1850 3650
F 0 "C3" H 1875 3750 50  0000 L CNN
F 1 ".1uF" H 1875 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 1888 3500 50  0001 C CNN
F 3 "" H 1850 3650 50  0001 C CNN
	1    1850 3650
	1    0    0    -1  
$EndComp
Text Label 1250 3500 0    60   ~ 0
VCC
Text Label 1250 3950 0    60   ~ 0
GND
$Comp
L ICET99-rescue:74LS245 U1
U 1 1 5A6D1947
P 4450 3750
F 0 "U1" H 4500 3550 50  0000 C CNN
F 1 "74LVC245A" H 4550 3350 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 4450 3750 50  0001 C CNN
F 3 "" H 4450 3750 50  0001 C CNN
	1    4450 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 3450 3450 3450
Wire Wire Line
	3750 3950 3450 3950
Wire Wire Line
	1250 3800 1250 3950
Connection ~ 1550 3800
Connection ~ 1250 3800
Wire Wire Line
	950  3800 1250 3800
Wire Wire Line
	1250 3800 1550 3800
Wire Wire Line
	1550 3800 1850 3800
Wire Wire Line
	1850 3800 2100 3800
Connection ~ 1550 3500
Connection ~ 1250 3500
Wire Wire Line
	950  3500 1250 3500
Wire Wire Line
	1250 3500 1550 3500
Wire Wire Line
	1550 3500 1850 3500
Wire Wire Line
	1850 3500 2100 3500
Wire Wire Line
	3750 3250 3450 3250
Wire Wire Line
	3750 3350 3450 3350
Wire Wire Line
	3750 3550 3450 3550
Wire Wire Line
	3750 3650 3450 3650
Wire Wire Line
	3750 3750 3450 3750
Wire Wire Line
	3750 3850 3450 3850
Text Label 8350 5250 0    60   ~ 0
BD2
Text Label 8350 5150 0    60   ~ 0
BD0
Text Label 8350 5050 0    60   ~ 0
BD4
Text Label 8350 4950 0    60   ~ 0
BD7
$Comp
L ICET99-rescue:74LVC125 U5
U 1 1 5A73A87E
P 1650 2650
F 0 "U5" H 1650 2750 50  0000 L BNN
F 1 "74HCT125" H 1700 2500 50  0000 L TNN
F 2 "Housings_SOIC:SOIC-14_3.9x8.7mm_Pitch1.27mm" H 1650 2650 50  0001 C CNN
F 3 "" H 1650 2650 50  0001 C CNN
	1    1650 2650
	-1   0    0    -1  
$EndComp
Text Label 2100 2650 0    60   ~ 0
CRUBIT
Text Label 2100 2950 0    60   ~ 0
CRUEN
Wire Wire Line
	1200 2650 800  2650
Text Label 800  2650 0    60   ~ 0
CRUIN
$Comp
L Device:C C4
U 1 1 5A73B531
P 2100 3650
F 0 "C4" H 2125 3750 50  0000 L CNN
F 1 ".1uF" H 2125 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 2138 3500 50  0001 C CNN
F 3 "" H 2100 3650 50  0001 C CNN
	1    2100 3650
	1    0    0    -1  
$EndComp
Connection ~ 1850 3500
Connection ~ 1850 3800
$Comp
L Device:R_Small R2
U 1 1 5A73B7FA
P 2000 3050
F 0 "R2" H 2030 3070 50  0000 L CNN
F 1 "3.3K" H 2030 3010 50  0000 L CNN
F 2 "Resistors_SMD:R_0805" H 2000 3050 50  0001 C CNN
F 3 "" H 2000 3050 50  0001 C CNN
	1    2000 3050
	-1   0    0    1   
$EndComp
Wire Wire Line
	1650 2950 2000 2950
Wire Wire Line
	2000 2950 2100 2950
Connection ~ 2000 2950
Wire Wire Line
	2000 3150 2350 3150
Text Label 2350 3150 0    60   ~ 0
VCC
Text Label 8350 4050 0    60   ~ 0
ENC1
Text Label 8350 4250 0    60   ~ 0
DEC2
Text Notes 4050 3150 0    60   ~ 0
8-Bit
Text Label 650  2200 0    60   ~ 0
GND
Text Label 8350 4150 0    60   ~ 0
DEC0
Text Label 5400 1650 0    60   ~ 0
DEC0
Text Label 5400 1950 0    60   ~ 0
DEC2
Text Label 4000 1550 2    60   ~ 0
DBEN1
Text Label 4500 1150 1    60   ~ 0
DBEN2
Text Label 4400 1150 1    60   ~ 0
DBDIR
Text Label 4900 2550 3    60   ~ 0
ABEN1
Text Label 5000 2550 3    60   ~ 0
ABEN2
Text Label 5400 2050 0    60   ~ 0
CRUEN
Text Label 5400 2150 0    60   ~ 0
CRUBIT
Text Label 3450 4150 0    60   ~ 0
DBDIR
Text Label 3450 4250 0    60   ~ 0
DBEN1
Wire Wire Line
	3750 4250 3450 4250
Wire Wire Line
	3350 4150 3750 4150
$Comp
L Device:C C1
U 1 1 5CF30AF0
P 2350 3650
F 0 "C1" H 2375 3750 50  0000 L CNN
F 1 ".1uF" H 2375 3550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 2388 3500 50  0001 C CNN
F 3 "" H 2350 3650 50  0001 C CNN
	1    2350 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 3500 2100 3500
Connection ~ 2100 3500
Wire Wire Line
	2350 3800 2100 3800
Connection ~ 2100 3800
Wire Wire Line
	800  4250 1250 4250
Wire Wire Line
	1250 4350 800  4350
Text Label 800  4350 0    60   ~ 0
GND
Text Label 800  4250 0    60   ~ 0
AUDIOIN
$Comp
L conn:CONN_01X02 T1
U 1 1 5A6E45B3
P 1450 4300
F 0 "T1" H 1450 4400 50  0000 C CNN
F 1 "Conn_01x02" H 1450 4100 50  0001 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 1450 4300 50  0001 C CNN
F 3 "" H 1450 4300 50  0001 C CNN
	1    1450 4300
	1    0    0    -1  
$EndComp
Text Notes 850  4150 0    60   ~ 0
Test Points
Text Label 650  2100 0    60   ~ 0
VCC
Text Label 2500 1800 0    60   ~ 0
BPHI3*
Text Label 2500 1700 0    60   ~ 0
BWE*
Text Label 2500 1900 0    60   ~ 0
BCRUCLK
Text Label 4000 1650 2    60   ~ 0
BMEMEN*
Text Label 4400 2550 3    60   ~ 0
BWE*
Text Label 4500 2550 3    60   ~ 0
BCRUCLK
Text Label 4000 2150 2    60   ~ 0
BA15CRUOUT
Text Label 4000 2050 2    60   ~ 0
BDBIN
Text Label 4900 1150 1    60   ~ 0
ENC2
Text Label 5000 1150 1    60   ~ 0
ENC1
Text Label 5400 1550 0    60   ~ 0
ENC0
Text Label 650  1300 0    60   ~ 0
MEMEN*
Text Label 650  1700 0    60   ~ 0
WE*
Text Label 650  1900 0    60   ~ 0
CRUCLK
Text Label 650  1600 0    60   ~ 0
A15CRUOUT
Text Label 650  1500 0    60   ~ 0
DBIN
Text Label 650  1400 0    60   ~ 0
RESET*
Text Label 650  1800 0    60   ~ 0
PHI3*
Text Label 4000 1850 2    60   ~ 0
GND
Text Label 4600 2550 3    60   ~ 0
GND
Text Label 4700 2550 3    60   ~ 0
GND
Text Label 5400 1850 0    60   ~ 0
GND
Text Label 4700 1150 1    60   ~ 0
VCC
Text Label 4800 1150 1    60   ~ 0
VCC
Text Notes 7400 7500 0    60   ~ 0
IceTea interface from TI-99/4A to BlackIce using 8-bit bus 
Text Notes 8700 7650 2    60   ~ 0
5/14/2019
Text Label 4450 4300 3    60   ~ 0
GND
$Comp
L conn:CONN_01X01 T2
U 1 1 5D21DB51
P 2250 4300
F 0 "T2" H 2250 4400 50  0000 C CNN
F 1 "Conn_01x02" H 2250 4100 50  0001 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x01_Pitch2.54mm" H 2250 4300 50  0001 C CNN
F 3 "" H 2250 4300 50  0001 C CNN
	1    2250 4300
	1    0    0    -1  
$EndComp
Text Label 2050 4300 2    60   ~ 0
BIAQ
Text Label 1800 1150 1    60   ~ 0
VCC
Text Label 650  1200 0    60   ~ 0
IAQ
Wire Wire Line
	4000 1750 4000 1850
Text Label 8350 4750 0    60   ~ 0
VCC
Text Label 7500 3850 0    60   ~ 0
VCC
Text Label 7500 4950 0    60   ~ 0
BD6
Text Label 7500 5050 0    60   ~ 0
BD5
Text Label 7500 5150 0    60   ~ 0
BD1
Text Label 7500 5250 0    60   ~ 0
BD3
Text Label 8350 4350 0    60   ~ 0
BPHI3*
Text Label 7500 4850 0    60   ~ 0
GND
Text Label 7500 4750 0    60   ~ 0
VCC
Text Label 8350 4850 0    60   ~ 0
GND
Text Label 7700 4250 2    60   ~ 0
DEC1
Wire Wire Line
	7700 4150 7750 4150
Wire Wire Line
	7700 4250 7750 4250
Wire Wire Line
	7700 4350 7750 4350
NoConn ~ 7750 4450
NoConn ~ 8350 4450
NoConn ~ 8350 4550
NoConn ~ 8350 4650
NoConn ~ 7750 4650
NoConn ~ 7750 4550
$Comp
L power:+3.3V #PWR0101
U 1 1 5CF2FC1C
P 8650 5700
F 0 "#PWR0101" H 8650 5550 50  0001 C CNN
F 1 "+3.3V" H 8665 5873 50  0000 C CNN
F 2 "" H 8650 5700 50  0001 C CNN
F 3 "" H 8650 5700 50  0001 C CNN
	1    8650 5700
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5CF3EBA3
P 7400 5700
F 0 "#PWR0102" H 7400 5450 50  0001 C CNN
F 1 "GND" H 7405 5527 50  0000 C CNN
F 2 "" H 7400 5700 50  0001 C CNN
F 3 "" H 7400 5700 50  0001 C CNN
	1    7400 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 5700 7400 5450
Wire Wire Line
	8650 4750 8350 4750
Wire Wire Line
	8650 4750 8650 3850
Wire Wire Line
	8650 3850 8350 3850
Connection ~ 8650 4750
Wire Wire Line
	7400 4850 7400 3950
Connection ~ 7400 4850
Wire Wire Line
	7300 4750 7300 5350
Connection ~ 8650 5350
Wire Wire Line
	8650 5350 8650 4750
Wire Wire Line
	7300 4750 7300 3850
Connection ~ 7300 4750
Wire Wire Line
	8350 3950 8750 3950
Wire Wire Line
	8750 3950 8750 4850
Wire Wire Line
	8750 5450 7400 5450
Connection ~ 7400 5450
Wire Wire Line
	7400 5450 7400 4850
Wire Wire Line
	8350 4850 8750 4850
Connection ~ 8750 4850
Wire Wire Line
	8750 4850 8750 5450
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5CF9A201
P 8850 5700
F 0 "#FLG0101" H 8850 5775 50  0001 C CNN
F 1 "PWR_FLAG" H 8850 5873 50  0000 C CNN
F 2 "" H 8850 5700 50  0001 C CNN
F 3 "~" H 8850 5700 50  0001 C CNN
	1    8850 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 5350 8650 5700
Wire Wire Line
	7300 5350 8650 5350
Wire Wire Line
	8850 5700 8650 5700
Connection ~ 8650 5700
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5CFBCE57
P 7600 5700
F 0 "#FLG0102" H 7600 5775 50  0001 C CNN
F 1 "PWR_FLAG" H 7600 5873 50  0000 C CNN
F 2 "" H 7600 5700 50  0001 C CNN
F 3 "~" H 7600 5700 50  0001 C CNN
	1    7600 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7600 5700 7400 5700
Connection ~ 7400 5700
$Comp
L Mechanical:MountingHole H1
U 1 1 5CE594E8
P 10500 650
F 0 "H1" H 10600 696 50  0000 L CNN
F 1 "MountingHole" H 10600 605 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2" H 10500 650 50  0001 C CNN
F 3 "~" H 10500 650 50  0001 C CNN
	1    10500 650 
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 5CE59925
P 10500 900
F 0 "H2" H 10600 946 50  0000 L CNN
F 1 "MountingHole" H 10600 855 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2" H 10500 900 50  0001 C CNN
F 3 "~" H 10500 900 50  0001 C CNN
	1    10500 900 
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 5CE59F12
P 10500 1150
F 0 "H3" H 10600 1196 50  0000 L CNN
F 1 "MountingHole" H 10600 1105 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2" H 10500 1150 50  0001 C CNN
F 3 "~" H 10500 1150 50  0001 C CNN
	1    10500 1150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 5CE59FEA
P 10500 1350
F 0 "H4" H 10600 1396 50  0000 L CNN
F 1 "MountingHole" H 10600 1305 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2" H 10500 1350 50  0001 C CNN
F 3 "~" H 10500 1350 50  0001 C CNN
	1    10500 1350
	1    0    0    -1  
$EndComp
Text Label 4450 4900 1    60   ~ 0
VCC
Text Label 4000 1950 2    60   ~ 0
BRESET*
Text Label 5150 7000 0    60   ~ 0
BD6
Text Label 5150 6900 0    60   ~ 0
BD4
Text Label 5150 6800 0    60   ~ 0
BD5
Text Label 5150 6700 0    60   ~ 0
BD0
Text Label 5150 6600 0    60   ~ 0
BD1
Text Label 5150 6500 0    60   ~ 0
BD2
Text Label 5150 6400 0    60   ~ 0
BD3
Text Label 5150 7100 0    60   ~ 0
BD7
Wire Wire Line
	3350 7400 3750 7400
Text Label 3350 7400 0    60   ~ 0
ABEN2
Text Label 3350 5950 0    60   ~ 0
ABEN1
Text Notes 4050 6200 0    60   ~ 0
LSB
Text Notes 4050 4800 0    60   ~ 0
MSB
$Comp
L ICET99_Library:74LVC245A U4
U 1 1 5CD0EE0E
P 4450 6900
F 0 "U4" H 4500 6700 50  0000 C CNN
F 1 "74LVC245A" H 4550 6500 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 4450 6900 50  0001 C CNN
F 3 "" H 4450 6900 50  0001 C CNN
	1    4450 6900
	1    0    0    -1  
$EndComp
$Comp
L ICET99_Library:74LVC245A U3
U 1 1 5CD0E9F9
P 4450 5450
F 0 "U3" H 4500 5250 50  0000 C CNN
F 1 "74LVC245A" H 4550 5050 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 4450 5450 50  0001 C CNN
F 3 "" H 4450 5450 50  0001 C CNN
	1    4450 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 5350 3350 5350
Wire Wire Line
	3750 5450 3350 5450
Wire Wire Line
	3750 5550 3350 5550
Wire Wire Line
	3750 5650 3350 5650
Wire Wire Line
	3750 4950 3350 4950
Wire Wire Line
	3750 5050 3350 5050
Wire Wire Line
	3750 5150 3350 5150
Wire Wire Line
	3750 5250 3350 5250
Wire Wire Line
	3750 5950 3350 5950
Wire Wire Line
	3750 6600 3350 6600
Wire Wire Line
	3750 6700 3350 6700
Wire Wire Line
	3750 7000 3350 7000
Wire Wire Line
	3750 6400 3350 6400
Wire Wire Line
	3750 6500 3350 6500
Wire Wire Line
	3750 6800 3350 6800
Wire Wire Line
	3750 6900 3350 6900
Text Notes 4050 4700 0    60   ~ 0
Address Bus\n
Text Label 3350 6600 0    60   ~ 0
A8
Text Label 3350 5350 0    60   ~ 0
A9
Text Label 3350 6900 0    60   ~ 0
A10
Text Label 3350 6800 0    60   ~ 0
A11
Text Label 3350 6500 0    60   ~ 0
A12
Text Label 3350 6400 0    60   ~ 0
A13
Text Label 3350 5450 0    60   ~ 0
A14
Text Label 3350 5550 0    60   ~ 0
A15CRUOUT
Text Label 3350 5650 0    60   ~ 0
A7
Text Label 3350 5150 0    60   ~ 0
A6
Text Label 3350 7100 0    60   ~ 0
A5
Text Label 3350 7000 0    60   ~ 0
A4
Text Label 3350 6700 0    60   ~ 0
A3
Text Label 3350 5250 0    60   ~ 0
A2
Text Label 3350 5050 0    60   ~ 0
A1
Text Label 3350 4950 0    60   ~ 0
A0
$Comp
L conn:CONN_02X22 J1
U 1 1 5A6D1DC3
P 1550 6000
F 0 "J1" H 1600 7100 50  0000 C CNN
F 1 "Conn_02x22_Odd_Even" H 1600 4800 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_2x22_Pitch2.54mm" H 1550 6000 50  0001 C CNN
F 3 "" H 1550 6000 50  0001 C CNN
	1    1550 6000
	-1   0    0    1   
$EndComp
Wire Wire Line
	1800 5750 2150 5750
Wire Wire Line
	1800 6250 2150 6250
NoConn ~ 1800 4950
NoConn ~ 1800 6450
NoConn ~ 1800 7050
NoConn ~ 1300 7050
NoConn ~ 1300 6950
NoConn ~ 1300 5750
Text Notes 900  4750 0    60   ~ 0
Console
Wire Wire Line
	1800 4950 2150 4950
Wire Wire Line
	1800 5050 2150 5050
Wire Wire Line
	1800 5150 2150 5150
Wire Wire Line
	1800 5250 2150 5250
Wire Wire Line
	1800 5350 2150 5350
Wire Wire Line
	1800 5450 2150 5450
Wire Wire Line
	1800 5550 2150 5550
Wire Wire Line
	1800 5650 2150 5650
Wire Wire Line
	1800 5850 2150 5850
Wire Wire Line
	1800 5950 2150 5950
Wire Wire Line
	1800 6050 2150 6050
Wire Wire Line
	1800 6150 2400 6150
Wire Wire Line
	1800 6350 2150 6350
Wire Wire Line
	1800 6450 2150 6450
Wire Wire Line
	1800 6550 2150 6550
Wire Wire Line
	1800 6650 2150 6650
Wire Wire Line
	1800 6750 2150 6750
Wire Wire Line
	1800 6850 2150 6850
Wire Wire Line
	1800 6950 2150 6950
Wire Wire Line
	1800 7050 2150 7050
Wire Wire Line
	1300 7050 1200 7050
Wire Wire Line
	1300 6950 1200 6950
Wire Wire Line
	1300 6850 1200 6850
Wire Wire Line
	1300 6750 1200 6750
Wire Wire Line
	1300 6650 1200 6650
Wire Wire Line
	1300 6550 1200 6550
Wire Wire Line
	1300 6450 1200 6450
Wire Wire Line
	1300 6350 1200 6350
Wire Wire Line
	1300 6250 1200 6250
Wire Wire Line
	1300 6150 1200 6150
Wire Wire Line
	1300 6050 1200 6050
Wire Wire Line
	1300 5950 1200 5950
Wire Wire Line
	1300 5850 1200 5850
Wire Wire Line
	1300 5750 1200 5750
Wire Wire Line
	1300 5650 1200 5650
Wire Wire Line
	1300 5550 1200 5550
Wire Wire Line
	1300 5450 1200 5450
Wire Wire Line
	1300 5350 1200 5350
Wire Wire Line
	1300 5250 1200 5250
Wire Wire Line
	1300 5150 1200 5150
Wire Wire Line
	1300 5050 1200 5050
Wire Wire Line
	1300 4950 1200 4950
Text Label 1200 4950 2    60   ~ 0
AUDIOIN
Text Label 1200 5050 2    60   ~ 0
D3
Text Label 1200 5150 2    60   ~ 0
D1
Text Label 1200 5250 2    60   ~ 0
D5
Text Label 1200 5350 2    60   ~ 0
D6
Text Label 1200 5450 2    60   ~ 0
D7
Text Label 1200 5550 2    60   ~ 0
MEMEN*
Text Label 1200 5650 2    60   ~ 0
A1
Text Label 1200 5750 2    60   ~ 0
MBE*
Text Label 1200 5850 2    60   ~ 0
WE*
Text Label 1200 5950 2    60   ~ 0
PHI3*
Text Label 1200 6050 2    60   ~ 0
CRUCLK
Text Label 1200 6150 2    60   ~ 0
A2
Text Label 1200 6250 2    60   ~ 0
A9
Text Label 1200 6350 2    60   ~ 0
A14
Text Label 1200 6450 2    60   ~ 0
A8
Text Label 1200 6550 2    60   ~ 0
READY
Text Label 1200 6650 2    60   ~ 0
A3
Text Label 1200 6750 2    60   ~ 0
A11
Text Label 1200 6850 2    60   ~ 0
A10
Text Label 1200 6950 2    60   ~ 0
EXTINT*
Text Label 2150 4950 2    60   ~ 0
MINUS5V
Text Label 2150 5050 2    60   ~ 0
IAQ
Text Label 2150 5150 2    60   ~ 0
D2
Text Label 2150 5250 2    60   ~ 0
D0
Text Label 2150 5350 2    60   ~ 0
D4
Text Label 2150 5450 2    60   ~ 0
CRUIN
Text Label 2150 5550 2    60   ~ 0
A0
Text Label 2150 5650 2    60   ~ 0
A6
Text Label 2150 5750 2    60   ~ 0
GND
Text Label 2150 5850 2    60   ~ 0
GND
Text Label 2150 5950 2    60   ~ 0
GND
Text Label 2150 6050 2    60   ~ 0
GND
Text Label 2400 6150 2    60   ~ 0
A15CRUOUT
Text Label 2150 6250 2    60   ~ 0
A7
Text Label 2150 6350 2    60   ~ 0
A13
Text Label 2150 6450 2    60   ~ 0
LOAD*
Text Label 2150 6550 2    60   ~ 0
A12
Text Label 2150 6650 2    60   ~ 0
DBIN
Text Label 2150 6750 2    60   ~ 0
A4
Text Label 2150 6850 2    60   ~ 0
A5
Text Label 2150 6950 2    60   ~ 0
RESET*
Text Label 2150 7050 2    60   ~ 0
PLUS5V
Text Label 1200 7050 2    60   ~ 0
SBE
Text Label 5150 3250 0    60   ~ 0
BD3
Text Label 5150 3350 0    60   ~ 0
BD2
Text Label 5150 3450 0    60   ~ 0
BD1
Text Label 5150 3550 0    60   ~ 0
BD0
Text Label 5150 3750 0    60   ~ 0
BD4
Text Label 5150 3650 0    60   ~ 0
BD5
Text Label 5150 3850 0    60   ~ 0
BD6
Text Label 5150 3950 0    60   ~ 0
BD7
Text Label 5150 5650 0    60   ~ 0
BD3
Text Label 5150 5450 0    60   ~ 0
BD1
Text Label 5150 5250 0    60   ~ 0
BD5
Text Label 5150 5050 0    60   ~ 0
BD6
Text Label 5150 4950 0    60   ~ 0
BD7
Text Label 5150 5550 0    60   ~ 0
BD2
Text Label 5150 5350 0    60   ~ 0
BD0
Text Label 5150 5150 0    60   ~ 0
BD4
Wire Wire Line
	3350 7100 3750 7100
$Comp
L ICET99_Library:ATF22LV10C-28J U6
U 1 1 5D0AF955
P 4600 1950
F 0 "U6" H 4650 2200 50  0000 L CNN
F 1 "ATF22LV10C-28J" H 4350 1850 50  0000 L CNN
F 2 "SMD_Packages:PLCC-28" H 4600 1900 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0780.pdf" H 4600 1900 50  0001 C CNN
	1    4600 1950
	1    0    0    -1  
$EndComp
Text Label 7700 4150 2    60   ~ 0
ENC0
Text Label 7700 4050 2    60   ~ 0
ENC2
NoConn ~ 4500 1150
Text Label 5400 1750 0    60   ~ 0
DEC1
Text Notes 7250 5100 1    60   ~ 0
pins nearest edge
Text Notes 8850 5000 1    60   ~ 0
pins on interior
Wire Wire Line
	7400 3950 7750 3950
Wire Wire Line
	7500 5250 7750 5250
Wire Wire Line
	7500 5150 7750 5150
Wire Wire Line
	7500 5050 7750 5050
Wire Wire Line
	7500 4950 7750 4950
Wire Wire Line
	7400 4850 7750 4850
Wire Wire Line
	7300 4750 7750 4750
Wire Wire Line
	7300 3850 7750 3850
$Comp
L ICET99_Library:MxMod-Device J2
U 1 1 5CE27641
P 8000 4550
F 0 "J2" H 8050 5475 50  0000 C CNN
F 1 "MxMod-Device" H 8050 5384 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_2x15_Pitch2.54mm" V 8000 4550 50  0001 C CNN
F 3 "~" H 8000 4550 50  0001 C CNN
	1    8000 4550
	1    0    0    -1  
$EndComp
Text Label 2500 1400 0    60   ~ 0
BRESET*
Text Label 2500 1500 0    60   ~ 0
BDBIN
Text Label 2500 1600 0    60   ~ 0
BA15CRUOUT
Text Notes 5650 4750 3    60   ~ 0
D7 at top corner\n(opposite from others)
Wire Wire Line
	7700 4050 7750 4050
Wire Wire Line
	1100 2200 650  2200
Wire Wire Line
	650  2100 1100 2100
Wire Wire Line
	650  1900 1100 1900
Wire Wire Line
	650  1800 1100 1800
Wire Wire Line
	1100 1700 650  1700
Wire Wire Line
	650  1600 1100 1600
Wire Wire Line
	650  1500 1100 1500
Wire Wire Line
	650  1400 1100 1400
Wire Wire Line
	1100 1300 650  1300
Wire Wire Line
	650  1200 1100 1200
Text Label 2500 1200 0    60   ~ 0
BIAQ
Text Label 2500 1300 0    60   ~ 0
BMEMEN*
$Comp
L ICET99_Library:74LVC245A U2
U 1 1 5CFBE103
P 1800 1700
F 0 "U2" H 1800 2100 50  0000 L BNN
F 1 "74LVC245A" H 1750 1300 50  0000 L TNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 1800 1700 50  0001 C CNN
F 3 "" H 1800 1700 50  0001 C CNN
	1    1800 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 4350 3350 4150
$Comp
L Device:R_Small R1
U 1 1 5A6D7B33
P 3350 4450
F 0 "R1" H 3380 4470 50  0000 L CNN
F 1 "3.3K" H 3380 4410 50  0000 L CNN
F 2 "Resistors_SMD:R_0805" H 3350 4450 50  0001 C CNN
F 3 "" H 3350 4450 50  0001 C CNN
	1    3350 4450
	1    0    0    -1  
$EndComp
Text Label 3250 4550 2    60   ~ 0
VCC
$Comp
L Device:R_Small R3
U 1 1 5D25BC20
P 3100 7500
F 0 "R3" H 3130 7520 50  0000 L CNN
F 1 "3.3K" H 3130 7460 50  0000 L CNN
F 2 "Resistors_SMD:R_0805" H 3100 7500 50  0001 C CNN
F 3 "" H 3100 7500 50  0001 C CNN
	1    3100 7500
	1    0    0    -1  
$EndComp
Text Label 3000 7600 2    60   ~ 0
VCC
Wire Wire Line
	3250 4550 3350 4550
Wire Wire Line
	3000 7600 3100 7600
Wire Wire Line
	3100 7300 3100 7400
Wire Wire Line
	3100 7300 3750 7300
Wire Wire Line
	3100 7300 3100 5850
Connection ~ 3100 7300
Wire Wire Line
	3100 5850 3750 5850
Text Label 4800 2550 3    60   ~ 0
GND
Text Label 4600 1150 1    60   ~ 0
CLKIN
Text Label 7700 4350 2    60   ~ 0
CLKIN
$EndSCHEMATC
