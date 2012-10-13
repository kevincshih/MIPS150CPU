module Control(
  input [31:0] Address,
  input [5:0] op, funct,
  input branch,
  output RegWrite, RegDst, AluSrc, Branch, MemWrite, MemtoReg,
  output [1:0] AluSelA, AluSelB,
  output [3:0] ALUop,
  output [3:0] ByteSel,
  output WEIM, WEDM, REUART, WEUART, UARTsel, RDsel
);
`include "Opcode.vh"
`include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------

  //--|Solution|----------------------------------------------------------------
  
  reg RegWriteReg, RegDstReg, BranchReg, MemWriteReg, MemtoRegReg;

  reg [1:0] AluSelAReg, AluSelBReg;
  reg [3:0] ByteSelReg;

  assign RegWrite = RegWriteReg;
  assign RegDst = RegDstReg;
  assign AluSelA = AluSelAReg;
  assign AluSelB = AluSelBReg;
  assign Branch = BranchReg;
  assign MemWrite = MemWriteReg;
  assign MemtoReg = MemtoRegReg;
  assign ByteSel = ByteSelReg;
  
  ALUdec DUT(.funct(funct),
        .opcode(op),
        .ALUop(ALUop));

  AddrDec DUT2(.MemWrite(MemWrite),
	.Address(Address),
	.WEIM(WEIM), 
	.WEDM(WEDM),
	.REUART(REUART),
	.WEUART(WEUART),
	.UARTsel(UARTsel),
	.RDsel(RDsel));

  always @ (*) begin
	RegWriteReg = (op == `RTYPE)||(op == `LW);
	RegDstReg = (op == `RTYPE);
	AluSelAReg = (op == `LW) || (op == `SW);
	BranchReg = (op == `BEQ && branch);
	MemWriteReg = (op == `SW);
	MemtoRegReg = 1'b0;
        case(op)
	`SB: ByteSelReg = 4'b0001;
	`SH: ByteSelReg = 4'b0011;
	`SW: ByteSelReg = 4'b1111;
	default: ByteSelReg = 4'b0000;
	endcase
  end

endmodule
