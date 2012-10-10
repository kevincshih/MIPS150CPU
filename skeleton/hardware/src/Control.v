module Control(
  input [31:0] Address,
  input [5:0] op, funct,
  input [4:0] branch,
  output RegWrite, RegDst, AluSrc, Branch, MemWrite, MemtoReg,
  output [3:0] ALUOp,
  output [3:0] ByteSel,
  output WEIM, WEDM, REUART, WEUART, UARTsel, RDsel
);
`include "Opcode.vh"
`include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------

  //--|Solution|----------------------------------------------------------------

  ALUdec DUT(.funct(funct),
        .opcode(op),
        .ALUop(ALUOp));

  AddrDec DUT2(.MemWrite(MemWrite),
	.Address(Address),
	.ByteSel(ByteSel),
	.WEIM(WEIM), 
	.WEDM(WEDM),
	.REUART(REUART),
	.WEUART(WEUART),
	.UARTsel(UARTsel),
	.RDsel(RDsel));

  always @ (*) begin
	RegWrite = (op == `RTYPE)||(op == `lw);
	RegDst = (op == `RTYPE);
	AluSrc = (op == `lw) || (op == `sw);
	Branch = (op == `beq);
	MemWrite = (op == `sw);
	MemtoReg = 1'b0;
  end

endmodule
