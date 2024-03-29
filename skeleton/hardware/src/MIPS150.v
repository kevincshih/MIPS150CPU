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
	           input stall, 
			output [31:0] gp_code,
			output [31:0] gp_frame,
			output gp_valid,
			input frame_interrupt
	       );

   // Control wires
   wire    REUART, WEUART, DinSel, isr_pc, mtc0, mfc0, irh, ISRByteSel, 
	   DataOutValid, DataInReady, DataOutReady, DataInValid, Branch_compare, RegWrite, CTsel, CTreset, ICacheSel, SEXTImm, JRsel;
   wire [1:0] PC_Sel, ALU_Sel_A, ALU_Sel_B, RegDst, UARTsel, RDsel, offset;
   wire [3:0] ALUop;

   // Data wires
   wire [7:0] DataOut, DataIn;
   wire [31:0] Instruction, PrevInstruction, Address, PC, dcache_dout2, instruction2;
   
   reg [31:0] dcache_doutreg, instructionreg;
   
   reg stall_reg;
   
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
			  .PC(PC),
			  .ICacheSel(ICacheSel),
			  .CTsel(CTsel),
			  .CTreset(CTreset),
			  .SEXTImm(SEXTImm),
			  .JRsel(JRsel),
			  .REDC(dcache_re),
			  .isr_pc(isr_pc),.mtc0(mtc0), .mfc0(mfc0), .irh(irh),
			  .ISRByteSel(ISRByteSel)); //end outputs

			  
			  
   Datapath the_datapath(
			 .ALUop(ALUop), //begin inputs
			 .DinSel(DinSel),
			 .REUART(REUART), .WEUART(WEUART), .UARTsel(UARTsel),
			 .RDsel(RDsel), .Stall(~not_stall), .CLK(clk), .DataOutValid(DataOutValid), .reset(rst),
			 .DataInReady(DataInReady),
			 .PC_Sel(PC_Sel), //PC_Sel 
			 .ALU_Sel_A(ALU_Sel_A),
			 .ALU_Sel_B(ALU_Sel_B),
			 .RegDst(RegDst),
			 .RegWrite(RegWrite),
			 .SEXTImm(SEXTImm),
			 .JRsel(JRsel),
			 .DataOut(DataOut), //end inputs
			 .Branch_compare(Branch_compare), //output
			 .offset(offset),
			 .Instruction(Instruction), //output
			 .PrevInstruction(PrevInstruction), //output
			 .Address(Address), // output
			 .DataOutReady(DataOutReady), //output
			 .DataInValid(DataInValid), //output
			 .DataIn(DataIn),
			 .RCIS(icache_re),
			 .PC_toControl(PC),
			 .CTsel(CTsel),
			 .CTreset(CTreset),
			 .ICacheSel(ICacheSel),
			 .dcache_addr(dcache_addr),
			 .icache_addr(icache_addr),
			 .dcache_din(dcache_din),
			 .icache_din(icache_din),
			 .dcache_dout(dcache_dout2),
			 .icache_dout(instruction2),
			 .isr_pc(isr_pc), .mtc0(mtc0), .mfc0(mfc0), .irh(irh),
			 .ISRByteSel(ISRByteSel)); //output

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
		 
		 
   assign not_stall = ~stall;
   assign dcache_dout2 = (not_stall) ? dcache_dout : dcache_dout;
   assign instruction2 = (not_stall) ? instruction : instruction;
	  
   always @(posedge clk) begin
		stall_reg <= stall;
		if (not_stall) begin
		dcache_doutreg <= dcache_dout;
		instructionreg <= instruction;
		end
	  end
   


endmodule
    

