module test;
  wire serclk, done;
  reg reset, clk;
  wire shld;
  wire adrin1;
  wire adrin2;
  

// input
  reg [15:0] addrbus = 16'hc003;
// results
    reg [15:0] address;

  reg tests_failed = 0;
  event terminate_sim;
  
  initial begin
     clk = 0;
     reset = 0;
     # 10 reset = 1;
     # 10 reset = 0;
     # 190 $stop;
     
  end
  
  initial @(posedge done) begin
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
  // regular 100MHz clock
  always #5    clk = !clk;

  wire [4:0] count;
  shift_ctrl ctrl1 (reset, clk, shld, serclk, count, done);

  // test it all together
  shift74ls165 test1 (clk, addrbus[15:8], shld, serclk, adrin1);
  shift74ls165 test2 (clk, addrbus[7:0], shld, serclk, adrin2);
  
  shift_ser_in ser1 (adrin1, shld, serclk, address[15:8]);
  shift_ser_in ser2 (adrin2, shld, serclk, address[7:0]);

  initial
          $monitor("At time %t, reset=%d, clk=%d, shld=%d, serclk=%d, adrin1=%d, adrin2=%d, address=%16b %04h",
              $time, reset, clk, shld, serclk, adrin1, adrin2, address, address);
              
endmodule // test