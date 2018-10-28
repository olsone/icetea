// TI sound chip
module sn76489(
  input wire clk,
  input wire reset,
  input wire sndclk, // TI-99/4A: 447.443 kHz or ntsc/8
  input wire [7:0] i_data_bus,
  input wire cs, // active low 
  input wire we, // active low
  output wire [7:0] o_sample,
  output wire [3:0] o_bits,
  output wire [9:0] o_counter1
  );

  // interface registers
  reg [1:0] latch;
  reg latch_volume;
  reg [9:0] tone[4]; // noise is tone[3]
  reg [3:0] volume[4];
  reg [7:0] mixer;
  
  // period registers
  reg [9:0] counter[4];
  reg [3:0] bits;
  
  wire noise_bit;
  wire noise_clk = bits[3];
  wire noise_type = tone[3][2]; // periodic or white noise
  lfsr whitenoise(.noiseclk(noise_clk), .noisetype(noise_type), .noise(noise_bit));
 
  assign o_sample = mixer;
  assign o_counter1 = counter[0];
  assign o_bits = {bits[0:2], noise_bit};
  
  // logarithmic scale attenuation in 2dB steps, square wave [2 samples each]
  reg [7:0] samples[32] ;
  initial  begin
    $readmemh("samples.mem",samples);
  end
  // TODO: implement wave tables for sine, triangle, sawtooth, custom

  // delay to let SRAM ready before first access  to samples (or we get all 1s)
  // https://github.com/cliffordwolf/icestorm/issues/76#issuecomment-289270411
	reg resetn = 0;
	reg [7:0] reset_count = 0;

	always @(posedge clk) begin
		if (reset_count == 36) // <-- set this to 36 to work around the issue
			resetn <= 1;
		reset_count <= reset_count + 1;
	end
	  
  wire [1:0] sel = i_data_bus[6:5];
  
  always @(posedge clk) begin : interface
    if (!resetn) begin
      tone[0] <= 10'h1b5; // 256 Hz
      tone[1] <= 10'h1b5;
      tone[2] <= 10'h1b5;
      tone[3] <= 10'h005;
      volume[0] <= 4'h0;
      volume[1] <= 4'hf;
      volume[2] <= 4'hf;
      volume[3] <= 4'hf;
      latch_volume <= 1'b0;
      latch <= 2'b00;
    end
  
    else if (!we) begin
			if (!cs) begin
					if (i_data_bus[7]) begin
					  
						latch = sel;
						latch_volume = i_data_bus[4];
						// Load 4 LSbits to a register
						if (i_data_bus[4])
							volume[sel] <= i_data_bus[3:0];
						else
							tone[sel][3:0] <= i_data_bus[3:0];   
					end
					else begin
						if (latch_volume)
							volume[latch] <= i_data_bus[3:0];
						else begin
							if (latch == 3) // remembered from previous cycle
								tone[3][2:0] <= i_data_bus[2:0]; // noise
							else
								tone[latch][9:4] <= i_data_bus[5:0];
						end
					end
			end
		end
  end
  
  // sndclk is the 447.7 khz clock
  always @(posedge sndclk) begin
    if (reset || !resetn) begin  
      counter[0] = 10'd1;
      counter[1] = 10'd1;
      counter[2] = 10'd1;
      counter[3] = 10'd1;
      bits[0] = 1'b0;
      bits[1] = 1'b0;
      bits[2] = 1'b0;
      bits[3] = 1'b0;
          
    end else begin
			if (counter[0] == 0) 
			begin
				bits[0] = !bits[0];
				counter[0] = tone[0];
			end
			else begin
				counter[0] = counter[0] - 1;
			end
		
			if (counter[1] == 0)
			begin
				bits[1] = !bits[1];
				counter[1] = tone[1];
			end
			else
				counter[1] = counter[1] - 1;
			
			if (counter[2] == 0)
			begin
				bits[2] = !bits[2];
				counter[2] = tone[2];
			end
			else
				counter[2] = counter[2] - 1;
			
			if (counter[3] == 0)
			begin
				bits[3] = !bits[3]; // bits[3] is noiseclk
				case (tone[3][1:0])
				2'b11: counter[3] = tone[2];
				2'b10: counter[3] = 10'h40;
				2'b01: counter[3] = 10'h20;
				2'b00: counter[3] = 10'h10;
				endcase
			end
			else begin
				counter[3] = counter[3] - 1;
			end
      
//      mixer = samples[ {volume[0],bits[0]} ] + samples[ {volume[1],bits[1]}  ] + samples[ {volume[2],bits[2]}  ] + samples[ {volume[3],noise_bit} ];
      // test one channel only
       //mixer = samples[ {4'b0000,bits[0]} ];
       mixer = bits[0] ? 8'h1f : 8'he1;
        end
   
  end
  
endmodule // sn76489

module lfsr(
  input wire noiseclk,
  input wire noisetype, // 1=whitenoise
  output reg noise
  );
  
  reg [14:0] shift;
  
  initial begin
    shift = 0;
    noise = 0;
  end
  
  always @(posedge noiseclk) begin
    noise = shift[0];   
    shift = shift >> 1;
    
    shift[14] = noisetype ? shift[0] ^ shift[4] : shift[0];
  end
  
endmodule // lfsr
