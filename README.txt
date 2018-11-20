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

Using PMOD7-12 to connect to the IceTea board
Using PMOD6 to connect to PMOD I2S

========================

Structure

chip.v 
\____pll_ntsc.v
\____memory_interface.v ==/== SRAM
\____sn76489 
     \____i2s






===================


Weird errors

ERROR: Mismatch in directionality for cell port chip.dig_snd_out.mclk: \PMOD [20] <= \dig_snd_out.mclk
caused by assigning Z to it somewhere:
  assign PMOD[20:0] = {20{1'bz}};

Warning: Driver-driver conflict for \dig_snd_out.value [7] between cell $techmap\dig_snd_out.$procdff$1731.Q and constant 1'0 in chip: Resolved using constant.
caused by assigning value=0 in akways(reset) and in always(negedge clk)

shift_ctrl.v:17: Warning: Identifier `\count_n' is implicitly declared.

this might be why shift_reset toggles.
 assign count_n = count + 1; always made shift_reset oscillate.


Shift Registers. Did'nt work consistently until I halved the clock rate to 25 MHz.
It now takes 300 ns to decode the address.
===================

Helpful tools

play many loops of a 1-cycle sample:

sox AKWF_symetric/AKWF_symetric_0001.wav -d repeat 180

Like
AKWF_piano/AKWF_piano_0001.wav
AKWF_bw_saw/AKWF_saw_0002.wav

sox AKWF_cello/AKWF_cello_0003.wav -d repeat 100 tremolo 6

sox AKWF_violin/AKWF_violin_0005.wav -d repeat 100 

dumpwav ~/Downloads/AKWF_violin/AKWF_violin_0005.wav > waves/wave_violin.mem
