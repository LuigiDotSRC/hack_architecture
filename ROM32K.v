module ROM32K (
  input clk,
  input [14:0] pc,
  output reg [15:0] out
);
  reg [15:0] memory [0:32767]; 

  initial begin 
    $readmemb("program.hack", memory); 
    integer i;
    for (i = $feof; i < 32768; i = i + 1)
      rom[i] = 16'h0000;
  end 

  always @(posedge clk) begin 
    out <= memory[pc]; 
  end
endmodule