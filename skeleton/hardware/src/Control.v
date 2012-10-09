module Control(
  input   Clock,
  input   Reset,
  input [5:0] op, funct,
  input [4:0] branch,
  output RegWrite, RegDst, AluSrc, Branch, MemWrite, MemtoReg,
  output [3:0] ALUOp
);
`include "Opcode.vh"
`include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------

  //--|Solution|----------------------------------------------------------------

  ALUdec DUT(.funct(funct),
              .opcode(op),
              .ALUop(ALUOp));

  always @ (*) begin
	RegWrite = (op == `RTYPE)||(op == `lw);
	RegDst = (op == `RTYPE);
	AluSrc = (op == `lw) || (op == `sw);
	Branch = (op == `beq);
	MemWrite = (op == `sw);
	MemtoReg = 1'b0;
  end

endmodule
