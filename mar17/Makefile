
UNAME_S := $(shell uname -s)

# my verilog testbench targets

clean:
	rm i2s counter shiftreg shift clockdiv square squarei2s

i2s: i2s_tb.v i2s.v
	iverilog -o i2s i2s_tb.v i2s.v
	vvp -n i2s 
	open -a gtkwave i2s.vcd


counter: counter_tb.v counter.v
	iverilog -o counter counter_tb.v counter.v
	vvp -n counter 
	open -a gtkwave counter.vcd

shiftreg: shiftreg_tb.v shiftreg.v
	iverilog -o shiftreg shiftreg_tb.v shiftreg.v
	vvp -n shiftreg 
	open -a gtkwave shiftreg.vcd

shift: shift_tb.v shift.v
	iverilog -o shift shift_tb.v shift.v
	vvp -n shift 
	open -a gtkwave shift.vcd
	
	
clockdiv: clockdiv_tb.v clockdiv.v
	iverilog -o clockdiv clockdiv_tb.v clockdiv.v
	vvp -n clockdiv 
	open -a gtkwave clockdiv.vcd
	
	
square: square_tb.v square.v
	iverilog -o square square_tb.v square.v
	vvp -n square 
	open -a gtkwave square.vcd
	
	
squarei2s: squarei2s_tb.v squarei2s.v clockdiv.v i2s.v
	iverilog -o squarei2s squarei2s_tb.v squarei2s.v clockdiv.v i2s.v
	vvp -n squarei2s 
	open -a gtkwave squarei2s.vcd
	
	
