//-----------------------------------------------------------------------------
// Lab4Datapath
// CS 150 Spring 2012
// Description:
//     Datapath for a linked-list accumulator. The list begins at address 0 of 
//     the block ram. Each list element contains a data field and a pointer to
//     the next element, stored in sequential addresses.
//-----------------------------------------------------------------------------

`include "Opcode.vh"
`include "ALUop.vh"
 
module Lab3Datapath(
    input clk, rst,
    input addr_sel, wr_en,
    input [3:0] alu_op,
    output ram_zero,
    output [31:0] accum_result
);

	reg [9:0] reg_addr;
	wire [31:0] ram_dout;
	reg [9:0] ram_addr;
	reg [9:0] addr;
	wire [31:0] alu_out;
	reg [31:0] accum_reg;
	reg ram_zero_reg;	

    // Block memory instantiation. The module definition is in 
    // blk_ram/blk_mem_gen_v4_3.v (after you run build in the blk_ram
    // directory).
    blk_mem_gen_v4_3 blk_mem(
	    .clka(clk),
	    .addra(ram_addr),
	    .douta(ram_dout)
    );

    ALU DUT2( .A(ram_dout),
        .B(accum_result),
        .ALUop(alu_op),
        .Out(alu_out));
	
	assign ram_zero = (ram_dout == 0);
	assign accum_result = accum_reg;	

	always @ (posedge clk) begin
	if(rst) begin reg_addr <= 0;
		accum_reg <= 0;
		end
	else begin
		reg_addr <= addr;
		accum_reg <= wr_en ? alu_out: accum_result;	
	end
	end

	always @ (*) begin
		addr = addr_sel ? reg_addr + 1 : ram_dout[9:0];
		ram_addr = rst ? 10'b0 : addr;
	end

 // ChipScope components: 
    wire [35:0] chipscope_control; 
 
    chipscope_icon icon( 
        .CONTROL0(chipscope_control) 
    ) /* synthesis syn_noprune=1 */; 
 
   chipscope_ila ila( 
        .CONTROL(chipscope_control), 
        .CLK(clk), 
        .DATA({rst, addr_sel, wr_en, ram_addr, ram_dout, accum_result, alu_op, alu_out, 11'b0}), 
        .TRIG0(rst) 
    ) /* synthesis syn_noprune=1 */;

endmodule
