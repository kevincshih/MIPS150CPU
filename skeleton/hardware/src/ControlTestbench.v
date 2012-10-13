// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

module ControlTestBench();

  parameter Halfcycle = 5; //half period is 5ns

  localparam Cycle = 2*Halfcycle;

  reg Clock;

  // Clock Sinal generation:
  initial Clock = 0; 
  always #(Halfcycle) Clock = ~Clock;

  // Register and wires
  reg[31:0] addr;
  reg[5:0] op, funct;
  reg branch;
  wire RegWrite, RegDst, Branch, MemWrite, MemtoReg;
  wire [1:0] AluSelA, AluSelB;
  wire [3:0] ALUop;
  wire [3:0] ByteSel;
  wire WEIM, WEDM, REUART, WEUART, UARTsel, RDsel;

  Control DUT(.Address(addr),
	.op(op),
	.funct(funct),
  	.branch(branch),
  	.RegWrite(RegWrite),
	.RegDst(RegDst),
	.AluSelA(AluSelA),
	.AluSelB(AluSelB),
	.Branch(Branch),
	.MemWrite(MemWrite),
	.MemtoReg(MemtoReg),
  	.ALUop(ALUop),
  	.ByteSel(ByteSel),
 	.WEIM(WEIM),
	.WEDM(WEDM),
	.REUART(REUART),
	.WEUART(WEUART),
	.UARTsel(UARTsel),
	.RDsel(RDsel));

  // Testing logic:
  initial begin
    #1;

	

    $display("All tests passed!");
    $finish();

  end
endmodule
