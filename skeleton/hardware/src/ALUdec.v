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
  output [3:0] ALUop
);

   reg [3:0]   ALUopreg;
   
always @ (*) begin

if (opcode == `RTYPE) begin

	case(funct)
	`SLL:    ALUopreg = `ALU_SLL;
 	`SRL:    ALUopreg = `ALU_SRL;
 	`SRA:    ALUopreg = `ALU_SRA;
 	`SLLV:   ALUopreg = `ALU_SLL;
 	`SRLV:   ALUopreg = `ALU_SRL;
 	`SRAV:   ALUopreg = `ALU_SRA;
 	`ADDU:   ALUopreg = `ALU_ADDU;
 	`SUBU:   ALUopreg = `ALU_SUBU;
 	`AND:    ALUopreg = `ALU_AND;
 	`OR:     ALUopreg = `ALU_OR;
 	`XOR:    ALUopreg = `ALU_XOR;
 	`NOR:    ALUopreg = `ALU_NOR;
 	`SLT:    ALUopreg = `ALU_SLT;
 	`SLTU:   ALUopreg = `ALU_SLTU;
	`JALR: 	 ALUopreg = `ALU_ADDU;
	default: ALUopreg = `ALU_XXX;
	endcase

end

else begin
        case(opcode)
	`LUI: ALUopreg = `ALU_LUI;
	`ORI: ALUopreg = `ALU_OR;
	`ANDI: ALUopreg = `ALU_AND;
	`ADDIU: ALUopreg = `ALU_ADDU;
	`XORI: ALUopreg = `ALU_XOR;
	`SLTIU: ALUopreg = `ALU_SLTU;
	`SLTI: ALUopreg = `ALU_SLT;
	`JAL: ALUopreg = `ALU_ADDU;
        default: ALUopreg = `ALU_ADDU;
	endcase

end // else: !if(opcode == `RTYPE)
   
end // always @ (*)

   assign ALUop = ALUopreg;
   
endmodule
