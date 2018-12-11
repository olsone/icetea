module test;

// Test shift_ser_in.v using the simulated  shift74ls165 and a memory cycle scenario
  reg clk = 1;
  reg reset = 1;
  wire shld;
  wire serclk;
  reg [15:0] addrbus = 16'haa55; // input
  
  wire adrin1;
  wire adrin2;
  wire [15:0] address;   // result
  wire addr_reg_done;
  
  reg tests_failed = 0;
  event terminate_sim;
  
  initial begin
     reset = 1;
     # 10 reset = 0;
     # 10 reset = 1;
     # 500
    $display;
     // Assert that read cycle was correct
   if (addr_reg_done)
    $display("pass shift cycle complete");
   else begin
    $display("FAIL shift cycle complete");
		tests_failed = tests_failed + 1;
   end
    
   if (address == addrbus)
      $display("pass Memory Read Cycle");
    else begin
      $display("FAIL Memory Read Cycle. Expected value %4h, got value %4h", addrbus, address);
      tests_failed = tests_failed + 1;
    end
    
    #0 -> terminate_sim;
  end

  // Termination Message  
  initial
  @ (terminate_sim)  begin
   $display ("Terminating simulation");
   if (tests_failed == 0) begin
     $display ("Simulation Result : PASSED");
   end
   else begin
     $display ("Simulation Result : FAILED");
   end
   $finish;
  end
    
  // regular clock
  always #5    clk = !clk;

  // test shift out, shift in pair
  shift_ctrl ctrl1 (.reset(reset), .clk(clk), .o_shld(shld), .o_serclk(serclk), .o_done(addr_reg_done));

  shift74ls165 test1 (clk, addrbus[15:8], shld, serclk, adrin1);
  shift74ls165 test2 (clk, addrbus[7:0], shld, serclk, adrin2);
  
  shift_ser_in ser1 (.i_q(adrin1), .i_reset(shld), .i_serclk(serclk), .o_data(address[15:8]));
  shift_ser_in ser2 (.i_q(adrin2), .i_reset(shld), .i_serclk(serclk), .o_data(address[7:0]));

  
  initial
     $monitor("At time %t, shld = %d, serclk = %d, adrin1 = %d, adrin2 = %d, addr12 = %16b %04h",
              $time, shld, serclk, adrin1, adrin2, address, address);
endmodule // test