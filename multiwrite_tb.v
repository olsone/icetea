
module source(clk, data_bus, addr_bus, dbin, address, data_word);
    input clk, dbin;
    input [2:0] addr_bus, address;
    output [7:0] data_bus;
    input [7:0] data_word;

    wire clk, dbin;
    wire [7:0] data_bus;
    wire [2:0] addr_bus, address;
    wire [7:0] data_word;
  
    wire oe;

    assign oe = (addr_bus == address) && dbin;
    assign data_bus = oe ? data_word : 8'bzzzzzzzz;
endmodule

module sink(clk, data_bus, addr_bus, we, data_word);
    input clk, we;
    input [7:0] data_bus;
    input [2:0] addr_bus;
    output [7:0] data_word;

    wire clk, we;
    wire [7:0] data_bus;
    wire [2:0] addr_bus, address;
    reg [7:0] data_word;
    
    always @(clk) begin // this won't see we on posedge clk
      if (we)
        data_word = data_bus;
    end
endmodule


module mock_cpu(clk, data_bus, addr_bus, dbin, we, data_word_to_write, data_word_read);
    input  clk;
    inout  [7:0] data_bus;
    output [2:0] addr_bus;
    output dbin, we;
    input  [7:0] data_word_to_write;
    output [7:0] data_word_read;

    wire  clk;
    wire [2:0] addr_bus;
    reg  dbin , we;
    reg  [7:0] data_word_read;
    wire [7:0] data_word_to_write;

    reg  [3:0] state = 0;
    
    assign dbin = (state == 0) || (state==4);
    assign we   = (state == 2);
    assign data_bus = we ? data_word_to_write : 8'bzzzzzzzz;
    assign addr_bus = state;
    
    always @(posedge clk) begin
      if (dbin) begin
        data_word_read = data_bus;
      end
      state = state + 1;
    end
    
endmodule

module test;
  reg  clk;
  wire [7:0] data_bus;
  wire [2:0] addr_bus;
  wire dbin;
  wire we;

  wire [7:0] data1 = 8'haa;
  reg  [7:0] data2;
  wire [7:0] data3 =  8'h55;
  reg [7:0] data4;
  wire [7:0] data5 =  8'hc3;
  reg [7:0] data6;
  
  source   mem1(clk, data_bus, addr_bus, dbin, 3'b000, data1);
  source   mem2(clk, data_bus, addr_bus, dbin, 3'b100, data3);
  sink     iothing(clk, data_bus, addr_bus, we, data4);
  mock_cpu cpu(clk, data_bus, addr_bus, dbin, we, data5, data2);
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
    clk = 0;
    #80 $finish;
  end
  
  always #5 clk = !clk;
  
  initial
    $monitor("At time %t, clk=%d we=%d dbin=%d data_bus=%h data2=%h data4=%h", $time, clk, we, dbin, data_bus, data2, data4);
  
endmodule
