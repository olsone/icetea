module shift_ser_in(
  input wire i_q,
  input wire i_reset, // negative logic, reset on low
  input wire i_serclk,
  output reg [WIDTH-1 : 0] o_data);
  
  parameter WIDTH = 8;
  
  //reg       [WIDTH-1 : 0] store;
  // LV165 shifts on rising edge of serclk. so, sample q on falling serclk.
  //
  // symptoms: at 50 MHz, ADRIN2 looks like inverse of SERCLK. why? meta-stable?
  // ADRIN1 is correct, reading out 48, or A0 unscrambled.
  // Both are fine when serclk is 25MHz. 50 MHz is close to max for lv165.
  // time from SRCLK rising is 7 ns to data on adrin1/2
  always @(negedge i_serclk or negedge i_reset)
  begin
    if (!i_reset)
      o_data = 8'hff;
    else
      o_data = {o_data[WIDTH-2 : 0],i_q};
  end

endmodule // shift_ser_in
