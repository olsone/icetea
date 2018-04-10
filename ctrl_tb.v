module test;
  wire shlf, serclk, done;
  reg reset, clk;
  
  initial begin
     clk = 0;
     reset = 0;
     # 10 reset = 1;
     # 10 reset = 0;
     # 180 $stop;
  end
  
  // regular 100MHz clock
  always #5    clk = !clk;

  wire [4:0] count;
  shift_ctrl ctrl1 (reset, clk, shld, serclk, count, done);

  initial
     $monitor("At time %t, reset = %d, clk = %d, shld=%d, serclk=%d, count=%d, done=%d",
              $time, reset, clk, shld, serclk, count, done);
endmodule // test