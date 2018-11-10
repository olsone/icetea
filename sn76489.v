// TI sound chip
module sn76489(
  input wire clk,
  input wire reset,
  input wire sndclk, // TI-99/4A: 447.443 kHz or ntsc/8
  input wire sndclk32, // 32 * sndclk
  input wire [7:0] i_data_bus,
  input wire i_cs, // active low 
  input wire i_we, // active low
  output wire [WIDTH-1:0] o_sample,
  output wire [3:0] o_bits,
  output wire [9:0] o_counter1
  );
  
  parameter WIDTH = 16;


  // interface registers
  reg [1:0] latch;
  reg latch_volume;
  reg [9:0] tone[4]; // noise is tone[3]
  reg [3:0] volume[4];
  reg [WIDTH-1:0] mixer;
  
  // period registers
  reg [9:0] counter[3:0];
  reg [3:0] bits;
  // wavetable synthesizer
  reg [9:0] wt_counter[3:0];
  reg [5:0] wt_idx[3:0];
    
  wire noise_bit;
  wire noise_clk = bits[3];
  wire noise_type = tone[3][2]; // periodic or white noise
  lfsr whitenoise(.noiseclk(noise_clk), .noisetype(noise_type), .noise(noise_bit));
 
  assign o_sample = mixer;
  assign o_counter1 = counter[0];
  assign o_bits = {bits[0:2], noise_bit};

  // original square wave
  //assign  mixer = samples[ {volume[0],bits[0]} ] + samples[ {volume[1],bits[1]}  ] + samples[ {volume[2],bits[2]}  ] + samples[ {volume[3],noise_bit} ];
     
  // logarithmic scale attenuation in 2dB steps, square wave [2 samples each]
  reg [WIDTH-1:0] samples[0:31] ;

  initial  begin
    $readmemh("waves/samples.mem", samples);
  end
  
  // delay to let SRAM ready before first access  to samples (or i_we get all 1s)
  // https://github.com/cliffordwolf/icestorm/issues/76#issuecomment-289270411
	reg resetn = 0;
	reg [7:0] reset_count = 0;

	always @(posedge clk) begin
		if (reset) begin
		  reset_count <= 0;
		  resetn <= 0;
		end else 
		  reset_count <= reset_count + 1;

		if (reset_count == 36) // <-- set this to 36 to work around the issue
			resetn <= 1;
	end
	  
  wire [1:0] sel = i_data_bus[6:5];
  
  always @(posedge clk) begin 
    if (reset || !resetn) begin
      tone[0] <= 10'h1ac;
      tone[1] <= 10'h153;
      tone[2] <= 10'h10d;
      tone[3] <= 10'h005;
      volume[0] <= 4'h0;
      volume[1] <= 4'h0;
      volume[2] <= 4'h0;
      volume[3] <= 4'hf;
      latch_volume <= 1'b0;
      latch <= 2'b00;
    end
  
    else if (!i_we && !i_cs) begin
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
						tone[latch][9:4] <= i_data_bus[5:0]; // feature: add another bit here?
				end
			end
		end
  end

//
// wavetable synthesizer
//
  // wavetables
  reg [WIDTH-1:0] wave_table1[0:63] ;
  reg [WIDTH-1:0] wave_table2[0:63] ;
  reg [WIDTH-1:0] wave_table3[0:63] ;
  reg [WIDTH-1:0] wave_table0[0:63] ;
  parameter NSAMP = 5;
  reg [WIDTH-1:0] wave_tables[NSAMP-1:0][0:63];
  reg [1:0] wave_number[3:0];
  
  initial  begin
    $readmemh("waves/wave_square.mem", wave_table0);
    $readmemh("waves/wave_sine.mem",   wave_table1);
    $readmemh("waves/wave_saw.mem",    wave_table2);
    $readmemh("waves/wave_violin.mem", wave_table3);

    $readmemh("waves/wave_square.mem", wave_tables[0][0:63] );
    $readmemh("waves/wave_sine.mem",   wave_tables[1][0:63] );
    $readmemh("waves/wave_saw.mem",    wave_tables[2][0:63] );
    $readmemh("waves/wave_cello.mem",  wave_tables[3][0:63] );
    $readmemh("waves/wave_violin.mem", wave_tables[4][0:63] );
  end
  // TODO: implement wave tables for sine, triangle, sawtooth, custom


// counters
  always @(posedge sndclk32) begin
    if (reset || !resetn) begin  
      wt_counter[0] <= 10'd1;
      wt_counter[1] <= 10'd1;
      wt_counter[2] <= 10'd1;
      wt_counter[3] <= 10'd1;
      wt_idx[0] <= 6'd0;
      wt_idx[1] <= 6'd0;
      wt_idx[2] <= 6'd0;
      wt_idx[3] <= 6'd0;
      wave_number[0] <= 0;
      wave_number[1] <= 0;
      wave_number[2] <= 0;
      wave_number[3] <= 0;
    end else begin
			if (wt_counter[0] == 10'b0) 
			begin
        wt_idx[0] = wt_idx[0] + 1;
				wt_counter[0] =   10'h1ac; // tone[0]; //  
			end else begin
				wt_counter[0] = wt_counter[0] - 1;
			end

			if (wt_counter[1] == 10'b0) 
			begin
        wt_idx[1] = wt_idx[1] + 1;
				wt_counter[1] = tone[1];
			end else begin
				wt_counter[1] = wt_counter[1] - 1;
			end

			if (wt_counter[2] == 10'b0) 
			begin
        wt_idx[2] = wt_idx[2] + 1;
				wt_counter[2] = tone[2]; //  10'h10d;
			end else begin
				wt_counter[2] = wt_counter[2] - 1;
			end
    end


  end

// test one channel
// assign mixer = wave_table1[ wt_idx[0] ] ;

// mixer

 // TODO: check mixer for overflow, clamp to min/max
  reg [1:0] mixer_i;
  reg [WIDTH+1:0] accum; // extra two bits
  always @(posedge clk)
	if (resetn) begin

		case (mixer_i)
		0: accum =       {2'b00,  wave_table1 [ wt_idx[0] ] };
//		1: accum = accum + wave_table3 [ wt_idx[1] ];
//		2: accum = accum + wave_table3 [ wt_idx[2] ];
		3: mixer = accum[WIDTH-1:0];

		endcase
		mixer_i = mixer_i + 1;
	end // end wavetable synthesizer 



// 76489 sndclk square wave  
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
