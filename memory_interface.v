module memory_interface(
    // Host control lines and memory bus
    input wire clk,
    input wire phi3, 
    input  wire [7:0] data_bus_in,
    output wire [7:0] data_bus_out,
    output reg [15:0] address_bus, // decoded cpu address bus
    output reg [7:0] data_bus,    // synchronized data bus in, for peripherals
    input wire memen, 
    input wire dbin, 
    input wire we,
    input wire a15,
    output wire dbdir,
    output reg rdbena,
    // Serial interface for address bus
    output wire shld, 
    output wire serclk, 
    input wire adrin1, 
    input wire adrin2, 
    // test bench monitoring only
    output [2:0] state, 
    output memory_cycle_begin,

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
  reg  [15:0] addr_reg;

  // logic to SRAM
  reg output_enable;
  reg write_enable;
  reg chip_select;
  reg [15:0] data_read_reg;
  reg [15:0] data_write_reg;
  reg [17:0] decoded_addr;

  // States
  localparam STATE_IDLE = 0;
  localparam STATE_OBTAIN_ADDRESS = 1;
  localparam STATE_DECODE_ADDRESS = 2;
  localparam STATE_READ1 = 3;
  localparam STATE_READ2 = 4; // A15 changing is a kind of substate
  
  localparam STATE_WRITE1 = 6;
  localparam STATE_WRITE2 = 7;

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
  // STATE_READ1
  //   obtain data word from SRAM
  //   wait required?
  // STATE_READ2
  //   transfer word to host databus
  //
  // STATE_WRITE1
  //   obtain data word from host databus
  // STATE_WRITE2
  //   store data word in SRAM
  //   wait required?


  initial begin
    state <= STATE_IDLE;
    shift_reset <= 1;
    bank_sel <= 0;
    chip_select <= 0;
    write_enable <= 0;
    output_enable <= 0;        
    rdbena <= 1; // negative logic
    address_bus <= 16'b0;
  end

  reg   memory_cycle_begin;
  
  // Tie negedge phi3 into the state transition, while only assigning state in the always @(clk)
  // address is settled 100ns after negdge phi1. living dangerously would be to sample address at posedge phi3. (83 ns)
  always @(negedge phi3) begin
    if (state == STATE_IDLE)
      memory_cycle_begin = 1;
    else
      memory_cycle_begin = 0;
  end
  
      
  always @(posedge memen) begin
    state <= STATE_IDLE;
    shift_reset <= 1;
    decoded_addr <= 18'hxxxx;
    output_enable <= 0;
    write_enable <= 0;
    chip_select <= 0;
  end
  
  always @(posedge clk) begin
    case (state)
    // Idle state. an address read can begin on any negedge(phi3)
    STATE_IDLE : 
      if (memory_cycle_begin) begin
        shift_reset <= 0; // let it run
        data_read_reg <= 16'hxxxx;
        state = STATE_OBTAIN_ADDRESS;
      end else begin
        // Idle
        chip_select <= 0;
        write_enable <= 0;
        output_enable <= 0;
        rdbena <= 1;
      end
    // Reading Address from shift registers
    STATE_OBTAIN_ADDRESS : 
      if (addr_reg_done) begin
        // TODO: unscramble address bits
        // 15 : A9 A2 A6 A1,    11 : A0 A15 A7 A8
        //  7 : A5 A4 A12 A14,   3 : A13 A3 A11 A10
        //address_bus = {addr_reg[11], addr_reg[12], addr_reg[14], addr_reg[2], addr_reg[6], addr_reg[7], addr_reg[13], addr_reg[9], 
        //               addr_reg[8], addr_reg[15], addr_reg[0], addr_reg[1], addr_reg[5], addr_reg[3], addr_reg[4], 1'b0 };
        address_bus <= addr_reg;
        memory_cycle_begin <= 0;
        bank_sel <= addr_reg[15:12];
        if (!memen)  
          state = STATE_DECODE_ADDRESS;
        else
          state = STATE_IDLE;        
      end
    STATE_DECODE_ADDRESS: 
      begin
          decoded_addr <= {bank_address[6:0], addr_reg[11:1]};
          if (bank_mapped) begin
            chip_select   <= 1; // positive logic
            output_enable <= dbin; // positive logic
            rdbena <= 0; // negative logic
            write_enable <= !dbin && !bank_readonly; // positive logic
            // if readonly, the write will still appear on the data pins out, but it will not enter the SRAM.
            state  = dbin ? STATE_READ1 : STATE_WRITE1;
          end 
          else begin
            // memory mapped device?
            
            state  = dbin ? STATE_READ2 : STATE_WRITE2;
          end
        end    
    STATE_READ1 : begin
      // fetch word from SRAM
      // TODO: wait states?
      data_read_reg <= sram_data_in;
      state = STATE_READ2;
      end
    STATE_READ2: begin
      end
    
    STATE_WRITE1:
      if (we) begin
        if (a15) data_write_reg[7:0] = data_bus_in;
        if (!a15)  begin
          data_write_reg[15:8] <= data_bus_in; // when is databus stable? do we need a condition using phi3?
          state = STATE_WRITE2;
        end
      end
    STATE_WRITE2: begin
        write_enable = 0;
      end

    endcase
  end

  // SRAM interface
    assign sram_data_out_en = (state == STATE_WRITE1 || state == STATE_WRITE2); // positive logic. turn on output pins when writing data
    assign address_pins = decoded_addr;
    assign sram_data_out = data_write_reg;
    
    assign dbdir = memen || !dbin;   // 1=reads 4A bus 0=drives 4A bus
    // dbdir must be correct when rdbena=0 (active low, connected to databus)
    
    assign RAMOE = !output_enable;
    assign RAMWE = !write_enable;
    assign RAMCS = !chip_select;

  // host interface
  // sram to data_bus:
  assign data_bus_out = (!memen && dbin && bank_mapped) ? (!a15 ? data_read_reg[15:8] : data_read_reg[7:0]) : 16'hzzzz; 
 
  // memory mapped devices (FORTi card)
  assign mm_enable = !memen && address_bus[15:10] == 3'b100;


  wire [4:0] count;
  reg shift_reset;
  wire addr_reg_done;
  
  shift_ctrl ctrl1 (.reset(shift_reset), .clk(clk), .shld(shld), .serclk(serclk), .count(count), .done(addr_reg_done));
  shift_ser_in ser1 (adrin1, shld, serclk, addr_reg[15:8]);
  shift_ser_in ser2 (adrin2, shld, serclk, addr_reg[7:0]);
  
  
  
  
endmodule
  