/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:       100.000 MHz
 * Requested output frequency:   32.768 MHz
 * Achieved output frequency:    32.812 MHz
 */

module pll_32768(
	input  clock_in,
	output vdpclock_out,
	output sndclock_out,
	output i2sclock_out,
	output locked
	);

wire clock_out;

SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b0001),		// DIVR =  1
		.DIVF(7'b0010100),	// DIVF = 20
		.DIVQ(3'b101),		// DIVQ =  5
		.FILTER_RANGE(3'b100)	// FILTER_RANGE = 4
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(clock_in),
		.PLLOUTCORE(clock_out)
		);

		
	reg [5:0] count;
	assign vdpclock_out = count[2]; // not even close
	assign sndclock_out = count[4]; // 256 KHz, wanted 447 KHz
  // don't use clock_out as a digital signal. Average out the skew.
  assign i2sclock_out = count[1]; // 8.192 MHz

	always @(posedge clock_out)
	    if (!locked)
	        count = 0;
	    else
		    count = count + 1;
		
endmodule
