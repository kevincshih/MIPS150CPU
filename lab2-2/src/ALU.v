// UC Berkeley CS150
// Lab 3, Spring 2012
// Module: ALU.v
// Desc:   32-bit ALU for the MIPS150 Processor
// Inputs: A: 32-bit value
// B: 32-bit value
// ALUop: Selects the ALU's operation 
// 						
// Outputs:
// Out: The chosen function mapped to A and B.

`include "Opcode.vh"
`include "ALUop.vh"

module ALU(
    input [31:0] A,B,
    input [3:0] ALUop,
    output reg [31:0] Out
);

always @(*) begin

case(ALUop)

 `ALU_ADDU: reg = A + B;
 `ALU_SUBU: reg = A - B;
 `ALU_SLT:  reg = $signed(A) < $signed(B);
 `ALU_SLTU: reg = A < B;
 `ALU_AND:  reg = A & B;
 `ALU_OR:   reg = A | B;
 `ALU_XOR:  reg = A ^ B;
 `ALU_SLL:  reg = A << B;
 `ALU_SRL:  reg = A >> B;
 `ALU_SRA:  reg = $signed(A) >> $signed(B);
 `ALU_NOR:  reg = ~A & ~B;
 default, `ALU_LUI, `ALU_XXX:  reg = 6d'0;

endcase

end

endmodule
