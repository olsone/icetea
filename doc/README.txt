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

Testbench

brew install icarus-verilog

cat > testbench.mk

shift_tb: shift_ser_in.v shift_tb.v shift74ls165.v
				iverilog -o $@ shift_ser_in.v shift_tb.v shift74ls165.v



make shift_tb

vvp shift_tb



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

BUG Icarus says
  shift_ser_in ser1 (.i_q(adrin1), .i_reset(o_shld), .i_serclk(o_serclk), .o_data(addr_reg[15:8]))
memory_interface.v:297: error: Output port expression must support continuous assignment.
memory_interface.v:297:      : Port 4 (o_data) of shift_ser_in is connected to addr_reg['sd15:'sd8]

addr_reg cannot be a reg. Change to wire. ADDRESS_DECODE can unscramble it into a reg.

BUG
Warning: multiple conflicting drivers for chip.\mem.chip_select:
did you write 'else' not 'else begin/end':
if (reset) begin
  a = 0;
  b = 0;
  end else
  a = 0
b = 0
   
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

================
Signal integrity
================
Confirmed that IAQ is good, and there is a crosstalk glitch in the VB cable.

snapshots 12/4/18 9:24 pm
1) iaq (mistakenly connected on d30 bmemen)

===
decode
56c4 = 7d01 read iaq
56d4 = 7d03 read 
56cc = 7d05 read iaq
56dc = 7d07 read
56e4 = 7d09 read iaq
56f4 = 7d0b read 
4c00 = a001 read
4c00 = a001 write
56ec = 7d0d read

perfect!

0400 = 0001 read
04d0 = 0c03 read iaq
04f0 = 0c0b read iaq

BLWP @>0000

0400 = 0001 read
af3b = 83ff write, so WP = 83E0 
af2b = 83fd write
af33 = 83fb write
0410 = 0003 read 
0409 = 0025 read iaq

0400 = 0001 read
0400 = 0001 read iaq
0410 = 0003 read
0409 = 0025 read
bc18 = c247 read

...

af01 = 83e1 read IAQ
051b = 00b7 read
bc18 = c247 write

0523 = 00b9 read
a77b = 0bff read IAQ
3c29 = c22d write

... last instruction

0c44 = 9801 read 

FREEZING - f18a title displays - the last thing executed was read from GRMRD
icetea is trying to respond at every address.

in VB, srclk glitches, shifting addr right one bit

8641 = 0961 read iaq
af31 = 83eb
a473 = 0a7b

  LIMI 0
  SETO @>A000
  JMP $-4
  
encoded / decoded / memory content  
 7D00  0300
 7D02  0000
56cc 7D04  0720 read iaq
56DC 7D06  A000 read
56E4 7D08  10FD read iaq

4c00 a001
4800 a000

spis addr page
4800 a000 8 wrong
56cc 7d05 c wrong
56cc 7d05 4 wrong
56dc 7d07 7 wrong
56dc 7d07 6 wrong
4800 a000  
56cc 7d05 4 wrong
4c00 a001 0 wrong
56e4 7d09 8 wrong
56cc 7d05 4 wrong

af11 83e3 2 wrong
a62b 037d 2 wrong
261b 0337 2 wrong
2623 0339 2 wrong
af30 83cb a wrong
2721 03a9 2 wrong

Next iteration. use wire addr_in, not reg addr_reg

spis addr page
af11 83e3 a wrong
af21 83e9 a wrong

a62b 037d 2 wrong
4c00 a001 a right
56cc 7d05 7 right
8642 0951 2 wrong
261b 0337 2 wrong

maybe internal cycle is too fast?
8409 0064 xx6x
8421 0068 xx6x 
8403 0070 xx7x
842b 007c xxxC
843a 005e xxxE
2528 028c xxxC
2530 028a xExx
251a 0296 xExx
2522 0298 xExx
2623 0339 2xxx
2633 033a 2x1A
263b 033e xxxE
a618 0347 2xxx

ae2b 837c xx7x
af32 83da xFxx
af11 83e2 Axxx
af21 83e9 AFxx wrong
af31 83ea xFxx
af29 83ec xFEC
af13 83f3 xFxA
af23 83f8 Axxx
af33 83fb xFFx

0cd4 9c02 xx4x  GRMWA
0c44 9800 xExx  GRMRD
read from 9c02: 2 us
write to 9c02: 10 us
read from 9800: 10 us

almost like its not unscrambling the top byte

i moved leds to the bottom of chip.v and in page 0 addresses
8409 0064 x0xx
8419 x0xx
af29 83ec x0xx
af33 83fb x0xx
0cd4 xCxx

test writes to all pages
7D00 LIMI 0
7D02 
7D04 CLR R0

Spi  Addr

56dc 7D06 SETO *R0
56E4 7D08 AI R0,>2000
56f4 7D0A
56ec 7D0C JMP $-8

0400 0 2
0404 1 3
4400 2 2
4404 3 3
1400 4 6
1404 5 7
5400 6 6
5404 7 7
0c00 8 a
0c04 9 b
4c00 a a
4c04 b b
1c00 c e
1c04 d f
5c00 e e
5c04 f f

A2 / BIT 13 is stuck on.
Look at the input to 165.

replaced 165

Measured A2 at 40-pin header. Captured transition 0->1 in 7D07.

It sure looks like it is shorted to A15

try cutting the cruout trace at the source?

oops

8b11 -> 81e2
this should be 83e2
definitely cut a15, but also a6, which was next to it.
this can't be a hardware issue because SPI looks perfect. 
SOLVED (shift register would get stuck by initializer to all 1s)
========================================

RAM
1. CRASH icetea is supplying databus when CPU is reading an instruction from page 0
chip_select logic was backwards!

2. case for chip_select was in its own always block, moved it into main state block.
that fixed an issue that state would get stuck in MEM_WRITE.

returning 1234 from memory shows as 1c84
1234 1c84
8888 2222
4000 0001
2000 0008

 INC *R5       read, inc, write
 MOV *R5,R4    read back
 BL @A2        display
 
 (lsb first, a15 high)
read:  10 00
write: 12 00
read:  00 12

 (lsb first, a15 high)
read:  00 10
write: 02 10
read:  02 10

newest

f000 0f00
0f00 f000
00f0 000f
000f 00f0
8000 0200
4000 0100
2000 0800
1000 0400

rewrote pcf file
was     20563147

8040 4080

rewrote 46305721
8040 8040
2010 2010
0804 0804
0201 0201
all correct

Scope
ABCD CE57
1010 1011 1100 1101
1100 1110 0101 0111

8040 4080
8041 4082

swap test pins:
(msb first)
8040 8040
8041 8041

=============
read 00 20 = 2000
write 01 20 = 2001
read 01 20 = 2001

can see instruction on data bus during IAQ
c115 mov *r5,r4


