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
  input wire cruclk,
  input wire memen,
  
  input wire [12:0] cru_address, // cpu address lines A3-A14 (indexed 13:1 out there)
  input wire cruout, // cpu address line A15/CRUOUT
  input wire cruin,
  
  // 74LS612 peripheral, connected to memory_interface
  input  wire [3:0] bank_sel,
  output wire bank_mapped,
  output wire bank_readonly,
  output wire [6:0] bank_address
  
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
  
  initial begin
    
    sams_transparent = 0; // use default memory map
    cru_cardsel = 16'h0000; // all cards off. only one at a time should ever be enabled!
    
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
    
    
    {bank_flags[0],  bank_flags[1]}  = {2'b00, 2'b00}; // $0000 console rom
    {bank_flags[2],  bank_flags[3]}  = {2'b10, 2'b10}; // $2000 low ram
    {bank_flags[4],  bank_flags[5]}  = {2'b00, 2'b00}; // $4000 dsr rom or ram
    {bank_flags[6],  bank_flags[7]}  = {2'b00, 2'b00}; // $6000 cart rom
    {bank_flags[8],  bank_flags[9]}  = {2'b00, 2'b00}; // $8000 console memory mapped space
    {bank_flags[10], bank_flags[11]} = {2'b10, 2'b10}; // $A000 high ram
    {bank_flags[12], bank_flags[13]} = {2'b10, 2'b10}; // $C000 high ram
    {bank_flags[14], bank_flags[15]} = {2'b10, 2'b10}; // $E000 high ram
    
    {bank_addresses[0],  bank_addresses[1]}  = {7'h00, 7'h00}; // $0000 console rom
    {bank_addresses[2],  bank_addresses[3]}  = {7'h02, 7'h03}; // $2000 low ram
    {bank_addresses[4],  bank_addresses[5]}  = {7'h00, 7'h00}; // $4000 dsr rom
    {bank_addresses[6],  bank_addresses[7]}  = {7'h00, 7'h00}; // $6000 cart rom
    {bank_addresses[8],  bank_addresses[9]}  = {7'h00, 7'h00}; // $8000 memory mapped space
    {bank_addresses[10], bank_addresses[11]} = {7'h04, 7'h05}; // $A000 high ram
    {bank_addresses[12], bank_addresses[13]} = {7'h06, 7'h06}; // $C000 high ram
    {bank_addresses[14], bank_addresses[15]} = {7'h08, 7'h08}; // $E000 high ram

    
  end
  
  // address banking.
  // there are 16x4k in address space. there are a possible 128 4k pages in SRAM.
  reg [1:0]  bank_flags[16]; // 00 not mapped, 01 unused, 10 ram, 11 rom 
  reg [6:0]  bank_addresses[16]; // upper 7 bits of real address. 74LS612 has 12 bits.

  assign sams_memexp   = (bank_sel[3:1] == 3'b001) || (bank_sel[3] && (bank_sel[2] || bank_sel[1]));
  assign bank_mapped   = sams_transparent ? sams_memexp  : bank_flags[bank_sel][1];
  assign bank_readonly = sams_transparent ? !sams_memexp : bank_flags[bank_sel][0];
  assign bank_address  = sams_transparent ? {3'b000,bank_sel} : bank_addresses[bank_sel];

  always @(posedge cruclk) begin
    if (memen) begin // not a CPU memory cycle
    
    end
  end
endmodule
