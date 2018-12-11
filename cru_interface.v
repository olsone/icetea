/*  cru_interface implements the paging in and out of DSR roms and SAMS memory, and potentially more.

  In a 9900 computer architecture, CRU "communications register unit" is a separate interface bus between
  the 9900 and 9901 (programmable systems interface) and external peripherals. It uses 
  the A0-A14 address bus and transfers 1-bit serial data over CRUIN, CRUOUT(A15) gated by CRUCLK.

  CRU instructions in the 9900 are: 
    SBO d     set bit one
    SBZ d     set bit zero
    TB  d     test bit (read one bit from cru)
    LDCR s,n  load n cru bits into cru from s (set multiple bits/write to cru)
    STCR s,n  store n cru bits from cru into s (read multiple bits from cru)
  CRU instructions use R12 as the base address (only bits A0-A14)
  For single bit intructioms, the CRU adress is R12 (A0-A14) + d (signed)
   
  Peripherals on the expansion bus each have a CRU base address from $1000 to $1f00, and 
  respond to CRU instructions.
  Each peripheral can have 128 bits of address space.
  Their DSR ROMs are paged in at $4000 by setting a 1 at their CRU base address.
  A device scan pages in each one at a time.
  
  It is customary to enable this bit even if the rom is not used, 
  so that a led will show device activity. For instance direct RS232 access has no
  need of the rom, but blinking the led is desirable.

  Peripherals have other registers mapped into their CRU address space. For instance the 
  RS232 has UART registers.

  They may have registers in the CPU address space as well. Disk controller has WD1771
  IO registers, SAMS has LS612 memory mapper registers.
  
  Some known peripherals:
   >1000 HFDC, WDS, HRD, any storage device taking priority over FDCC
   >1100 FDCC Floppy Disk Controller
   >1300 RS232
  
    LD R12,>1300
    SBO 0    page in the rs232 DSR ROM at >4000. 
    TB  7    test for some bit
    JEQ YES
    SBZ 0    page out
    ...
     
*/

module cru_interface(
  input wire clk,
  input wire reset,
  input wire i_memen,
  input wire i_cruclk,
  
  input wire [12:0] i_cru_address, // cpu address lines A3-A14 (indexed 13:1 out there)
  input wire i_cruout, // cpu address line A15/CRUOUT
  output wire o_cruin,
  output wire o_en_cruin,
  
  // 74LS612 peripheral, connected to memory_interface
  input  wire [3:0] i_bank_sel,
  output wire o_bank_mapped,
  output wire o_bank_readonly,
  output wire [6:0] o_bank_address
  
  );
  
  
  // The CPU memory address model is based on the SuperAMS peripheral.
  // http://www.unige.ch/medecine/nouspikel/ti99/superams.htm
  // which is based on the 74LS612 memory mapper.
  // SuperAMS uses the upper 4 bits of the address, but responds only at $2000,$3000, and $a000-$f000.
  // I will allow paging of 4k at $5000 or $7000 (or anywhere else), as there is one 512K memory
  // used for dsr roms, cartridge rom, and ram.
  //
  // SuperAMS has two cru bits:
  // bit0 - cardsel
  // bit1 - transparent mode (no substitution)
  
  // idea:
  // TODO: A write to an even number register has the side effect of setting the next odd register 1 page higher.
  //
  // to set registers, activate the AMS card (set bit at $1e00) and write 8 bit value to cpu memory $40xx (address bits A11-A14 = bank_sel)
  //
  // figure this out:
  // writes to memory need to pass through to registers in the DSR space. 
  // mem_interface decodes cpu memory cycles...
  // this module could also interpret writes to DSR space, and bank switching module space.

  reg  sams_transparent; // bit1
  wire sams_memexp;
  reg  [15:0] cru_cardsel;    // cru bit 0 for each card to enable it
  
  wire sams_cardsel = cru_cardsel[14]; // cru address $1E00

  // address banking.
  // there are 16x4k in address space. there are a possible 128 4k pages in SRAM.
  reg [1:0]  bank_flags[15:0]; // 00 not mapped, 01 not mapped, 10 ram, 11 rom 
  reg [6:0]  bank_address[15:0]; // upper 7 bits of real address. 74LS612 has 12 bits.
    
    // iceTea uses the SRAM as follows (the first 64k is very like a basic 4A): 
    // 4k page number, use
    // ---------------------
    // 00 reserved (bug catcher) 
    // 02 low ram
    // 04 icetea main dsr rom 
    // 06 cartridge rom
    // 08 reserved
    // 0a high ram
    // 0c high ram
    // 0e high ram
    // 10 superams ram 
    // 7f " 
    //
    // other needs: 
    // SD buffer (reduce demand on BRAM)
    // how does J1 access the sram? can the J1 only access it through an I/O port.
  wire is_memexp;
  
  assign is_memexp = i_bank_sel[3:1]==3'b001 || i_bank_sel[3:1]==3'b101 || i_bank_sel[3:2]==2'b11; 
			
  assign o_bank_mapped   = sams_transparent ? is_memexp  : bank_flags[i_bank_sel][1];
  assign o_bank_readonly = sams_transparent ? !is_memexp : bank_flags[i_bank_sel][0];
  assign o_bank_address  = sams_transparent ? {3'b000,i_bank_sel} : bank_address[i_bank_sel];


  // CRU cycles not implemented
  assign o_en_cruin = 1'b1;
  assign o_cruin    = 1'b0;
  
  always @(posedge i_cruclk or posedge reset) begin
		if (reset) begin
			
			sams_transparent = 1'b1;
			// use default memory map?
			cru_cardsel = 16'h0000; // all cards off. only one at a time should ever be enabled!
			bank_flags[0]  <= 2'b00;
			bank_flags[1]  <= 2'b00; // $0000 console rom
			bank_flags[2]  <= 2'b10;
			bank_flags[3]  <= 2'b10; // $2000 low ram
			bank_flags[4]  <= 2'b00;
			bank_flags[5]  <= 2'b00; // $4000 dsr rom or ram
			bank_flags[6]  <= 2'b00;
			bank_flags[7]  <= 2'b00; // $6000 cart rom
			bank_flags[8]  <= 2'b00;
			bank_flags[9]  <= 2'b00; // $8000 console memory mapped space
			bank_flags[10] <= 2'b10;
			bank_flags[11] <= 2'b10; // $A000 high ram
			bank_flags[12] <= 2'b10;
			bank_flags[13] <= 2'b10; // $C000 high ram
			bank_flags[14] <= 2'b10;
			bank_flags[15] <= 2'b10; // $E000 high ram
		
			bank_address[0]  = 7'h00;
			bank_address[1]  = 7'h00; // $0000 console rom
			bank_address[2]  = 7'h02;
			bank_address[3]  = 7'h03; // $2000 low ram
			bank_address[4]  = 7'h00;
			bank_address[5]  = 7'h00; // $4000 dsr rom
			bank_address[6]  = 7'h00;
			bank_address[7]  = 7'h00; // $6000 cart rom
			bank_address[8]  = 7'h00;
			bank_address[9]  = 7'h00; // $8000 memory mapped space
			bank_address[10] = 7'h04;
			bank_address[11] = 7'h05; // $A000 high ram
			bank_address[12] = 7'h06;
			bank_address[13] = 7'h07; // $C000 high ram
			bank_address[14] = 7'h08;
			bank_address[15] = 7'h09; // $E000 high ram
		
		end else 
			if (i_memen) begin // possibly a CPU memory cycle, but let memory_interface tell us
		
      end
  end
endmodule
