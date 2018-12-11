module test;

  reg clk100 = 0;
  reg clk12 = 0;
  
  wire phi1, phi2, phi3, phi4;
  
  wire memen, dbin, we, a15;
  
  // these events are for the mock classes (mem_read_gen, mem_write_gen). They trigger simulated CPU read or write cycles.
  reg read_request, write_request; 
  wire read_done, write_done;
  wire [2:0] read_state;
  wire [3:0] write_state;
  wire serclk, shld, adrin1, adrin2;

  // simulated cpu, doing a read cycle, then a write cycle
  reg [15:0] address_from_cpu = 16'hF000;
  wire [15:0] address_bus; // internal wire to cru, memory mapped devices
  wire [7:0] data_bus;
  wire [15:0] data_word_read_by_cpu;
  reg [15:0] data_word_write_by_cpu;
  
  reg [15:0] expected_data;
  
  reg [4:0] tests_failed, tests_passed;
  event terminate_sim;
  
  wire [7:0] mem_read_in;
  
  assign mem_read_in = a15 ? expected_data[7:0] : expected_data[15:8];
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
    tests_failed = 0;
    tests_passed = 0;
    clk100 = 0;
    clk12 = 0;
    read_request = 1'b0;
    write_request = 0;
    expected_data = 16'haa55;

    read_request = 1;
    # 10 read_request = 0;
    wait(read_done);
    if (data_word_read_by_cpu == expected_data)
    begin
      $display("pass Memory Read Gen");
      tests_passed <= tests_passed + 1;
    end
    else begin
      $display("FAIL Memory Read Gen. Expected value %4h, got value %4h", expected_data, data_word_read_by_cpu);
      tests_failed <= tests_failed + 1;
    end
    #333
    data_word_write_by_cpu = 16'h83e0;

    write_request = 1;
    # 10 write_request = 0;
    wait(write_done);
    
    # 30 -> terminate_sim;
  end
  
  // regular 100MHz clock

  always #5    clk100 = !clk100;

  // 12 MHz clock (ideal period 41.666 ns)  
  always begin // http://www.asic-world.com/verilog/timing_ctrl1.html
   #42 clk12 = !clk12;
   #41 clk12 = !clk12;
   #42 clk12 = !clk12;
   #42 clk12 = !clk12;
   #41 clk12 = !clk12;
   #42 clk12 = !clk12;
  end
  

  // Termination Message  
  always @(terminate_sim)  begin
   $display ("Terminating simulation");
   if (tests_passed == 2 && tests_failed == 0) begin
     $display ("Simulation Result : PASSED");
   end
   else begin
     $display ("Simulation Result : FAILED");
     $display ("tests passed: %d", tests_passed);
     $display ("tests failed: %d", tests_failed);
     
   end
   $display ("###################################################");
   #1 $finish;
  end
 
  // test it in memory_interface
  // Sources:
  clockgen     phases(clk12, phi1, phi2, phi3, phi4);

  // mem_read_gen doesn't use dbus, has single value
  mem_read_gen genread(read_request, phi2, mem_read_in, data_word_read_by_cpu, memen_rd, dbin, a15, read_done, read_state);

  mem_write_gen genwrite(write_request, phi1, phi2, phi3, data_bus, data_word_write_by_cpu, memen_wr, we, a15, write_done, write_state);
  assign memen = memen_rd && memen_wr;

  // module under test:
      
  initial 
    $monitor("At time %t, cpu=%d/%d req=%d/%d %d/%d, phi3=%d, memen=%d dbin=%d we=%d a15=%d, dbus=%2h, dbuf=%4h", 
      $time, read_state, write_state, read_request, read_done, write_request, write_done, phi3, memen, dbin, we, a15, data_bus, data_word_read_by_cpu);

endmodule // test
