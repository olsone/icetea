module memory_interface(
    // Host control lines and memory bus
    input wire reset,
    input wire clk,
    input wire phi3, 
    input  wire [7:0] i_data_bus,
    output wire [7:0] o_data_bus,
    output reg [15:0] o_address_bus, // unscrambled cpu address bus
//    output reg [7:0]  o_internal_data_bus,    // idea. synchronized data bus in, for peripherals
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
    output wire [2:0] o_state, 
    output wire o_memory_cycle_begin,
    output wire [5:0] o_count,
    // SRAM pins
    output wire o_sram_data_out_en,       // when to switch between in and out on data pins
    output wire [17:0] o_sram_address,    // address pins of the 512KB SRAM, 16 bit word address
    input  wire [15:0] i_sram_data,
    output wire [15:0] o_sram_data,
    output wire RAMOE,                     // output enable - low to enable
    output wire RAMWE,                     // write enable - low to enable
    output wire RAMCS,                      // chip select - low to enable
    // cru pins
    input wire  i_cruclk,
    output wire o_cruin,
    output wire o_en_cruin
    );
    
// Service a memory read or write cycle from the CPU.
// TODO:
// keep databus Z unless address is to one of our pages.
// decode memory mapped devices.
// add CRU write to enable DSR roms (in cru_interface.v)
// add GROM and VDP memory access.

  reg  [2:0] state;
  reg  [2:0] nx_state;
  wire  [15:0] addr_in;
  wire shift_reset;
  wire addr_in_done;
  
  // logic to SRAM
  reg output_enable;
  reg write_enable;
  reg chip_select;
  reg [17:0] external_addr;  // address of a 16-bit word
  reg [15:0] data_read_reg;  // 16 bit word
  reg [15:0] data_write_reg; // 16 bit word

	// Memory Mapper interface
	reg [3:0] bank_sel;
	wire bank_mapped;
	wire bank_readonly;
  wire [6:0] bank_address;
	
	// Memory mapped devices
  // 8000 internal RAM
  // 8400 sound
  // 8800 VDPRD
  //    2 VDPSTA
  // 8C00 VDPWD
  //    2 VDPWA
  // 9000 SPCHRD
  // 9400 SPCHWD
  // 9800 GRMRD
  //    2 GRMRA
  // 9C00 GRMWD
  //    2 GRMWA
  
     
  // States
  localparam STATE_IDLE = 0;
  localparam STATE_OBTAIN_ADDRESS = 1;
  localparam STATE_DECODE_ADDRESS = 3;
  localparam STATE_READ_MEM = 2;
  localparam STATE_WRITE_MEM = 7;
  // A15 changing is a kind of substate
  
  localparam STATE_READ_IO =  4; 
  localparam STATE_WRITE_IO = 5;

  // States:
  //
  // STATE_IDLE
  // address is valid (at negedge(phi3) and !memen)
  //   raise o_memory_cycle_begin.
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
   if (reset) begin
     
     state <= STATE_IDLE;
   end else
     state <= nx_state;
  end
  
  assign o_state = state; // debug
  
/////////////////////////////////////////////////////////////
// Combinatorial logic
/////////////////////////////////////////////////////////////
  
  // maybe waiting for negedge phi3 should be a state.
  // Tie negedge phi3 into the state transition, while only assigning state in the always @(clk)
  // address is settled 100ns after negdge phi1. living dangerously would be to sample address at posedge phi3. (83 ns)
//  always @(negedge phi3) begin
//    if (state == STATE_IDLE)
//      o_memory_cycle_begin = 1;
//    else
//      o_memory_cycle_begin = 0;
//  end
  
  assign shift_reset = !(state == STATE_IDLE); // stay in reset (active low) during idle
  assign o_memory_cycle_begin = (state == STATE_OBTAIN_ADDRESS);
 
	// LVC245A data bus buffer
	// o_dbdir must only be 0 if one of our addresses is being read, in a memory read cycle.
	//
	// For now, force it to 1 to be safe.
	// dbin=1 indicates the 9900 is expecting input. But we mustnt respond at every address.
  //assign o_dbdir = 1'b1; // || memen || !dbin;   // 1=reads from 4A bus 0=drives 4A bus
  
  // can we guarantee what state this comes up in?
//  assign o_dbdir    = !(!memen && dbin && bank_mapped && addr_in_done); // 1=reads from 4A bus 0=drives 4A bus
  wire is_memexp;
  assign o_dbdir  = 	!(state == STATE_READ_MEM);
	// o_dbdir must be correct when o_rdbena=0
  assign is_memexp =  o_address_bus[15:13]==3'b001 || o_address_bus[15:13]==3'b101 || o_address_bus[15:14]==2'b11; 
	
	assign o_rdbena = 1'b1; // '!( is_memexp && (state == STATE_READ_MEM || state == STATE_WRITE_MEM)); // LVC245A output enable*
	//problems during startup of console. seems ok later. page is 2 or A somehow.
	//assign o_rdbena = !( is_memexp && (state == STATE_READ_MEM || state == STATE_WRITE_MEM)); // LVC245A output enable*

/////////////////////////////////////////////////////////////
  // next state logic
