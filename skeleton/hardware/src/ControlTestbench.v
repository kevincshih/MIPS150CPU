// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
    `timescale 1ns / 1ps
    `include "Opcode.vh"
    `include "ALUop.vh"

    module ControlTestBench();

parameter Halfcycle = 5; //half period is 5ns

localparam Cycle = 2 * Halfcycle;

reg Clock;

  // Clock Sinal generation:
initial Clock = 0;
always #(Halfcycle)Clock = ~Clock;

  // Register and wires
reg[31:0] Address;
reg[31:0] OldAddress;
reg branch;

wire RegWrite;
wire[1:0] RegDst, PCsel;
wire[1:0] AluSelA, AluSelB;
wire[3:0] ALUop, ByteSel;
wire[1:0] UARTsel, RDsel;
wire WEIM, WEDM, REUART, WEUART;

Control DUT(.Address(Address),
    .OldAddress(OldAddress),
    .branch(branch),

    .RegWrite(RegWrite),
    .RegDst(RegDst),
    .PCsel(PCsel),
    .AluSelA(AluSelA),
    .AluSelB(AluSelB),
    .ALUop(ALUop),
    .ByteSel(ByteSel),
    .WEIM(WEIM),
    .WEDM(WEDM),
    .REUART(REUART),
    .WEUART(WEUART),
    .UARTsel(UARTsel),
    .RDsel(RDsel));

reg[31:0] REFout;
reg[31:0] DUTout;
//reg out1;
//reg [1:0] out2,out3;
//reg [1:0] out4, out5;
//reg [3:0] out6, out7;
//reg [1:0] out8, out9;
//reg out10, out11, out12, out13;

task checkOutput;
input[3:0]test;
case(test)
    1: DUTout = RegWrite;
    2: DUTout = RegDst;
    3: DUTout = PCsel;
    4: DUTout = AluSelA;
    5: DUTout = AluSelB;
    6: DUTout = ALUop;
    7: DUTout = ByteSel;
    8: DUTout = WEIM;
    9: DUTout = WEDM;
    10: DUTout = REUART;
    11: DUTout = WEUART;
    12: DUTout = UARTsel;
    13: DUTout = RDsel;
    default: DUTout = REFout;
endcase
if (REFout !== DUTout) begin
    $display("FAIL: Incorrect result for RegWrite new: %h, old: %h:", Address, OldAddress);
    $display("\t DUTout: 0x%h, REFout: 0x%h", RegWrite, REFout);
    $finish();
end
else begin
    $display("PASS: new: %h, old: %h", Address, OldAddress);
end
endtask

reg[4:0] zero = 5'b00000;
reg[4:0] s0 = 5'b10000;
reg[4:0] s1 = 5'b10001;
reg[4:0] s2 = 5'b10010;
reg[4:0] s3 = 5'b10011;
reg[31:0] nop = 32'b0;
  // Testing logic:
initial begin
    Address = {`RTYPE,s0,s0,s0,zero,`ADD};
    OldAddress = nop;
    
    REFout = 1;
    #1;
    checkOutput(1);
    #1;
    
    REFout = 1;
    #1;
    checkOutput(2);
    #1;
    
    REFout = 1;
    #1;
    checkOutput(3);
    #1;
    
    REFout = 1;
    #1;
    checkOutput(4);
    #1;
    
    REFout = 1;
    #1;
    checkOutput(5);
    #1;
    
    Address = {`RTYPE,s0,s0,s0,zero,`ADD};
    OldAddress = {`RTYPE,s0,s0,s0,zero,`ADD};
    
    REFout = 2;
    #1;
    checkOutput(4);
    #1;
    
    REFout = 2;
    #1;
    checkOutput(5);
    #1;
    
    $display("All tests passed!");
    $finish();



end
endmodule
