\ TLC5940 LED driver 16 outputs


\ TLC5940 has per output 12 bits of grayscale (duty cycle).
\ HDR_J3:   VCC GND | BLANK XLAT SCLK SIN VPRG GSCLK nc nc 
\ TLC5940:  21  22 |    23   24   25  26   27    18  -  -
\ direction (all outputs) $fc

\ J1A port addresses:
\ 0040  6     r/w     J3 GPIO
\ 0080  7     r/w     J3 direction

$0040 constant J3    
$0080 constant J3DIR 
$0080 constant BLANK 
$0040 constant XLAT
$0020 constant SCLK
$0010 constant SIN
$0008 constant VPRG
$0004 constant GSCLK

variable grayscale 16 cells allot

\ ( -- ) write grayscale bits to TLC5940 (left justified 12 bit values)
\ uses 1 stack word as shift register.
\
\ mask $10 gets the SIN bit out of a true flag
\ timing considerations: 
\ SIN to SCLK ↑     5 ns
\ SCLK H/L         16 ns
\ XLAT H/L 
\ SCLK ↓ to XLAT ↑ 10 ns
\ None of these will require any delay noops on J1a.
\ Measured:
\ XLAT pulse size     145 ns
\ 1 bit cycle         900 ns
\ 192 bit cycles   190    us

: gray!
	BLANK J3 io!
    16 0 do
    	grayscale i + @       ( -- n ) 
    	12 0 do
        	dup 0< SIN and 
        	BLANK or
        	dup     J3 io!             
			swap 2* swap
        	SCLK or J3 io!               
      	loop
    loop
    BLANK         J3 io!
	BLANK XLAT or J3 io!
    BLANK         J3 io!
	0 J3 io!
;

variable lvl 
$f000 lvl !

: gray.init
    $fc J3DIR io!  
	16 0 do 
		lvl @ grayscale i + ! 
	loop
	gray!
;

: gray.clks
	32767 0 do
		0     J3 io!
		GSCLK J3 io!
	loop
;

: gray
	begin
		gray.init
		gray.clks
	0 until
;

: gray
	begin
		gray.init
		gray.clks
	0 until
;

: ramp
	begin
	    $f000 0 do
			i lvl !
			gray.init
			gray.clks
		$100 +loop
	    $100 $f000 do
			i lvl !
			gray.init
			gray.clks
		$-100 +loop
	0 until
;


\ thoughts
\ Riref = 640 in the data sheet	gives total current or 1 current?
\ duty cycle
\ capacitance needed - my finger is sufficient
\ is too much or too little current being sunk
\ w/o gsclk it still comes on.. it fades out eventually

