
module MIPS150(
    input clk, rst, stall,
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);

   // Control wires
   wire    WEIM, WEDM, REUART, WEUART,
	   DataOutValid, DataInReady, DataOutReady, DataInValid, Branch_compare, RegWrite, stall;
   wire [1:0] PC_Sel, ALU_Sel_A, ALU_Sel_B, RegDst, UARTsel, UARTsel, RDsel,
   wire [3:0] ALUop, ByteSel;

   // Data wires
   wire [7:0] DataOut, DataIn;
   wire [31:0] Address, PrevAddr;
   
   Control the_controller(
			  .Address(Address), // begin inputs
			  .OldAddress(PrevAddr),
			  .branch(Branch_compare), // end inputs
			  .RegWrite(RegWrite),// begin outputs
			  .RegDst(RegDst),
			  .PCSel(PC_Sel),
			  .AluSelA(ALU_Sel_A), 
			  .AluSelB(ALU_Sel_B),
			  .ALUop(ALUop),
			  .ByteSel(ByteSel),
			  .WEIM(WEIM), .WEDM(WEDM), .REUART(REUART), .WEUART(WEUART), .UARTsel(UARTsel),
			  .RDsel(RDsel)); //end outputs

   Datapath the_datapath(
			 .ALUop(ALUop), //begin inputs
			 .ByteSel(ByteSel),
			 .WEIM(WEIM), .WEDM(WEDM), .REUART(REUART), .WEUART(WEUART), .UARTsel(UARTsel),
			 .RDsel(RDsel), .Stall(stall), .CLK(clk), .DataOutValid(DataOutValid), .reset(rst),
			 .DataInReady(DataInReady),
			 .PC_Sel(PC_Sel), //PC_Sel from controller needs to be implemented
			 .ALU_Sel_A(ALU_Sel_A),
			 .ALU_Sel_B(ALU_Sel_B),
			 .RegDst(RegDst),
			 .RegWrite(RegWrite),
			 .DataOut(DataOut), //end inputs
			 .Branch_compare(Branch_compare), //output
			 .Address(Address), //output
			 .PrevAddr(PrevAddr), //output
			 .DataOutReady(DataOutReady), //output
			 .DataInValid(DataInValid), //output
			 .DataIn(DataIn)); //output

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
    

