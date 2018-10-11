module chip (
    // 100MHz clock input
    input  clk,
    // Global internal reset connected to RTS on ch340 and also PMOD[1]
    input greset,
    // Input lines from STM32/Done can be used to signal to Ice40 logic
    input DONE, // could be used as interupt in post programming
    input DBG1, // Could be used to select coms via STM32 or RPi etc..
    // SRAM Memory lines
    output [17:0] ADR,
    output [15:0] DAT,
    output RAMOE,
    output RAMWE,
    output RAMCS,
    output RAMLB,
    output RAMUB,
    // 4A Interface pins
    input  BMEMEN,
    input  BPHI3,
    input  CRUOUT,
    input  BRESET,
    input  BIAQ,
    input  BWE,
    input  BCRUCLK,
    input  BDBIN,
    output BDBDIR,
    output SHLD,
    input  ADRIN2,
    output EN_CRUIN,
    output RDBENA,
    input  ADRIN1,
    output SRCLK,
    input  BCRUIN,
    // All PMOD outputs, with holes
    output [23:0]  PMOD,
    output [7:0]   BDB,
    output [7:0]   PMODC,
    input B1,
    input B2
  );

  // SRAM signals not use in this design, lets set them to default values
  assign RAMLB = 1'b1;
  assign RAMUB = 1'b1;

  // Set unused pmod pins to default
  assign PMOD[23:0] = {24{1'bz}};
  assign PMODC[3:0] = {4{1'bz}};

  // only the databus is bidirectional
  reg        BDBDIR;
  reg  [7:0] bdb_out;
  wire [7:0] bdb_in;
  reg        SHLD;

  // Two way data pins
  SB_IO #(
    .PIN_TYPE(6'b 1010_01),
    .PULLUP(1'b 0)
  ) ios [7:0] (
    .PACKAGE_PIN(BDB[7:0]),
    .OUTPUT_ENABLE(BDBDIR),
    .D_OUT_0(bdb_out),
    .D_IN_0(bdb_in)
  );
    
  // SRAM
  wire [15:0] DAT_in;
  wire [15:0] DAT_out;
  
  SB_IO #(
    .PIN_TYPE(6'b 1010_01),
    .PULLUP(1'b 0)
  ) DAT_ios [15:0] (
    .PACKAGE_PIN(DAT[15:0]),
    .OUTPUT_ENABLE(DAT_out_en),
    .D_OUT_0(DAT_out),
    .D_IN_0(DAT_in)
  );
  

  // Derived Clocks  
  wire sndclk, vdpclk;
  
  pll_ntsc myclk(
    .clock_in (clk),
    .vdpclock_out(vdpclk),
    .sndclock_out(sndclk)
  );
  
  blink my_blink (
    .clk  (vdpclk),
    .rst  (greset),
    .leds (PMODC[7:4]), // red, yellow, green, blue
  );
  wire [7:0] data_bus;      // copy of whats on the data bus from memory_interface
  wire [15:0] address_bus;  // decoded address from memory cycle

  memory_interface mem(
    // Host control lines and memory bus
    .clk(clk),
    .phi3(BPHI3), 
    .data_bus_in(bdb_in),
    .data_bus_out(bdb_out),
    .address_bus(address_bus),
    .data_bus(data_bus),
    .memen(BMEMEN), 
    .dbin(BDBIN), 
    .we(BWE),
    .a15(BCRUOUT),
    .dbdir(BDBDIR),
    .rdbena(RDBENA),
    // Serial interface for address bus
    .shld(SHLD), 
    .serclk(SRCLK), 
    .adrin1(ADRIN1), 
    .adrin2(ADRIN2),
    // SRAM pins
    .sram_data_out_en(DAT_out_en), // when to switch between in and out on data pins
    .address_pins(ADR),    // address pins of the SRAM
    .sram_data_in(DAT_in),
    .sram_data_out(DAT_out),
    .RAMOE(RAMOE),                     // output enable - low to enable
    .RAMWE(RAMWE),                     // write enable - low to enable
    .RAMCS(RAMCS),                      // chip select - low to enable
  );  
  wire en_sound1 = (address_bus[15:8] != 8'h84); // active low
  wire [7:0] sound_sample;
  
  sn76489 sound1(
    .clk(clk),
    .reset(greset),
    .sndclk(sndclk),
    .data_bus(data_bus),
    .cs(en_sound1),
    .we(BWE),
    .sample(sound_sample)   
  );
endmodule