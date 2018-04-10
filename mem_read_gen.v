module mem_read_gen(read_request, phi2, data_bus, data_word, memen, dbin, a15, read_done);
  // Mock generate memory read cycle signals
  //
  // memen will be anded (active low)
  
  input read_request;
  input  phi2;
  output memen, dbin, a15, read_done;
  output  [0:15] data_word; // using TI numbering
  input [0:7] data_bus;   // using TI numbering 

  wire phi2;
  reg [2 : 0] state;
  wire  memen, dbin, a15, done;
  wire a15_lo, a15_hi;
  
  reg  [0:15] data_word; // using TI numbering
  wire [0:7] data_bus;   // using TI numbering 

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

  assign memen =  (state == 0 || state == 7);
  assign dbin  = !(state == 0 || state == 7);
  assign a15_hi   = (state == 1 || state == 2 || state == 3);
  assign a15_lo   = (state == 4 || state == 5 || state == 6);
  assign read_done  = (state == 7);  
  assign a15 = a15_hi ? 1 : (a15_lo ? 0 : 'z);
  
  always @(posedge read_request) 
  begin
    state = 0;
  end

  always @(posedge phi2) 
  begin
    if (state != 7) begin
      state = state + 1;
      if (!a15)
        data_word[0:7] = data_bus;
      else
        data_word[8:15] = data_bus;
     end  
  end


  endmodule // clockgen