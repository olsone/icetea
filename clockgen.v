/* 4-phase clock to use in test benches */

module clockgen(clk12, phi1, phi2, phi3, phi4);

  input wire clk12;
  output wire phi1, phi2, phi3, phi4;
  
  reg [1:0] count;
  wire [1:0] count_n = count + 1;
    
  initial begin
    count = 3;
  end
  
  always @(posedge clk12) 
  begin
    count = count_n;   
  end

  assign phi1 = !(count==0);
  assign phi2 = !(count==1);
  assign phi3 = !(count==2);
  assign phi4 = !(count==3);
endmodule // clockgen