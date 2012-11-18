module MIPS150(
	           input clk,
	           input rst,

	           // Serial
	           input FPGA_SERIAL_RX,
	           output FPGA_SERIAL_TX,

	           // Memory system connections
	           output [31:0] dcache_addr,
	           output [31:0] icache_addr,
	           output [3:0] dcache_we,
	           output [3:0] icache_we,
	           output dcache_re,
	           output icache_re,
	           output [31:0] dcache_din,
	           output [31:0] icache_din,
	           input [31:0] dcache_dout,
	           input [31:0] instruction,
	           input stall
	       );

   // Control wires
   wire    REUART, WEUART, DinSel,
	   DataOutValid, DataInReady, DataOutReady, DataInValid, Branch_compare, RegWrite;
   wire [1:0] PC_Sel, ALU_Sel_A, ALU_Sel_B, RegDst, UARTsel, RDsel, offset;
   wire [3:0] ALUop, IMByteSel, DMByteSel;

   // Data wires
   wire [7:0] DataOut, DataIn;
   wire [31:0] Instruction, PrevInstruction, Address;
   
   Control the_controller(
			  .Address(Address),
			  .Instruction(Instruction), // begin inputs
			  .OldInstruction(PrevInstruction),
			  .branch(Branch_compare), // end inputs
			  .RegWrite(RegWrite),// begin outputs
			  .offset(offset),
			  .RegDst(RegDst),
			  .reset(rst),
			  .PCsel(PC_Sel),
			  .AluSelA(ALU_Sel_A), 
			  .AluSelB(ALU_Sel_B),
			  .ALUop(ALUop),
			  .IMByteSel(icache_we), .DinSel(DinSel), .DMByteSel(dcache_we),
			  .REUART(REUART), .WEUART(WEUART), .UARTsel(UARTsel),
			  .RDsel(RDsel),
			  .dcache_re(dcache_re),
			  .icache_re(icache_re)); //end outputs

   Datapath the_datapath(
			 .ALUop(ALUop), //begin inputs
			 .IMByteSel(IMByteSel),
.DMByteSel(DMByteSel), .DinSel(DinSel),
			 .REUART(REUART), .WEUART(WEUART), .UARTsel(UARTsel),
			 .RDsel(RDsel), .Stall(stall), .CLK(clk), .DataOutValid(DataOutValid), .reset(rst),
			 .DataInReady(DataInReady),
			 .PC_Sel(PC_Sel), //PC_Sel 
			 .ALU_Sel_A(ALU_Sel_A),
			 .ALU_Sel_B(ALU_Sel_B),
			 .RegDst(RegDst),
			 .RegWrite(RegWrite),
			 .DataOut(DataOut), //end inputs
			 .Branch_compare(Branch_compare), //output
			 .offset(offset),
			 .Instruction(Instruction), //output
			 .PrevInstruction(PrevInstruction), //output
			 .Address(Address), // output
			 .DataOutReady(DataOutReady), //output
			 .DataInValid(DataInValid), //output
			 .DataIn(DataIn)
			 .dcache_addr(dcache_addr),
			 .icache_addr(icache_addr),
			 .dcache_din(dcache_din),
			 .icache_din(icache_din)
			 .dcache_dout(dcache_dout),
			 .icache_dout(instruction)); //output

   UART the_uart(
		 .Clock(clk), //input 
		 .Reset(rst), //input 
		 .DataIn(DataIn), //input
		 .DataInValid(DataInValid), //input
		 .DataInReady(DataInReady), //output
		 .DataOut(DataOut), //output
		 .DataOutValid(DataOutValid), //output
		 .DataOutReady(DataOutReady), //input
		 .SIn(FPGA_SERIAL_RX), //input
		 .SOut(FPGA_SERIAL_TX)); //output
   
   


endmodule
    

