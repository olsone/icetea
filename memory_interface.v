module memory_interface(
    // Host control lines and memory bus
    input wire reset,
    input wire clk,
    input wire phi3, 
    input  wire [7:0] i_data_bus,
    output wire [7:0] o_data_bus,
    output reg [15:0] o_address_bus, // decoded cpu address bus
//    output reg [7:0]  o_internal_data_bus,    // synchronized data bus in, for peripherals
    input wire memen, 
    input wire dbin, 
    input wire we,
    input wire a15,
    output wire o_dbdir,
    output wire o_rdbena,
    // Serial interface for address bus
    output wire o_shld, 
    output wire o_serclk, 
    input wire adrin1, 
    input wire adrin2, 
    // test bench monitoring only
    output reg [2:0] state, 
    output wire memory_cycle_begin,

    // SRAM pins
    output wire sram_data_out_en,       // when to switch between in and out on data pins
    output wire [17:0] address_pins,    // address pins of the SRAM
    input  wire [15:0] sram_data_in,
    output wire [15:0] sram_data_out,
    output wire RAMOE,                     // output enable - low to enable
    output wire RAMWE,                     // write enable - low to enable
    output wire RAMCS,                      // chip select - low to enable
    // Memory Mapper (read side) interface
    output reg [3:0] bank_sel,
    input  wire bank_mapped,
    input  wire bank_readonly,
    input  wire [6:0] bank_address,
    // Memory mapped devices
    output wire mm_enable
    );
    
// Service a memory read or write cycle from the CPU.
// TODO:
// keep databus Z unless address is to one of our pages.
// decode memory mapped devices.
// add CRU write to enable DSR roms (in cru_interface.v)
// add GROM and VDP memory access.

  reg  [2:0] state;
  reg  [2:0] nx_state;
  reg  [15:0] addr_reg;

  // logic to SRAM
  reg output_enable;
  reg write_enable;
  reg chip_select;
  reg [15:0] data_read_reg;
  reg [15:0] data_write_reg;
  reg [17:0] external_addr;

  // States
  localparam STATE_IDLE = 0;
  localparam STATE_OBTAIN_ADDRESS = 1;
  localparam STATE_DECODE_ADDRESS = 2;
  localparam STATE_READ_MEM = 3;
  localparam STATE_READ_IO = 4; // A15 changing is a kind of substate
  
  localparam STATE_WRITE_MEM = 6;
  localparam STATE_WRITE_IO = 7;

  // States:
  //
  // STATE_IDLE
  // address is valid (at negedge(phi3) and !memen)
  //   raise memory_cycle_begin.
  // STATE_OBTAIN_ADDRESS
  //   read address from shift registers
  // STATE_DECODE_ADDRESS
  //   read bank register address
  //   write address to either pins in or pins out
  //
  // STATE_READ_MEM
  //   obtain data word from SRAM
  //   wait required?
  // STATE_READ_IO
  //   transfer word to host databus
  //
  // STATE_WRITE_MEM
  //   obtain data word from host databus
  // STATE_WRITE_IO
  //   store data word in SRAM
  //   wait required?


/////////////////////////////////////////////////////////////
// Sequential logic
/////////////////////////////////////////////////////////////

  always @(posedge clk, posedge reset) begin
   if (reset)
     state <= STATE_IDLE;
   else
     state <= nx_state;
  end

/////////////////////////////////////////////////////////////
// Combinatorial logic
/////////////////////////////////////////////////////////////
  
  // maybe waiting for negedge phi3 should be a state.
  // Tie negedge phi3 into the state transition, while only assigning state in the always @(clk)
  // address is settled 100ns after negdge phi1. living dangerously would be to sample address at posedge phi3. (83 ns)
//  always @(negedge phi3) begin
//    if (state == STATE_IDLE)
//      memory_cycle_begin = 1;
//    else
//      memory_cycle_begin = 0;
//  end
  
  assign shift_reset = !(state == STATE_IDLE); // stay in reset (active low) during idle
  assign memory_cycle_begin = (state == STATE_OBTAIN_ADDRESS);
 
/////////////////////////////////////////////////////////////
  // next state logic
