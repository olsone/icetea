module shift_ser_in(in, reset, serclk, out);

  parameter WIDTH = 8;
  
  input     wire in, reset, serclk;
  output    wire [WIDTH-1 : 0] out;
  
  reg       [WIDTH-1 : 0] store;
  
  always @(negedge serclk or negedge reset)
  begin
    if (!reset)
      store = 8'bxxxxxxxx;
    else
      store = {store[WIDTH-2 : 0],in};
  end
  
  // output wires
  assign out = store;

endmodule // shift_ser_in
