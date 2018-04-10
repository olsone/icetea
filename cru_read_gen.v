module cru_read_gen(read_request, phi2, cruin, cruclk, address_bus, read_done);
  // Mock generate cru read cycle signals
  //
  
  input wire read_request;
  input wire phi2;
  input wire cruin,
  output wire cruclk, read_done;

  reg [2 : 0] state;
  
  // states
  // 0 read_request received, waiting for phi2
  // 1 read begin
  // 2,3 wait states
  // 4 read ms byte begin
  // 5,6 wait states
  // 7 read done
  initial begin
    state = 7;
  end

  assign read_done  = (state == 3);  
  
  always @(posedge read_request) 
  begin
    state = 0;
  end
  
  // count 10 clocks (100ns) settling time for address
  assign 
  always @(posedge phi2) 
  begin
    if (state != 3) begin
      state = state + 1;
     end  
  end


  endmodule // cru_read_gen