/////////////////////////////////////////////////////////////
  
  always @(*)
  case (state)
    // Idle state. an address read can begin on any negedge(phi3)
    STATE_IDLE : 
    begin
			bank_sel <= 4'b0000;
			chip_select <= 0;
			write_enable <= 0;
			output_enable <= 0;        
			o_address_bus <= 16'b0;
      external_addr <= 18'hxxxx;
			
      // (TODO: obtain address even if memen high, for cru cycle.)
      // ignore cru cycle for now:
      // come out of idle on low memen, low phi3
      if (!phi3 && !memen) begin
        nx_state <= STATE_OBTAIN_ADDRESS;
        data_read_reg <= 16'hxxxx;
      end else         
        nx_state = STATE_IDLE; // default
      
    end      
    // Reading Address from shift registers
    // Address lines to LV165A were routed to minimize vias. Reorder bits in fpga.
    //  11  12  13  14   3   4   5   6  LV165A pin
    //   A   B   C   D   E   F   G   H  <- H is the first bit obtained by shifting
    //  A8  A7 A15  A0  A1  A6  A2  A9  <- ADRIN1
    // A10 A11  A3 A13 A14 A12  A4  A5  <- ADRIN2
     
    STATE_OBTAIN_ADDRESS : 
      if (addr_reg_done) begin
        // unscramble address bits
        // 15 : A9 A2 A6 A1,    11 : A0 A15 A7 A8
        //  7 : A5 A4 A12 A14,   3 : A13 A3 A11 A10
        o_address_bus <= {addr_reg[11], addr_reg[12], addr_reg[14], addr_reg[2], addr_reg[6], addr_reg[7], addr_reg[13], addr_reg[9], 
                       addr_reg[8], addr_reg[15], addr_reg[0], addr_reg[1], addr_reg[5], addr_reg[3], addr_reg[4], 1'b0 };
        //o_address_bus <= addr_reg;
        bank_sel <= addr_reg[15:12];
        if (!memen)  // ie not a cru cycle
          nx_state <= STATE_DECODE_ADDRESS;
        else  // cru cycle
          nx_state <= STATE_IDLE;       
      end
      else
        nx_state = STATE_OBTAIN_ADDRESS; // default

    STATE_DECODE_ADDRESS : 
      begin
/* 
          external_addr <= {bank_address[6:0], addr_reg[11:1]};
          if (bank_mapped) begin
            chip_select   <= 1; // positive logic
            output_enable <= dbin; // positive logic
            // TODO: read only banks
            write_enable <= !dbin && !bank_readonly; // positive logic
            // if bank_readonly, the write will still appear on the data pins out, but SRAM will not be enabled to accept it.
            nx_state  = dbin ? STATE_READ_MEM : STATE_WRITE_MEM;
          end 
          else begin
            // memory mapped device?
            
            nx_state  = dbin ? STATE_READ_IO : STATE_WRITE_IO;
          end
 */
          external_addr <= {bank_address[6:0], addr_reg[11:1]};
					chip_select   <= 1; // positive logic
					output_enable <= dbin; // positive logic
					nx_state  = dbin ? STATE_READ_MEM : STATE_WRITE_MEM;
 
        end    
    STATE_READ_MEM : begin
      // fetch word from SRAM
      data_read_reg <= sram_data_in;
      // TODO: wait states?
      nx_state = STATE_IDLE;
      end
    STATE_READ_IO: begin
      // unfinished
      data_read_reg <= 8'h55;
      nx_state = STATE_IDLE;
      end
    
    STATE_WRITE_MEM: begin
			if (a15) 
				data_write_reg[7:0] <= i_data_bus;
			else begin
				data_write_reg[15:8] <= i_data_bus; // when is databus stable? do we need a condition using phi3? 
      end
      write_enable <= !we; // this will write twice, clobbering high byte on the first time through
      
        // wait states? just loop here.
      if (!memen)
        nx_state = STATE_WRITE_MEM;
      else
        nx_state = STATE_IDLE; // we was released  
      
      end
    STATE_WRITE_IO: begin
        nx_state = STATE_IDLE;
      end
    default:
      nx_state = STATE_IDLE;
  endcase

  

  // SRAM interface
	assign sram_data_out_en = (state == STATE_WRITE_MEM || state == STATE_WRITE_IO); // positive logic. turn on output pins when writing data
	assign address_pins = external_addr;
	assign sram_data_out = data_write_reg;

	// LVC245A data bus buffer
	// o_dbdir must only be 0 if one of our addresses is being read, in a memory read cycle.
	//
	// For now, force it to 1 to be safe.
	// dbin=1 indicates the 9900 is accepting input.
	assign o_dbdir = 1'b1 || memen || !dbin;   // 1=reads 4A bus 0=drives 4A bus
	// o_dbdir must be correct when o_rdbena=0
	assign o_rdbena = 0; // LVC245A output enable*

	assign RAMOE = !output_enable; 
	assign RAMWE = !write_enable;
	assign RAMCS = !chip_select;

  // host interface
  // sram to o_internal_data_bus:
  assign o_data_bus = (!memen && dbin && bank_mapped) ? (!a15 ? data_read_reg[15:8] : data_read_reg[7:0]) : 16'hzzzz; 
 
  // memory mapped devices (FORTi card)
  assign mm_enable = !memen && o_address_bus[15:10] == 6'b100001; // 8400 - 87ff


  wire [4:0] count;
  wire shift_reset;
  wire addr_reg_done;
  // shift_reset is negative logic
  shift_ctrl ctrl1 (.reset(shift_reset), .clk(clk), .o_shld(o_shld), .o_serclk(o_serclk), .count(count), .o_done(addr_reg_done));
  shift_ser_in ser1 (.i_q(adrin1), .i_reset(o_shld), .i_serclk(o_serclk), .o_data(addr_reg[15:8]));
  shift_ser_in ser2 (.i_q(adrin2), .i_reset(o_shld), .i_serclk(o_serclk), .o_data(addr_reg[7:0]));
  
  
  
  
endmodule
  