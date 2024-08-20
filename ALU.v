module ALU (
  input [15:0] x,
  input [15:0] y,
  input zx,
  input nx,
  input zy,
  input ny, 
  input f,
  input no,
  output reg [15:0] out,
  output reg zr,
  output reg ng
);
  reg [15:0] x_new;
  reg [15:0] y_new;
  reg [15:0] func_result;

  always @* begin 
    x_new = x; 
    y_new = y;

    if (zx) 
      x_new = 16'h0000;
    if (nx)
      x_new = ~x_new; 
    if (zy)
      y_new = 16'h0000; 
    if (ny)
      y_new = ~y_new; 

    // 1 = ADD, 0 = AND 
    if (f) 
      func_result = x_new + y_new; 
    else  
      func_result = x_new & y_new;  

    if (no) begin 
      func_result = ~func_result;
    end  

    out = func_result; 

    if (func_result == 16'h0000) 
      zr = 1; 
    else 
      zr = 0; 

    if (func_result[15] == 1)
      ng = 1;
    else 
      ng = 0;
  end 
endmodule