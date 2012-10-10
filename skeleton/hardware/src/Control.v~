module Control(
  input [31:0] Address,
  input [5:0] op, funct,
  input [4:0] branch,
  output RegWrite, RegDst, AluSrc, Branch, MemWrite, MemtoReg,
  output [3:0] ALUop,
  output [3:0] ByteSel,
  output WEIM, WEDM, REUART, WEUART, UARTsel, RDsel
);
`include "Opcode.vh"
`include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------

  //--|Solution|----------------------------------------------------------------
  
  reg RegWriteReg, RegDstReg, AluSrcReg, BranchReg, MemWriteReg, MemtoRegReg;

  assign RegWrite = RegWriteReg;
  assign RegDst = RegDstReg;
  assign AluSrc = AluSrcReg;
  assign Branch = BranchReg;
  assign MemWrite = MemWriteReg;
  assign MemtoReg = MemtoRegReg;

  
  ALUdec DUT(.funct(funct),
        .opcode(op),
        .ALUop(ALUop));

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
	RegWriteReg = (op == `RTYPE)||(op == `LW);
	RegDstReg = (op == `RTYPE);
	AluSrcReg = (op == `LW) || (op == `SW);
	BranchReg = (op == `BEQ);
	MemWriteReg = (op == `SW);
	MemtoRegReg = 1'b0;
  end

endmodule
