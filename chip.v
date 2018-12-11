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
    input  BCRUOUT, // A15
    input  BRESET,
    input  BIAQ,
    input  BWE,
    input  BDBIN,
    output DBDIR,
    output RDBENA,
    // address bus multiplexer
    output SHLD,
    output SRCLK,
    input  ADRIN1,
    input  ADRIN2,
    // 4A cru interface
    input  BCRUCLK,
    output wire BCRUIN,
    output wire EN_CRUIN,
    // All PMOD outputs, with holes
    output [23:0]  PMOD,
    output [7:0]   BDB,
    output [7:0]   PMODC, // PMOD13, PMOD14/SPI/LEDs
    input B1,
    input B2
  );

  // SRAM signals not use in this design, lets set them to default values
  assign RAMLB = 1'b1;
  assign RAMUB = 1'b1;

  // Set unused pmod pins to default
  assign PMOD[15:8] = {8{1'b0}};
  assign PMOD[ 7:0] = {8{1'b0}};
  //assign PMOD[23:20] = {4{1'bz}}; // PMOD5
  assign PMODC[3:0] = {4{1'b0}}; // PMOD13
   
  // only the databus is bidirectional
  wire        DBDIR;
  wire  [7:0] bdb_out;
  wire  [7:0] bdb_in;
  wire        SHLD;

  // Two way data pins
  SB_IO #(
    .PIN_TYPE(6'b 1010_01),
    .PULLUP(1'b 0)
  ) ios [7:0] (
    .PACKAGE_PIN(BDB[7:0]),
    .OUTPUT_ENABLE(!DBDIR), // DBDIR=0 output to 4A DBDIR=1 input from 4A (safe)
    .D_OUT_0(bdb_out),
    .D_IN_0(bdb_in)
  );
    
  // SRAM
  wire [15:0] DAT_in;
  wire [15:0] DAT_out;
  wire DAT_out_en;
  
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
  wire sndclk, vdpclk, i2sclk;
  
  pll_32768 myclk(
    .clock_in (clk),
    .vdpclock_out(vdpclk),
    .sndclock_out(sndclk),
    .i2sclock_out(i2sclk)
  );
  

  wire [7:0] data_bus;      // copy of whats on the data bus from memory_interface
  wire [15:0] address_bus;  // decoded address from memory cycle
  wire [2:0] mem_state;
  //wire [5:0] count;
  
  memory_interface mem(
    .reset(greset),
    .clk(clk),
    // Host control lines and memory bus
    .phi3(BPHI3), 
    .i_data_bus(bdb_in),
    .o_data_bus(bdb_out),
    .o_address_bus(address_bus),
//    .o_internal_data_bus(data_bus),
    .memen(BMEMEN), 
    .dbin(BDBIN), 
    .we(BWE),
    .a15(BCRUOUT),
    .o_dbdir(DBDIR),
    .o_rdbena(RDBENA),
    // Serial interface for address bus
    .o_shld(SHLD), 
    .o_serclk(SRCLK), 
    .adrin1(ADRIN1), 
    .adrin2(ADRIN2),
    //.o_count(count),
     // SRAM pins
    .o_sram_data_out_en(DAT_out_en), // when to switch between in and out on data pins
    .o_sram_address(ADR),    // address pins of the SRAM
    .i_sram_data(DAT_in),
    .o_sram_data(DAT_out),
    .RAMOE(RAMOE),                     // output enable - low to enable
    .RAMWE(RAMWE),                     // write enable - low to enable
    .RAMCS(RAMCS),                      // chip select - low to enable
    // cru pind
    .i_cruclk(BCRUCLK),
    .o_cruin(BCRUIN),
    .o_en_cruin(EN_CRUIN),

    // debugging
    .o_state(mem_state)
  );  
  
  // memory mapped devices (FORTi card)
  
  wire en_sound1 = !BMEMEN && (address_bus[15:8] != 8'h84); // active low. || !a15

  wire we_sound = BWE;
  
  wire [15:0] sound_sample;
  wire [3:0] sndbits;
  
  sn76489 sound1(
    .clk(clk),
    .reset(greset),
    .sndclk(sndclk),
    .sndclk32(i2sclk),
    .i_data_bus(bdb_in),
    .i_cs(en_sound1),
    .i_we(we_sound),
    .o_sample(sound_sample),
    .o_bits(sndbits)   
  );

  wire mclk, lrclk, sdin, sclk;

  
  i2s snd_dac(
		.i_sample(sound_sample),
		.clk(i2sclk), // 28.576 MHz is in between recommended 24.576 or 32.768 (96 kHz or 128kHz Fs)
		.reset(greset), 
		// outputs
		.o_mclk (mclk), 
		.o_lrclk(lrclk), 
		.o_sclk (sclk),
		.o_sdin (sdin)
	);
/* 
  i2s connected to PMOD13
  assign PMODC[0] = mclk;
  assign PMODC[1] = lrclk;
  assign PMODC[2] = sdin;
  assign PMODC[3] = sclk;
 */
  
  // PMOD5/6

  assign PMOD[16] = mem_state[2];
  assign PMOD[17] = mem_state[1];
  assign PMOD[18] = mem_state[0];
  assign PMOD[19] = 1'b1;

  // pmod6  

//i2s
/*
  assign PMOD[20] = mclk;
  assign PMOD[21] = lrclk;
  assign PMOD[22] = sclk;
  assign PMOD[23] = sdin;  
*/

  assign PMOD[20] = address_bus[15];
  assign PMOD[21] = address_bus[14];
  assign PMOD[22] = address_bus[13];
  assign PMOD[23] = address_bus[12];
 
 
/* 
  assign PMOD[20] = address_bus[11];
  assign PMOD[21] = address_bus[10];
  assign PMOD[22] = address_bus[9];
  assign PMOD[23] = address_bus[8];  

  assign PMOD[20] = address_bus[7];
  assign PMOD[21] = address_bus[6];
  assign PMOD[22] = address_bus[5];
  assign PMOD[23] = address_bus[4];  

  assign PMOD[20] = address_bus[3];
  assign PMOD[21] = address_bus[2];
  assign PMOD[22] = address_bus[1];
  assign PMOD[23] = address_bus[0];  

*/

// test program is reading 7D06 and writing A000
//   assign PMOD[15:8] = address_bus[15:8]; // says A0 or 7D correctly
// when i2s is connected to pmod, then MSB adress_bus says AE or 7F
//   assign PMOD[7:0] = address_bus[7:0]; // says 00 or 06 appropriately
// when i2s is connected to pmod, then LSB adress_bus says 48

  // LEDs indicate access to test addresses
  addr_leds my_leds(
    .i_address(address_bus),
    .o_leds (PMODC[7:4]), // red, yellow, green, blue
  );

// LEDs make counting pattern to signal life        
/* 
  blink my_blink (
    .clk  (vdpclk),
    .rst  (greset),
    .leds (PMODC[7:4]), // red, yellow, green, blue
  );
 */
  
endmodule