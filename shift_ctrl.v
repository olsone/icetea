module shift_ctrl(reset, clk, shld, serclk, count, done);

  parameter WIDTH = 8;
  
  input     reset, clk;
  output    shld, serclk, done;
  output [4:0]  count;
  
  wire      reset, clk;
  reg       shld, serclk, done;

  reg [4:0] count;  
  
  always @(posedge clk)
  begin
      if (reset) 
      begin
         count = 0;
         done = 0;
         shld = 0;
         serclk = 0;
      end
      if (!reset && !done) 
      begin
        serclk = !serclk;
        if (!shld)
          shld = 1;
        else
        begin
          count = count + 1;
          shld = count > 0;
          done = (count == 16);
        end
      end
  end

endmodule // shift_ctrl
