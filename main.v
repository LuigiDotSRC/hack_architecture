module main; 
  reg clk; 
  reg reset; 

  reg [15:0] instruction;
  wire [15:0] inM;
  wire [15:0] outM;
  wire writeM;
  wire [14:0] addressM;
  wire [14:0] pc;

  wire [15:0] rom_out;

  ROM32K rom (
    .clk(clk),
    .pc(pc),
    .out(rom_out)
  );

  CPU cpu (
    .clk(clk),
    .instruction(rom_out),
    .inM(inM),
    .reset(reset),
    .outM(outM),
    .writeM(writeM),
    .addressM(addressM),
    .pc(pc)
  );

  RAM32K ram (
    .clk(clk),
    .load(writeM),
    .in(outM),
    .address(addressM),
    .out(inM)
  );
  
  initial begin 
    clk = 0; 
    reset = 1;
    #10 reset = 0;
  end 

  always begin 
    #5 clk = ~clk; 
  end 
endmodule