// 0 : 16383 = RAM16K 
// 17384 : 24575 = SCREEN implemented as RAM8K 
// 24576 = KEYBOARD register
module RAM32K (
  input clk,
  input load,
  input [15:0] in, 
  input [14:0] address,
  output reg [15:0] out
); 
  reg [15:0] mem [0:32768]; 

  always @(posedge clk) begin
    if (load) begin
      mem[address] <= in; 
    end  
    out <= mem[address];
  end
endmodule
