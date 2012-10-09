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

if (opcode == `RTYPE) begin

	case(funct)
	`SLL:    ALUop = `ALU_SLL;
 	`SRL:    ALUop = `ALU_SRL;
 	`SRA:    ALUop = `ALU_SRA;
 	`SLLV:   ALUop = `ALU_SLL;
 	`SRLV:   ALUop = `ALU_SRL;
 	`SRAV:   ALUop = `ALU_SRA;
 	`ADDU:   ALUop = `ALU_ADDU;
 	`SUBU:   ALUop = `ALU_SUBU;
 	`AND:    ALUop = `ALU_AND;
 	`OR:     ALUop = `ALU_OR;
 	`XOR:    ALUop = `ALU_XOR;
 	`NOR:    ALUop = `ALU_NOR;
 	`SLT:    ALUop = `ALU_SLT;
 	`SLTU:   ALUop = `ALU_SLTU;
	default: ALUop = `ALU_XXX;
	endcase

end

else begin
        case(opcode)
	`LUI: ALUop = `ALU_LUI;
	`ORI: ALUop = `ALU_OR;
	`ANDI: ALUop = `ALU_AND;
	`ADDIU: ALUop = `ALU_ADDU;
	`XORI: ALUop = `ALU_XOR;
	`SLTIU: ALUop = `ALU_SLTU;
	`SLTI: ALUop = `ALU_SLT;
        default: ALUop = `ALU_ADDU;
	endcase

end
end
endmodule
