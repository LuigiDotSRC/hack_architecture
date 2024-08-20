module CPU (
  input clk, 
  input [15:0] instruction, 
  input [15:0] inM,
  input reset,
  output reg [15:0] outM, 
  output reg writeM,
  output reg [14:0] addressM, 
  output reg [14:0] pc
);
  reg [15:0] D; 
  reg [15:0] A; 

  reg [15:0] ALU_in; 

  wire [15:0] ALU_out; 
  wire zero;
  wire neg; 

  // Instantiate ALU outside the always block
  ALU alu_inst (
    .x(D),
    .y(ALU_in),
    .zx(instruction[11]),
    .nx(instruction[10]), 
    .zy(instruction[9]),
    .ny(instruction[8]),
    .f(instruction[7]),
    .no(instruction[6]),
    .out(ALU_out),
    .zr(zero),
    .ng(neg)
  );

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      pc <= 0;
    end else begin
      writeM <= 0;  // Default: Do not write to memory

      if (instruction[15]) begin // C-instruction
        ALU_in <= (instruction[12]) ? inM : A;

        // Compute ALU result
        outM <= ALU_out; 

        if (instruction[5]) A <= ALU_out;  // Destination: A
        if (instruction[4]) D <= ALU_out;  // Destination: D
        if (instruction[3]) writeM <= 1;   // Write to memory
        
      end else begin // A-instruction
        A <= instruction;
      end  

      addressM <= A[14:0];

      // Handle jumps
      case (instruction[2:0])
        3'b111: pc <= A;                      // JMP
        3'b110: if (zero || neg) pc <= A;     // JLE
        3'b101: if (!zero) pc <= A;           // JNE
        3'b100: if (neg) pc <= A;             // JLT
        3'b011: if (!neg || zero) pc <= A;    // JGE
        3'b010: if (zero) pc <= A;            // JEQ
        3'b001: if (!neg) pc <= A;            // JGT
        default: pc <= pc + 1;                // No jump
      endcase
    end
  end
endmodule
