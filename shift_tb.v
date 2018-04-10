module test;

  reg shld = 1;
  reg [15:0] address;

  reg serclk = 0;
  reg clk = 0;
  reg [15:0] addrbus = 16'haa55;
  
  wire adrin1;
  wire adrin2;
  
  reg tests_failed = 0;
  event terminate_sim;
  reg done;
  
  initial begin
     clk = 0;
     serclk = 0;
     # 5 shld = 0;
     # 5 shld = 1;
     # 100
    $display;
     // Assert that read cycle was correct
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
  always #5    serclk = !serclk;

  // test shift out, shift in pair
  shift74ls165 test1 (clk, addrbus[15:8], shld, serclk, adrin1);
  shift74ls165 test2 (clk, addrbus[7:0], shld, serclk, adrin2);
  
  shift_ser_in ser1 (adrin1, shld, serclk, address[15:8]);
  shift_ser_in ser2 (adrin2, shld, serclk, address[7:0]);

  
  initial
     $monitor("At time %t, shld = %d, serclk = %d, adrin1 = %d, adrin2 = %d, addr12 = %16b %04h",
              $time, shld, serclk, adrin1, adrin2, address, address);
endmodule // test