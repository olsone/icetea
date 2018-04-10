module sn76489(
  input wire clk,
  input wire [7:0] data_bus,
  input wire cs, // active low 
  input wire we, // active low
  output wire [7:0] sample,
  output wire bit1,
  output wire [9:0] counter1
  );

  // interface registers
  reg [9:0] tone[4]; // noise is tone[3]
  reg [3:0] volume[4];
  reg [7:0] mixer;
  
  initial begin
    tone[0] = 2;
    tone[1] = 0;
    tone[2] = 0;
    tone[3] = 0;
    volume[0] = 0;
    volume[1] = 15;
    volume[2] = 15;
    volume[3] = 15;
    bits[0] = 0;
    bits[1] = 0;
    bits[2] = 0;
    bits[3] = 0;
    mixer = 1;    
    counter[0] = 1;
  end
  
  // period registers
  reg [9:0] counter[4];
  reg bits[4];
  reg [1:0] latch;
  reg latch_volume;
  
  wire noise_bit;
  wire noise_clk = bits[3];
  wire noise_type = tone[3][2];
  lfsr whitenoise(.noiseclk(noise_clk), .noisetype(noise_type), .noise(noise_bit));
 
  assign sample = mixer;
  assign counter1 = counter[0];
  assign bit1 = bits[0];
  
  integer samples[32];

  initial begin
    samples[0] = 31;	samples[1] = -31;
    samples[2] = 25;	samples[3] = -25;
    samples[4] = 20;	samples[5] = -20;
    samples[6] = 16;	samples[7] = -16;
    samples[8] = 13;	samples[9] = -13;
    samples[10] = 10;	samples[11] = -10;
    samples[12] = 8;	samples[13] = -8;
    samples[14] = 6;	samples[15] = -6;
    samples[16] = 5;	samples[17] = -5;
    samples[18] = 4;	samples[19] = -4;
    samples[20] = 3;	samples[21] = -3;
    samples[22] = 3;	samples[23] = -3;
    samples[24] = 2;	samples[25] = -2;
    samples[26] = 2;	samples[27] = -2;
    samples[28] = 1;	samples[29] = -1;
    samples[30] = 0;	samples[31] = 0;
    
  end

  // TODO: scale clock to exact speed
  // TODO: implement wave tables for sine, triangle, sawtooth, others

  always @(negedge we) begin
    if (!cs) begin
        if (data_bus[7]) begin
          latch = data_bus[6:5];
          latch_volume = data_bus[4];
          // Load 4 LSbits to a register
          if (latch_volume)
            volume[latch] = data_bus[3:0];
          else
            tone[latch][3:0] = data_bus[3:0];   
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
  
  // clk is the 448 khz clock
  always @(posedge clk) begin
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
      bits[3] = !bits[3];
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
    //sample = mixer;
   
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
