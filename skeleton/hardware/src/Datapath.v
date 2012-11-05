module Datapath(
		input [3:0] ALUop, ByteSel,
		input WEIM, WEDM, REUART, WEUART, DinSel,
		Stall, CLK, DataOutValid, DataInReady, reset, RegWrite,
		input [1:0] PC_Sel, ALU_Sel_A, ALU_Sel_B, RegDst, UARTsel, RDsel,
		input [7:0] DataOut,
		output Branch_compare,
		output [31:0] Instruction, PrevInstruction, Address,
		output DataOutReady, DataInValid,
		output [7:0] DataIn
		);


`include "Opcode.vh"
`include "ALUop.vh"

   //other control wires
   wire 		      not_stall;
   
   //wires for PC
   wire [31:0] 		      PC_Branch, PC_4, PC_JAL, PC_IF;
   
   //wires for IMEM  stage
   wire [31:0] IMEM_Dout_IF;
   wire [11:0] addrb;
   
   //wires for RegFile & ALU stage
   wire [3:0]  PC_High_bits;
   wire [4:0]  rs, rt, rd, A3;
   wire [5:0]  prev_opcode, opcode, funct;
   wire [15:0] Imm;
   wire [25:0] JAL_Target; 
   wire [31:0] ALU_SrcA, ALU_SrcB, Imm_Extended, rd1, rd2, Imm_Shifted, JR;
   
   //wires for DataMem and WriteBack stage
   wire [31:0] ALU_OutMW, WriteData, DMEM_dout, UART_Data, douta, dina;
   wire [11:0] addra;
   wire [1:0]  offset;
   wire        RegWrite_WB;
  

   //First Pipeline Register
   reg [31:0]  PC_IF_RA, PC_4_Reg;
   reg [31:0]  IMEM_Dout_IF_RA;

   //Second Pipeline Register
   reg [4:0]   A3_RA_DW;
   reg [1:0]   RDsel_Reg, UARTsel_Reg;
   reg 	       WEDM_RA_DW, RegWrite_Reg;
   reg 	       REUART_Reg, WEUART_Reg;
   reg [31:0]  PrevInstruction_Reg, ALU_OutMW_Reg, rd1_Reg;
   reg [25:0]  JAL_Target_Reg;

   //mux registers
   reg [31:0]  ALU_SrcA_Reg, ALU_SrcB_Reg, UART_Data_Reg, WriteData_Reg, douta_masked;
   reg [4:0]   A3_Reg, RegDst_Reg;
   reg [1:0]   PC_SelReg;
   
   //reset register
   reg resetReg;
   
   ALU the_ALU(.A(ALU_SrcA),
	       .B(ALU_SrcB),
	       .ALUop(ALUop),
	       .Out(ALU_OutMW));
   

   PC the_PC(.PC_Branch(PC_Branch),
	     .PC_4(PC_4),
	     .PC_JAL(PC_JAL),
	     .PC_Sel(PC_SelReg),
	     .JR(JR),
	     .EN(not_stall),
	     .CLK(CLK),
	     .RST(reset),
	     .PC_IF(PC_IF));

   RegFile the_regfile(.clk(CLK),
		       .we(RegWrite_WB),
		       .ra1(rs),
		       .ra2(rt),
		       .wa(A3_RA_DW),
		       .wd(WriteData),
		       .rd1(rd1),
		       .rd2(rd2));

   imem_blk_ram the_imem(.clka(CLK),
			 .clkb(CLK),
			 .ena(not_stall && WEIM),
			 .wea(ByteSel),
			 .addra(addra),
			 .dina(dina),
			 .addrb(addrb),
			 .doutb(IMEM_Dout_IF));

   dmem_blk_ram the_dmem(.clka(CLK),
			 .ena(not_stall && WEDM),
			 .wea(ByteSel),
			 .addra(addra),
			 .dina(dina),
			 .douta(douta));
   
   Branch_module the_branch_comparator(.ALUSrcA(ALU_SrcA),
				       .ALUSrcB(ALU_SrcB),
				       .opcode(opcode),
				       .funct(funct),
				       .rt(rt),
				       .take_branch(Branch_compare));
   
   
   always @(posedge CLK) begin
     resetReg <= reset;
	 
	 if (not_stall) begin
	 //First Pipeline Registers
	    PC_IF_RA <= PC_IF;

	 //Second Pipeline Registers
	    A3_RA_DW <= A3_Reg;
	    UARTsel_Reg <= UARTsel;
		RDsel_Reg <= RDsel;
		RegWrite_Reg <= RegWrite;
	    PC_4_Reg <= PC_4;	    
	    PrevInstruction_Reg <= IMEM_Dout_IF_RA;
	    ALU_OutMW_Reg <= ALU_OutMW;
	 
	 end // if (not_stall)
   end // always @ (posedge CLK)
    
   always @(*) begin
    IMEM_Dout_IF_RA = (resetReg) ? 32'b0 : IMEM_Dout_IF;
	PC_SelReg = PC_Sel;
	rd1_Reg = rd1;
	JAL_Target_Reg = IMEM_Dout_IF_RA[25:0];
	WEDM_RA_DW = WEDM;
	REUART_Reg = REUART;
	WEUART_Reg = WEUART;
	    
	end
	

   always @(*) begin
      case(ALU_Sel_A)
	2'b01: ALU_SrcA_Reg = rd1; // normal r-type
	2'b00: ALU_SrcA_Reg = PC_IF_RA; // calculate branch address
	2'b10: ALU_SrcA_Reg = ALU_OutMW_Reg; // fwd A
	default: ALU_SrcA_Reg = rd1;
      endcase // case (ALU_Sel_A)
      
      case(ALU_Sel_B)
	2'b01: ALU_SrcB_Reg = rd2; // normal r-type
 	2'b00: ALU_SrcB_Reg = 32'd8; // PC+8 for JAL
	2'b10: ALU_SrcB_Reg = ALU_OutMW_Reg; // fwd B
	2'b11: ALU_SrcB_Reg = Imm_Extended; // imm for i-type
	default: ALU_SrcB_Reg = rd2;
      endcase // case (ALU_Sel_B)
      
      case(RegDst)
	2'b00: A3_Reg = rt;
	2'b01: A3_Reg = rd;
	2'b10: A3_Reg = 5'd31; // set $ra for JAL
	default: A3_Reg = rt;
      endcase // case (RegDst)

      case(UARTsel_Reg)
	2'b01: UART_Data_Reg = {31'd0, DataInReady};
	2'b10: UART_Data_Reg = {31'd0, DataOutValid};
	2'b00: UART_Data_Reg = {24'd0, DataOut};
	default: UART_Data_Reg = {24'd0, DataOut};
      endcase // case (UARTSel)

      case (RDsel_Reg)
	2'b00: WriteData_Reg = UART_Data;
	2'b01: WriteData_Reg = ALU_OutMW_Reg;
	2'b10: WriteData_Reg = DMEM_dout;
	default: WriteData_Reg = DMEM_dout;
      endcase // case (RDsel)

      case(prev_opcode)
	6'b100000: case(offset) // LB
		     2'b00: douta_masked = $signed(douta[7:0]);
		     2'b01: douta_masked = $signed(douta[15:8]);
		     2'b10: douta_masked = $signed(douta[23:16]);
		     2'b11: douta_masked = $signed(douta[31:24]);
		   endcase // case (offset)

	6'b100001: case(offset) // LH
		     2'b00: douta_masked = $signed(douta[31:16]);
		     2'b01: douta_masked = $signed(douta[15:0]);
		     2'b10: douta_masked = $signed(douta[31:16]);
		     2'b11: douta_masked = $signed(douta[15:0]);
		   endcase // case (offset)  
	
	6'b100011: douta_masked = douta; // LW
	
	6'b100100: case(offset) // LBU
		     2'b00: douta_masked = {24'b0, douta[7:0]};
		     2'b01: douta_masked = {24'b0, douta[15:8]};
		     2'b10: douta_masked = {24'b0, douta[23:16]};
		     2'b11: douta_masked = {24'b0, douta[31:24]};
		   endcase // case (offset)
	
	6'b100101: case(offset) // LHU
		     2'b00: douta_masked = {24'b0, douta[31:16]};
		     2'b01: douta_masked = {24'b0, douta[15:0]};
		     2'b10: douta_masked = {24'b0, douta[31:16]};
		     2'b11: douta_masked = {24'b0, douta[15:0]};
		   endcase // case (offset)
	
	default: douta_masked = douta;
      endcase // case (prev_opcode)
      
	

	
   end

   //Control wires
   assign not_stall = ~Stall;
   
   //Wires in IFetch/IMEM (first stage)
   assign PC_4 = PC_IF + 4;
   assign addrb = PC_IF[13:2];

   //Wires in RegFile and ALU (second stage)
   assign Instruction = IMEM_Dout_IF_RA; // output
   assign opcode = IMEM_Dout_IF_RA[31:26];
   assign rs = IMEM_Dout_IF_RA[25:21];
   assign rt = IMEM_Dout_IF_RA[20:16];
   assign rd = IMEM_Dout_IF_RA[15:11];
   assign Imm = IMEM_Dout_IF_RA[15:0];
   assign funct = IMEM_Dout_IF_RA[5:0];
   assign ALU_SrcA = ALU_SrcA_Reg;
   assign ALU_SrcB = ALU_SrcB_Reg;
   assign Address = ALU_OutMW; // output to control
   assign RegWrite_WB = RegWrite_Reg;

   assign PC_High_bits = PC_IF_RA[31:28];
   assign JAL_Target = JAL_Target_Reg;
   assign PC_JAL = {PC_High_bits, JAL_Target, 2'b00};
   assign Imm_Extended = $signed(Imm);
   assign Imm_Shifted = Imm_Extended << 2;
   assign PC_Branch = Imm_Shifted + PC_4_Reg;

   
   assign addra = ALU_OutMW[13:2];
   assign JR = rd1_Reg;
   assign dina = (DinSel) ? ALU_OutMW_Reg : rd2;
   
   //Wires in DataMem and WriteBack (third stage)
   assign A3 = A3_RA_DW;
   assign DataOutReady = REUART_Reg; // output
   assign DataInValid = WEUART_Reg; // output
   assign PrevInstruction = PrevInstruction_Reg; // output
   assign DataIn = rd2[7:0]; // output
   assign WriteData = WriteData_Reg;
   assign UART_Data = UART_Data_Reg;
   assign prev_opcode = PrevInstruction_Reg[31:26];
   assign DMEM_dout = douta_masked;
   assign offset = ALU_OutMW[1:0];
   
endmodule // Datapath

   

   
   
