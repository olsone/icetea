module shift_ctrl(reset, clk, o_shld, o_serclk, count, o_done);

  parameter WIDTH = 8;
  
  input     reset, clk;
  output    o_shld, o_serclk, o_done;
  output [4:0]  count;
  
  wire      reset, clk;
  wire      o_shld, o_serclk, o_done;

  reg [4:0] count;
  reg [4:0] count_n;
  
  assign o_shld = !(count == 5'b00000);
  assign o_serclk = o_shld && !count[0];
  assign o_done = count[4];
  assign count_n = count + 1;
  
  always @(posedge clk)
  begin
      if (!reset)  // negative logic
				count <= 0;
      else if (!o_done) 
				count <= count_n;
  end
endmodule // shift_ctrl

/*
# state shld serclk 
0 load   0    0
1 out    1    0 
2 shift  1    1
3 out    1    0
4 shift  1    1
...
15 out   1    0
16 done  x    x


*/