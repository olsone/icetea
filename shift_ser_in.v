module shift_ser_in(
  input wire i_q,
  input wire i_reset, // negative logic
  input wire i_serclk,
  output wire [WIDTH-1 : 0] o_data);
  
  parameter WIDTH = 8;
  
  reg       [WIDTH-1 : 0] store;
  
  always @(negedge i_serclk or negedge i_reset)
  begin
    if (!i_reset)
      store = 8'bxxxxxxxx;
    else
      store = {store[WIDTH-2 : 0],i_q};
  end
  
  // output wires
  assign o_data = store;

endmodule // shift_ser_in
