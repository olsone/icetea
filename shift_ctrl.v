// state and control signals to drive shift_ser_in.
// lsb of count is there to divide the clock by 2.
module shift_ctrl(reset, clk, o_shld, o_serclk, count, o_done);

  parameter WIDTH = 8;
  
  input     reset, clk;
  output    o_shld, o_serclk, o_done;
  output reg [5:0]  count;
  
  wire      reset, clk;
  wire      o_shld, o_serclk, o_done;

  wire [5:0] count_n;
  
  assign o_shld = !(count[5:1] == 5'b00001);
  assign o_serclk = !count[1] || (count[5:1] == 5'b00001);
  assign o_done = count[5] && count[2];
  assign count_n = count + 1;
  
  always @(posedge clk)
  begin
      if (!reset)  // negative logic
				count <= 0; // this could be 1
      else if (!o_done) 
				count <= count_n;
  end
endmodule // shift_ctrl

/*
LV165 shifts on rising edge of serclk. so, sample q on falling serclk.
  timing:
   6 ns  CLK pulse duration min
   8 ns SHLD low 
   5 ns SHLD high before CLK rise
   8 ns Data before SHLD high

# reset shld serclk
0  0     1    1
1  1     0    1  load
2  1     1    1  wait
3  1     1    0  out H
4  1     1    1  shift
...
17 1     1    0  out A
18 1     1    1  done


*/