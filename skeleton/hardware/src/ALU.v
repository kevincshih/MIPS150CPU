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
    output [31:0] Out
);
   reg [31:0] 	  O;
   
always @(*) begin

   case(ALUop)
     
     `ALU_ADDU: O = A + B;
     `ALU_SUBU: O = A - B;
     `ALU_SLT:  O = $signed(A) < $signed(B);
     `ALU_SLTU: O = A < B;
     `ALU_AND:  O = A & B;
     `ALU_OR:   O = A | B;
     `ALU_XOR:  O = A ^ B;
     `ALU_SLL:  O = B << A;
     `ALU_SRL:  O = B >> A;
     `ALU_SRA:  O = $signed(B) >>> $signed(A);
     `ALU_SLA: O = $signed(B) << $signed(A);
     `ALU_NOR:  O = ~A & ~B;
     `ALU_LUI: O = {B[15:0], 16'b0}; 

     default:  O = A + B;
     
   endcase
end
   assign Out = O;
   
endmodule
