module squarei2s(clk, reset, period, mclk, lrclk, sdin, sclk);

// join clockdiv to i2s

parameter WIDTH = 16;

input clk, reset;
input [WIDTH-1 : 0] period;
output               mclk, lrclk, sdin, sclk;


reg [WIDTH-1:0] value;
i2s c1(value, clk, reset, mclk, lrclk, sdin, sclk);

// run state off lrclk! mclk/256. middle c period = 90
wire state;
clockdiv sq1(lrclk, reset, period, state);

always @( *)
begin
	value = state ? 16'h2000 : 16'h7fff;
end




endmodule // square