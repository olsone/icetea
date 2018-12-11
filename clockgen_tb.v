module test;
  // test: generate the clock phases
  
  reg clk100;
  reg clk12;
  
  wire phi1, phi2, phi3, phi4;
  


  
  initial begin
     clk100 = 0;
     clk12 = 0;
     
     # 2000 $finish;
  end
  
  // regular clock
  always #5    clk100 = !clk100;
 // always #41.666 clk12 = !clk12;
  always #5 clk12 = !clk12;// temporary speedup, breaks wait state
  
  clockgen      phases(clk12, phi1, phi2, phi3, phi4);

  initial
     $monitor("At time %t, %d phases %d %d %d %d", $time, clk12, phi1, phi2, phi3, phi4);
endmodule // test