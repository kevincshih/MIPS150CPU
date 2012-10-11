module Datapath(
		input [3:0] ALUop, ByteSel,
		input WEIM, WEDM, REUART, WEUART, UARTsel, RDsel,
		RegWrite, RegDst, AluSrc, Branch, MemWrite, MemtoReg,
		output [4:0] branch,
		output [5:0] op, funct,
		output [31:0] Address
		);


`include "Opcode.vh"
`include "ALUop.vh"

   reg [11:0] PC;

   //wires for PC
   wire [11:0] PC_Branch, PC+4, PC_JAL, PC_MA, PC_IF;
   
   
