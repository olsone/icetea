module mem_write_gen(write_request, phi1, phi2, phi3, data_bus, data_word, memen, we, a15, write_done);
  // Mock generate memory write cycle signals
  // memen will be anded (active low)
  
  input write_request;
  input  phi1, phi2, phi3;
  output memen, we, a15, write_done;
  input  [0:15] data_word; // using TI numbering
  inout  [0:7]  data_bus;   // using TI numbering 

  wire  phi1, phi2, phi3;
  reg [3 : 0] state;
  wire  memen, we, a15, write_done;
  wire a15_hi, a15_lo;
   

  // states
  // wait for: enter state:
  // w_req 0 waiting
  // phi2  1 CC1. memen low. address, data transition, let's output Xs
  // phi3  2  address, data valid. a15 high
  // phi2  3 CC2, we low
  // phi2  4 CC3  
  // phi1  5 we high
  // phi2  6 CC4, a15 low, msb data
  // phi3  7 address, data valid
  // phi2  8 CC5, we low
  // phi2  9 CC6
  // phi1  10 we high
  // phi2  11 memen high, write done, dbin high

  initial begin
    state = 11;
  end

  
  assign memen = (state == 0 || state == 11);
  assign we = !(state == 3 || state == 4 || state == 8 || state == 9);
  assign a15_hi = (state == 2 || state == 3 || state == 4 || state == 5);
  assign a15_lo = (state == 6 || state == 7 || state == 8 || state == 9 || state == 10);
  assign write_done  = (state == 11);
  assign a15 = a15_hi ? 1 : (a15_lo ? 0 : 'z);
  
  assign data_bus = a15_lo ? data_word[0:7] : (a15_hi ? data_word[8:15] : 8'bzzzzzzzz);
  // state transitions  
  always @(posedge write_request) 
  begin
    state = 0;
  end

  always @(posedge phi2) 
  begin
    if (state != 11)
      state = state + 1;
  end

  always @(posedge phi3) 
  begin
    if (state == 1 || state == 6)
      state = state + 1;
  end
  
  always @(posedge phi1) 
  begin
    if (state == 4 || state == 9)
      state = state + 1;
  end

  endmodule // clockgen