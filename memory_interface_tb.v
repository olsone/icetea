module test;

  reg clk100 = 0;
  reg clk12 = 0;
  
  wire phi1, phi2, phi3, phi4;
  
  wire memen, dbin, we, a15;
  
  // these events are for the mock classes (mem_read_gen, mem_write_gen). They trigger simulated CPU read or write cycles.
  reg read_request, write_request; 
  wire read_done, write_done;
  wire [2:0] rd_state;
  wire [3:0] wr_state;
  wire serclk, shld, adrin1, adrin2;
  reg reset, clk;

  // simulated cpu, doing a read cycle, then a write cycle
  reg [15:0] address_from_cpu;
  wire [15:0] address_bus; // internal wire to cru, memory mapped devices
  wire [7:0] data_bus;
  wire [15:0] data_word_read_by_cpu;
  reg [15:0] data_word_write_by_cpu;
  
  reg [15:0] expected_data;
  reg [15:0] expected_address;
  
  reg [4:0] tests_failed, tests_passed;
  event terminate_sim;
  
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

// test 1
    address_from_cpu = 16'haf11; // scrambled 83e3 (GPLWS R1)
    expected_address = 16'h83e2;
    expected_data = 16'haa55;
    read_request = 1;
    # 10 read_request = 0;
    wait(read_done);
    # 333
    
// test 2
    address_from_cpu = 16'h2623; // scrambled
    expected_address = 16'h0338;
    expected_data = 16'h1234;
    read_request = 1;
    # 10 read_request = 0;
    wait(read_done);
    # 333
    
// test 3
    address_from_cpu = 16'h4800; // scrambled
    expected_address = 16'ha000;
    expected_data = 16'hbeef;
    read_request = 1;
    # 10 read_request = 0;
    wait(read_done);
    # 333

// test 4
    address_from_cpu = 16'h56cc; // scrambled
    expected_address = 16'h7d04;
    expected_data = 16'h8888;
    read_request = 1;
    # 10 read_request = 0;
    wait(read_done);
    # 333
    

// Tests of write    
    data_word_write_by_cpu = 16'h0000;

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
  
  // Assert that read cycle was correct
  always @(posedge read_done) begin
    if (data_word_read_by_cpu == expected_data && data_pins_in == expected_data) begin
      $display("pass Memory Read Data");
      tests_passed = tests_passed + 1;
    end
    else begin
      $display("FAIL Memory Read Data. Expected value %4h, got value %4h. data_pins_in=%4h rd_state=%d", 
        expected_data, data_word_read_by_cpu, data_pins_in, rd_state);
      tests_failed = tests_failed + 1;
    end
    
    // check address
    if (address_bus == expected_address ) begin
      $display("pass Memory Read Address");
      tests_passed = tests_passed + 1;
    end
    else begin
      $display("FAIL Memory Read Address. Expected value %4h, got value %4h.", 
         expected_address, address_bus);
      tests_failed = tests_failed + 1;
    end    
    
    // check address pins (put bank logic here)
    if ({address_pins,1'b0} == expected_address ) begin
      $display("pass Memory Read Address Pins");
      tests_passed = tests_passed + 1;
    end
    else begin
      $display("FAIL Memory Read Address Pins. Expected value %4h, got value %4h.", 
          expected_address, {address_pins,1'b0});
      tests_failed = tests_failed + 1;
    end
  end
  
  // Assert that write cycle was correct
  always @(posedge write_done) begin
    if (data_word_write_by_cpu == data_pins_out) begin
      $display("pass Memory Write Data");
      tests_passed = tests_passed + 1;
    end
    else begin
      $display("FAIL Memory Write Data. Expected value %4h, got value %4h", data_word_write_by_cpu, data_pins_out);
      tests_failed = tests_failed + 1;
    end
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
  shift74ls165 test1 (clk100, address_from_cpu[15:8], shld, serclk, adrin1);
  shift74ls165 test2 (clk100, address_from_cpu[7:0], shld, serclk, adrin2);
  mem_read_gen genread(read_request, phi2, data_bus, data_word_read_by_cpu, memen_rd, dbin, a15, read_done, rd_state);
  // with mem_write_gen and memory_interface (mem_read_gen not at issue),
  // memory_interface_tb.v:19: vvp.tgt error: (implicit) uwire "data_bus" must have a single driver, found (2).
  // Cured by changing data_bus to inout in mem_write_gen.
  mem_write_gen genwrite(write_request, phi1, phi2, phi3, data_bus, data_word_write_by_cpu, memen_wr, we, a15, write_done, wr_state);
  
  // module under test:
  wire [2:0] state;
  assign memen = memen_rd && memen_wr;
  wire  [15:0] data_pins_in;
  wire  [15:0] data_pins_out;
  wire  [17:0] address_pins;
  // SRAM enable lines
  wire OE_pin, WE_pin, CS_pin;
  wire sram_data_out_en;
  // memory mock SRAM
  assign data_pins_in = expected_data;
  wire dbdir;
  
  // cru and memory mapper
  // how to get the decoded cru address on time? 400 ns max from addr valid to cruin valid.
  reg cruclk, cruout, cruin;
  
  wire [3:0] bank_sel;
  wire [6:0] bank_address;
  wire bank_readonly, bank_mapped;
  // memory mapped devices
  wire mm_enable;

  memory_interface mem(
    // Host control lines and memory bus
    .clk(clk100), .phi3(phi3), .o_data_bus(data_bus), .o_address_bus(address_bus), .memen(memen), .dbin(dbin), .we(we), .a15(a15), 
    // Serial interface for address bus
    .o_shld(shld), .o_serclk(serclk), .adrin1(adrin1), .adrin2(adrin2), 
    // test bench monitoring only
    .o_state(state),
    .o_dbdir(dbdir),
    // SRAM pins
    .o_sram_data_out_en(sram_data_out_en), .o_sram_address(address_pins), .i_sram_data(data_pins_in), .o_sram_data(data_pins_out),
    .RAMOE(OE_pin), .RAMWE(WE_pin), .RAMCS(CS_pin)
    // memory mapper
//    .bank_sel(bank_sel), .bank_mapped(bank_mapped), .bank_readonly(bank_readonly), .bank_address(bank_address),
    // memory mapped devices
//    .mm_enable(mm_enable)
    );
    
  initial 
    $monitor("At time %t, cpu=%d/%d req=%d/%d %d/%d, phi3=%d, memen=%d dbin=%d we=%d a15=%d, dbdir=%d dbus=%2h dbuf=%4h state=%2b sram_addr=%x sram_in=%4x sram_out=%4x", 
      $time, rd_state, wr_state, read_request, read_done, write_request, write_done, phi3, memen, dbin, we, a15, dbdir, data_bus, data_word_read_by_cpu, state, address_pins, data_pins_in, data_pins_out);
endmodule // test
