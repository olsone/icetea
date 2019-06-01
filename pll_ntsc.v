/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:       100.000 MHz
 * Requested output frequency:   28.636 MHz
 * Achieved output frequency:    28.646 MHz
 */

// 8x NTSC colorburst frequency
// icepll -o 28.636363 -i 100 -m -f pll_ntsc.v
// Error 0.035%

module pll_ntsc(
	input  clock_in,
	output vdpclock_out,
	output sndclock_out,
	output i2sclock_out,
	output locked
	);

wire clock8x;

SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b0101),		// DIVR =  5
		.DIVF(7'b0110110),	// DIVF = 54
		.DIVQ(3'b101),		// DIVQ =  5
		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(clock_in),
		.PLLOUTCORE(clock8x)
		);
		
	reg [5:0] count;
	assign vdpclock_out = count[2]; // 3.579545 MHz,  actual 3.580750
	assign sndclock_out = count[5]; // 447.443 KHz, actual 447.593 KHz
  assign i2sclock_out = count[0];  // 14 MHz not 28.646 MHz

	always @(posedge clock8x)
	    if (!locked)
	        count = 0;
	    else
		    count = count + 1;
		
endmodule
