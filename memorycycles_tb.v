module test;
  // test: generate the needed bus control signals for read and write cycles. 

  reg clk100;
  reg clk12;
  
  wire phi1, phi2, phi3, phi4;
  
  wire memen_rd, memen_wr, dbin, we, a15;
  reg [0:15]addr_bus;
  reg [0:15]data_word_read_by_cpu;
  reg [0:15]data_word_write_by_cpu;
  wire [0:7] data_bus;
  
  reg read_request, write_request;
  wire read_done, write_done;
  wire memen;
  
  assign memen = memen_rd && memen_wr;
  //assign a15   = a15_rd || a15_wr;
  
  initial begin
     clk100 = 0;
     clk12 = 0;
     data_word_write_by_cpu = 16'hc003;
     read_request  = 0;
     write_request = 0;
     
     #10 read_request = 1;
     #10  read_request = 0;
     # 280 write_request = 1;
     # 10 write_request = 0;
     # 280 $stop;
  end
  
  // regular clock
  always #5    clk100 = !clk100;
//  always #41.666 clk12 = !clk12;
  always #5 clk12 = !clk12;// temporary speedup
  
  clockgen      phases(clk12, phi1, phi2, phi3, phi4);
  mem_read_gen  genread(read_request, phi2, data_bus, data_word_read_by_cpu, memen_rd, dbin, a15, read_done);
  mem_write_gen genwrite(write_request, phi1, phi2, phi3, data_bus, data_word_write_by_cpu, memen_wr, we, a15, write_done);
    

  initial
//     $monitor("At time %t, %d phases %d %d %d %d %d %d", $time, clk12, phi1, phi2, phi3, phi4, read_request, read_done);
     $monitor("At time %t, phi2=%d rdreq=%d/%d wrreg=%d/%d memen=%d a15=%d dbin=%d we=%d data_bus=%02h", $time, phi3, read_request, read_done, write_request, write_done, memen, a15, dbin, we, data_bus);
endmodule // test