/////////////////////////////////////////////////////////////
  reg last_phi3;
    
  always @(posedge clk)
  case (state)
    // Idle state. an address read can begin on any negedge(phi3)
    STATE_IDLE : 
    begin
			//bank_sel <= 4'b0000;
			chip_select <= 0;
			write_enable <= 0;
			output_enable <= 0;        
			// good idea to clear evidence from last state?
			o_address_bus <= 16'b0;
      
      //external_addr <= 18'hxxxx;
			
      // (TODO: obtain address even if memen high, for cru cycle.)
      // ignore cru cycle for now:
      // come out of idle on low memen, low going phi3
      if (!phi3 && /* last_phi3 && */  !memen) begin
        nx_state <= STATE_OBTAIN_ADDRESS;
        //data_read_reg <= 16'hxxxx;
      end else         
        nx_state = STATE_IDLE; // default
        
      last_phi3 = phi3;
    end      
    // Reading Address from shift registers
    // Address lines to LV165A were routed to minimize vias. Reorder bits in fpga.
    //  11  12  13  14   3   4   5   6  LV165A pin
    //   A   B   C   D   E   F   G   H  <- H is the first bit obtained by shifting
    //  A8  A7 A15  A0  A1  A6  A2  A9  <- ADRIN1
    // A10 A11  A3 A13 A14 A12  A4  A5  <- ADRIN2
     
    STATE_OBTAIN_ADDRESS : // 001
      if (addr_in_done) begin
        if (!memen)  // ie not a cru cycle
          nx_state <= STATE_DECODE_ADDRESS;
        else  // cru cycle
          nx_state <= STATE_IDLE;       
      end
      else
        nx_state = STATE_OBTAIN_ADDRESS; // default

    STATE_DECODE_ADDRESS : // 011
      begin
        // unscramble address bits
        // 15 : A9 A2 A6 A1,    11 : A0 A15 A7 A8
        //  7 : A5 A4 A12 A14,   3 : A13 A3 A11 A10
        o_address_bus[15:0] = {addr_in[11], addr_in[12], addr_in[14], addr_in[2], 
                                 addr_in[6],  addr_in[7], addr_in[13], addr_in[9], 
                                 addr_in[8], addr_in[15],  addr_in[0], addr_in[1], 
                                 addr_in[5],  addr_in[3],  addr_in[4], 1'b0 };
// if A9 and A6, was enabling the 245
// 6040 0110 0000 0100 0000
// 7000 1110
// 2000 0010
        bank_sel = {addr_in[11], addr_in[12], addr_in[14], addr_in[2]};
        // SRAM pins:
// this can't happen right away from bank_sel
				//external_addr <= {bank_address[6:0], 
				external_addr[17:0] = {3'b000, addr_in[11], addr_in[12], addr_in[14], addr_in[2], 
				                                addr_in[6], addr_in[7], addr_in[13], addr_in[9], 
                                        addr_in[8], addr_in[15], addr_in[0], addr_in[1], 
                                        addr_in[5], addr_in[3], addr_in[4]};
				//chip_select   <= bank_mapped; // positive logic
				chip_select   =  o_address_bus[15:13]==3'b001 || o_address_bus[15:13]==3'b101 || o_address_bus[15:14]==2'b11; 
	 
	 // is_memexp; // positive logic
				output_enable = dbin; // positive logic
//				write_enable  <= !dbin && !bank_readonly; // positive logic
				write_enable  = !dbin; // positive logic
				// if bank_readonly, the write will still appear on the data pins out, but SRAM will not be enabled to accept it.
					
				nx_state  = dbin ? STATE_READ_MEM : STATE_WRITE_MEM;

      end    
    STATE_READ_MEM : begin
				// fetch word from SRAM
				data_read_reg = i_sram_data;
			  // in this state, let combinatorial logic drive o_data_bus.
				
			  // wait states: just loop here.
				if (!memen && dbin)
					nx_state = STATE_READ_MEM;
				else
					nx_state = STATE_IDLE; // memen or dbin was released  
			
      end
    STATE_READ_IO: begin
				// unfinished
				data_read_reg = 8'hc3;
				nx_state = STATE_IDLE;
      end
    
    STATE_WRITE_MEM: begin
				if (!a15) 
					data_write_reg[7:0] = i_data_bus;
				else begin
					data_write_reg[15:8] = i_data_bus; // when is databus stable? do we need a condition using phi3? 
				end
				write_enable = !we; // this will write twice, clobbering high byte on the first time through
			
					// wait states? just loop here.
				if (!memen && !dbin)
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
	assign o_sram_data_out_en = (state == STATE_WRITE_MEM || state == STATE_WRITE_IO); // positive logic. turn on output pins when writing data
	assign o_sram_address = external_addr;
	assign o_sram_data = data_write_reg;

	assign RAMOE = !output_enable; 
	assign RAMWE = !write_enable;
	assign RAMCS = !chip_select;

  // host interface
  // sram to o_internal_data_bus:
  assign o_data_bus =  !o_dbdir ? (a15 ? data_read_reg[15:8] : data_read_reg[7:0]) : 8'h00;
  

  // shift_reset is negative logic
  shift_ctrl ctrl1 (.reset(shift_reset), .clk(clk), .o_shld(o_shld), .o_serclk(o_serclk), .count(o_count), .o_done(addr_in_done));
  shift_ser_in ser1 (.i_q(adrin1), .i_reset(o_shld), .i_serclk(o_serclk), .o_data(addr_in[15:8]));
  shift_ser_in ser2 (.i_q(adrin2), .i_reset(o_shld), .i_serclk(o_serclk), .o_data(addr_in[7:0]));
  
	cru_interface cru(
		.reset(reset),
		.clk(clk),
    .i_memen(memen),		
		.i_cruclk(i_cruclk),

	  .i_cru_address(o_address_bus[13:1]),
	  .i_cruout(a15),
	  .o_cruin(o_cruin),
	  .o_en_cruin(o_en_cruin),
		
		.i_bank_sel(bank_sel),
		.o_bank_mapped(bank_mapped),
		.o_bank_readonly(bank_readonly),
    .o_bank_address(bank_address)     
  );
  
  
endmodule
  