===== Compiling =======


To compile chip.bin:

make

To send it to BlackIce-II (standard firmware)


Terminal 1:
cat < /dev/cu.usbmodem1421
or:
make tty

Terminal 2:
stty -f /dev/cu.usbmodem1421 raw
cat chip.bin > /dev/cu.usbmodem1421
or:
make upload

stored in blackice.mk

======= PLL =========

Colorburst frequency of 315/88 MHz is made (x8 factor) by:

icepll -o 28.636363 -i 100 -m -f pll_ntsc.v


F_PLLIN:   100.000 MHz (given)
F_PLLOUT:   28.636 MHz (requested)
F_PLLOUT:   28.646 MHz (achieved)

FEEDBACK: SIMPLE
F_PFD:   16.667 MHz
F_VCO:  916.667 MHz

DIVR:  5 (4'b0101)
DIVF: 54 (7'b0110110)
DIVQ:  5 (3'b101)

FILTER_RANGE: 1 (3'b001)

	reg [5:0] count;

//	assign gplclock_out = count[2]; // 3.579545 MHz,  actual 3.580750
	assign sndclock_out = count[5]; // 447.443 KHz, actual 447.593 KHz

	always @(posedge clock8x)
	    if (!locked)
	        count = 0;
	    else
		    count <= count + 1;

========================

Pin assignments in icetea.pcf are customized from blaceice-ii.pcf

========================

Structure

chip.v 
\____pll_ntsc.v
\____memory_interface.v ==/== SRAM
\____