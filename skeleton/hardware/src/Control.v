module Control(
  input [31:0] Address,
  input [31:0] OldAddress,
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
  reg [5:0] op, funct, oldop, oldfunct;
  reg [4:0] rs, rt, rd, shamt, oldrs, oldrt, oldrd, oldshamt;
  reg [15:0] imm, oldimm;
  reg [25:0] target, oldtarget;
  assign op = Address[31:26];
  assign funct = Address[5:0];
  assign rs = Address[4:0];
  assign rt = Address[4:0];
  assign rd = Address[4:0];
  assign shamt = Address[4:0];
  assign oldrs = OldAddress[4:0];
  assign oldrt = OldAddress[4:0];
  assign oldrd = OldAddress[4:0];
  assign oldshamt = OldAddress[4:0];
  assign imm = Address[15:0];
  assign oldimm = OldAddress[15:0];
  assign target = Address[25:0];
  assign oldtarget = OldAddress[25:0];
  assign oldop = OldAddress[31:26];
  assign oldfunct = OldAddress[5:0];
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

  always @ (*) begin
  if (rs == oldrd) begin
  AluSelAReg = 2'b10;
  end

  if (rt == oldrd) begin
  AluSelBReg = 2'b10;
  end


  if (op == `RTYPE) begin
	AluSelAReg = 2'b01;
	AluSelBReg = 2'b01;
	if (funct == `JALR)	
	end
	else if (op == `ITYPE) begin
	AluSelAReg = 2'b01;
	AluSelBReg = 2'b11;
	end
	else if(op == `JAL) begin
	AluSelAReg = 2'b00;
	AluSelBReg = 2'b00; 
	end
  end

endmodule
