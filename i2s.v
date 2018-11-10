module i2s(i_sample, clk, reset, o_mclk, o_lrclk, o_sdin, o_sclk);
// clk and reset are the i2s clk 28.646 MHz and global reset (not synchronous)

// I will take clk at 8.192 MHz
// divide it by 256 to get o_lrclk at 32 kHz, 
// with o_sclk at 7.1615 MHz, or 64 clocks, or 32 bits per sample channel.

// Recommendations for powerup:
// o_mclk be applied for 250 ms before o_lrclk to charge internal caps.
// no action required: device outputs 0 for first 2000 samples.
// Feed 0 data for 10 samples while changing o_lrclk ratio.

  parameter WIDTH = 16;

  input [WIDTH-1 : 0] i_sample;
  input  wire clk, reset;
  output wire o_mclk;
  output wire o_lrclk, o_sdin, o_sclk;
  
  reg [23 : 0 ] i; // 8 bits for stereo cycle, but 24 bits to count until startup charging delay
  reg [WIDTH-1 : 0] shifter; // only 24 bits are significant to CS4344; only WIDTH bits are loaded.
  
  reg resetn = 0;
// combinatorial
  assign o_mclk  = clk;           // 8.192 MHz
  assign o_sclk  = resetn & i[1]; // 2.048 MHz
  assign o_lrclk = resetn & i[7]; // 32 kHz
  assign o_sdin  = resetn & shifter[WIDTH-1];
  // ratio of o_lrclk/o_mclk is 256
  // ratio of  o_sclk/o_mclk is 64
  // o_sdin must be stable on posedge o_sclk.
  
// sequential

  // o_lrclk changes on posedge o_mclk
  always @(posedge reset or posedge clk)
  begin
    if (reset)
    begin
			i <= 24'h000;
			shifter <= 0;
			resetn <= 0;
    end
    else
		begin
		  i = i + 1;
		  if (i[6:0] == 8'h04)
		    // load shift register after 1 idle sclk (mclk/4) cycle
		    shifter = i_sample;
			else if (i[1:0] == 2'b00)
  		  // Shift on every 1 sclk falling edge thereafter
			  shifter <= shifter << 1;
			if (i[23]) // delay at least 250 ms
			  resetn <= 1;
		end
  end
  
endmodule // i2s
