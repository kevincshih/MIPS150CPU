// UC Berkeley CS150
// Lab 3, Spring 2012
// Module: ALUdecoder
// Desc:   Sets the ALU operation
// Inputs: opcode: the top 6 bits of the instruction
//         funct: the funct, in the case of r-type instructions
// Outputs: ALUop: Selects the ALU's operation

`include "Opcode.vh"
`include "ALUop.vh"

module ALUdec(
  input [5:0] funct, opcode,
  output reg [3:0] ALUop
);

always @ (*) begin

if (opcode == 6'b000000) begin

	case(funct)
	`SLL:    reg = `ALU_SLL;
 	`SRL:    reg = `ALU_SRL;
 	`SRA:    reg = `ALU_SRA;
 	`SLLV:   reg = `ALU_SLLV;
 	`SRLV:   reg = `ALU_SRLV;
 	`SRAV:   reg = `ALU_SRAV;
 	`ADDU:   reg = `ALU_ADDU;
 	`SUBU:   reg = `ALU_SUBU;
 	`AND:    reg = `ALU_AND;
 	`OR:     reg = `ALU_OR;
 	`XOR:    reg = `ALU_XOR;
 	`NOR:    reg = `ALU_NOR;
 	`SLT:    reg = `ALU_SLT;
 	`SLTU:   reg = `ALU_SLTU;
	default: reg = `ALU_XXX;
	endcase

end

else reg = 'ALU_XXX;

end
endmodule
