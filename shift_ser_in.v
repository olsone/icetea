module shift_ser_in(
  input wire i_q,
  input wire i_reset, // negative logic, reset on low
  input wire i_serclk,
  output wire [WIDTH-1 : 0] o_data);
  
  parameter WIDTH = 8;
  
  reg       [WIDTH-1 : 0] store;
  // LV165 shifts on rising edge of serclk. so, sample q on falling serclk.
  //
  // symptoms: ADRIN2 looks like inverse of SERCLK. why? meta-stable?
  // ADRIN1 is correct, reading out 48, or A0 unscrambled.
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
