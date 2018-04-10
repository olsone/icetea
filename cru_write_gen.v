module cru_write_gen(
  // Mock generate cru write cycle signals
  
  input wire write_request;
  input wire phi2;
  output wire cruout,
  output wire cruclk, write_done;
  output wire [15:0] address_bus
  );
  
  
  reg [2 : 0] state;
  


  // States
  localparam STATE_BEGIN = 0;
  localparam STATE_1 = 1;
  localparam STATE_2 = 2;
  localparam STATE_3 = 3;
  localparam STATE_4 = 4;
  localparam STATE_DONE = 5;
  
  
  initial begin
    state = STATE_DONE;
  end

  assign write_done  = (state == STATE_DONE);
  assign cruclk = !(state == STATE_3);
  
  always @(posedge write_request) 
  begin
    state = STATE_BEGIN;
  end
  
  // count 10 clocks (100ns) settling time for address
  assign 
  always @(phi2) 
  begin
    if (state != STATE_DONE) begin
      state = state + 1;
     end  
  end


  endmodule // cru_write_gen