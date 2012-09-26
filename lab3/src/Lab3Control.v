//-----------------------------------------------------------------------------
// Lab4Control
// CS 150 Spring 2012
// Description:
//      Implement your control logic in this module.
//-----------------------------------------------------------------------------

`include "Opcode.vh"
`include "ALUop.vh"

module Lab3Control(
        input        clk, rst,
        input        ram_zero,
        input [5:0]  funct,
        output [3:0] alu_op,
        output       addr_sel,
        output       wr_en,
        output       done
);

localparam STATE_0 = 2'b00,
	   STATE_1 = 2'b01,
	   STATE_2 = 2'b10;

    ALUdec DUT1(.funct(funct),
        .opcode(`RTYPE),
        .ALUop(alu_op));

reg[1:0] CurrentState, NextState;
reg reg_addr_sel, reg_wr_en;

assign addr_sel = reg_addr_sel;
assign wr_en = reg_wr_en;
assign done = ram_zero;

always @(posedge clk) begin
if(rst) CurrentState <= STATE_0;
else CurrentState <= NextState;
end

always @(*) begin

NextState = CurrentState;

case (NextState) 
STATE_0: begin
reg_addr_sel = 1'b1;
reg_wr_en = 1'b1;
NextState = STATE_1;
end
STATE_1: begin
reg_addr_sel = 1'b0;
reg_wr_en = 1'b0;
NextState = done ? STATE_2 : STATE_0;
end
STATE_2: begin
NextState = STATE_2;
end
default: begin
NextState = STATE_2;
end
endcase
end
endmodule
