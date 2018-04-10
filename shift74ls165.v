module shift74ls165(clk, in, shld, serclk, q7);

  parameter WIDTH = 8;
  
  input     wire clk;
  input     wire [WIDTH-1 : 0] in;
  input     wire shld, serclk;
  output    wire q7;
    
  reg       [WIDTH-1 : 0]  store;
  reg       [1:0] shld_1;
  
  always @(posedge clk)
  begin
     if (!shld)
       store = in;
     // delay shifting by 1 clk (datasheet says min wait time from shld^ and serclk^ is 7ns at 3.3V)
     shld_1 = {shld_1[0],shld};
  end
  
  always @(posedge serclk)
  begin
     if (shld_1[1]) begin
       store = store<<1;
     end
  end
  // output wires

  assign q7 = store[7];

endmodule // shift74ls165
