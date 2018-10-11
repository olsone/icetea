// TI sound chip
module sn76489(
  input wire clk,
  input wire reset,
  input wire sndclk, // TI-99/4A: 447.443 kHz or ntsc/8
  input wire [7:0] data_bus,
  input wire cs, // active low 
  input wire we, // active low
  output wire [7:0] sample,
  output wire bit1,
  output wire [9:0] counter1
  );

  // interface registers
  reg [1:0] latch;
  reg latch_volume;
  reg [9:0] tone[4]; // noise is tone[3]
  reg [3:0] volume[4];
  reg [7:0] mixer;
  
  // period registers
  reg [9:0] counter[4];
  reg bits[4];
  
  wire noise_bit;
  wire noise_clk = bits[3];
  wire noise_type = tone[3][2];
  lfsr whitenoise(.noiseclk(noise_clk), .noisetype(noise_type), .noise(noise_bit));
 
  assign sample = mixer;
  assign counter1 = counter[0];
  assign bit1 = bits[0];

  localparam [32]  samples = {
    8'h1f, 8'he1,
    8'h19, 8'he7,
    8'h14, 8'hec,
    8'h10, 8'hf0,
    8'h0d, 8'hf3,
    8'h0a, 8'hf6,
    8'hf8, 8'hf8,
    8'h06, 8'hfa,
    8'h05, 8'hfb,
    8'h04, 8'hfc,
    8'h03, 8'hfd,
    8'h03, 8'hfd,
    8'h02, 8'hfe,
    8'h02, 8'hfe,
    8'h01, 8'hff,
    8'h00, 8'h00
  };
  // TODO: scale clock to exact speed
  // TODO: implement wave tables for sine, triangle, sawtooth, others
  
  wire [1:0] sel = data_bus[6:5];
  
  always @(posedge clk or posedge reset) begin : interface
    if (reset) begin
      tone[0] = 10'h1b5; // 256 Hz
      tone[1] = 2;
      tone[2] = 2;
      tone[3] = 2;
      volume[0] = 0;
      volume[1] = 15;
      volume[2] = 15;
      volume[3] = 15;
      latch_volume = 0;
      latch = 2'b00;
    end
  
    else if (!we) begin
			if (!cs) begin
					if (data_bus[7]) begin
					  
						latch = sel;
						latch_volume = data_bus[4];
						// Load 4 LSbits to a register
						if (data_bus[4])
							volume[sel] = data_bus[3:0];
						else
							tone[sel][3:0] = data_bus[3:0];   
					end
					else begin
						if (latch_volume)
							volume[latch] = data_bus[3:0];
						else begin
							if (latch == 3)
								tone[3][2:0] = data_bus[2:0]; // noise
							else
								tone[latch][9:4] = data_bus[5:0];
						end
					end
			end
		end
  end
  
  // sndclk is the 447.7 khz clock
  always @(posedge sndclk or posedge reset) begin
    if (reset) begin  
      counter[0] = 1;
      counter[1] = 1;
      counter[2] = 1;
      counter[3] = 1;
      bits[0] = 0;
      bits[1] = 0;
      bits[2] = 0;
      bits[3] = 0;
          
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
				3: counter[3] = tone[2];
				2: counter[3] = 64;
				1: counter[3] = 32;
				0: counter[3] = 16;
				endcase
			end
			else begin
				counter[3] = counter[3] - 1;
			end
      
      mixer = samples[bits[0] + 2*volume[0]] + samples[bits[1] + 2*volume[1]] + samples[bits[2] + 2*volume[2]] + samples[noise_bit + 2*volume[3]];
	  end
   
  end

  assign sample = mixer;
  
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
