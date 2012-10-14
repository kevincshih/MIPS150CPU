module Datapath(
		input [3:0] ALUop, ByteSel,
		input WEIM, WEDM, REUART, WEUART, UARTsel, RDsel,
		Stall, CLK, DataOutValid, DataInReady, reset,
		input [1:0] PC_Sel, ALU_Sel_A, ALU_Sel_B, RegDst,
		input [7:0] DataOut,
		output Branch_compare,
		output [31:0] Address, PrevAddr,
		output DataOutReady, DataInValid,
		output [7:0] DataIn,
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
   wire [5:0]  prev_opcode, opcode;
   wire [15:0] Imm;
   wire [25:0] JAL_Target; 
   wire [31:0] ALU_SrcA, ALU_SrcB, Imm_Extended, rd1, rd2, Imm_Shifted, JR;
   
   //wires for DataMem and WriteBack stage
   wire [31:0] ALU_OutMW, WriteData, DMEM_dout, UART_Data, douta;
   wire [11:0] addra;
   wire [1:0]  offset;

   //First Pipeline Register
   reg [31:0]  PC_IF_RA;
   reg [31:0]  IMEM_Dout_IF_RA;

   //Second Pipeline Register
   reg [4:0]   A3_RA_DW;
   reg 	       WEDM_RA_DW;
   reg 	       REUART_Reg, WEUART_Reg, UARTsel_Reg,RDsel_Reg;
   reg [31:0]  PrevAddr_Reg, ALU_OutMW_Reg;

   //mux registers
   reg [31:0]  ALU_SrcA_Reg, ALU_SrcB_Reg, UART_Data_Reg, WriteData_Reg, douta_masked;
   reg [4:0]   A3_Reg, RegDst_Reg;
   
   ALU the_ALU(.A(ALU_SrcA),
	       .B(ALU_SrcB),
	       .ALUop(ALUop),
	       .Out(ALU_OutMW));
   

   PC the_PC(.PC_Branch(PC_Branch),
	     .PC_4(PC_4),
	     .PC_JAL(PC_JAL),
	     .PC_Sel(PC_Sel),
	     .JAR(rd1),
	     .EN(not_stall),
	     .CLK(CLK),
	     .PC_IF(PC_IF));

   RegFile the_regfile(.clk(CLK),
		       .we(not_stall),
		       .ra1(rs),
		       .ra2(rt),
		       .wa(A3_RA_DW),
		       .wd(WriteData),
		       .rd1(rd1),
		       .rd2(rd2));

   imem_blk_ram the_imem(.clka(CLK),
			 .ena(not_stall),
			 .wea(ByteSel),
			 .addra(addra),
			 .dina(rd2),
			 .addrb(addrb),
			 .doutb(IMEM_Dout_IF));

   dmem_blk_ram the_dmem(.clka(CLK),
			 .ena(not_stall),
			 .wea(ByteSel),
			 .addra(addra),
			 .dina(rd2),
			 .douta(douta));

   Branch_module the_branch_comparator(.ALUSrcA(ALU_SrcA),
				       .ALUSrcB(ALU_SrcB),
				       .opcode(opcode),
				       .rt(rt)
				       .take_branch(Branch_compare));
   
   
   always @(posedge CLK) begin
      if (not_stall) begin
	 //First Pipeline Registers
	 IMEM_Dout_IF_RA <= IMEM_Dout_IF;
	 PC_IF_RA <= PC_IF;

	 //Second Pipeline Registers
	 A3_RA_DW <= A3_Reg;
	 WDEM_RA_DW <= WDEM;

	 REUART_Reg <= REUART;
	 WEUART_Reg <= WEUART;
	 UARTsel_Reg <= UARTsel;
	 RDsel_Reg <= RDsel;
	 
	 PrevAddr_Reg <= IMEM_Dout_IF_RA;
	 ALU_OutMW_Reg <= ALU_OutMW;
	 
      end // if (not_stall)
   end // always @ (posedge CLK)
   

   always @(*) begin
      case(ALU_Sel_A)
	xx: ALU_SrcA_Reg = rd1; // normal r-type
	xx: ALU_SrcA_Reg = PC_IF_RA; // calculate branch address
	xx: ALU_SrcA_Reg = ALU_OutMW; // fwd A
	default: ALU_SrcA_Reg = rd1;
      endcase // case (ALU_Sel_A)
      
      case(ALU_Sel_B)
	xx: ALU_SrcB_Reg = rd2; // normal r-type
	xx: ALU_SrcB_Reg = 32'd8; // PC+8 for JAL
	xx: ALU_SrcB_Reg = ALU_OutMW; // fwd B
	xx: ALU_SrcB_Reg = Imm_Extended; // imm for i-type
	default: ALU_SrcB_Reg = rd2;
      endcase // case (ALU_Sel_B)
      
      case(RegDst)
	xx: A3_Reg = rt;
	xx: A3_Reg = rd;
	xx: A3_Reg = 5'd32; // set $ra for JAL
	default: A3_Reg = rt;
      endcase // case (RegDst)

      case(UARTSel_Reg)
	xx: UART_Data_Reg = {31'd0, DataInReady};
	xx: UART_Data_Reg = {31'd0, DataOutValid};
	xx: UART_Data_Reg = {24'd0, DataOut};
	default: {24'd0, DataOut};
      endcase // case (UARTSel)

      case (RDsel_Reg)
	xx: WriteData_Reg = UART_Data;
	xx: WriteData_Reg = ALU_OutMW;
	xx: WriteData_Reg = DMEM_dout;
	default: RDsel_Reg = DMEM_dout;
      endcase // case (RDsel)

      case(prev_opcode)
	6'b100000: case(offset) // LB
		     2'b00: douta_masked = $signed(douta[31:24]);
		     2'b01: douta_masked = $signed(douta[23:16]);
		     2'b10: douta_masked = $signed(douta[15:8]);
		     2'b11: douta_masked = $signed(douta[7:0]);
		   endcase // case (offset)

	6'b100001: case(offset) // LH
		     2'b00: douta_masked = $signed(douta[31:16]);
		     2'b01: douta_masked = $signed(douta[15:0]);
		     2'b10: douta_masked = $signed(douta[31:16]);
		     2'b11: douta_masked = $signed(douta[15:0]);
		   endcase // case (offset)  
	
	6'b100011: douta_masked = douta; // LW
	
	6'b100100: case(offset) // LBU
		     2'b00: douta_masked = {24'b0, douta[31:24]};
		     2'b01: douta_masked = {24'b0, douta[23:16]};
		     2'b10: douta_masked = {24'b0, douta[15:8]};
		     2'b11: douta_masked = {24'b0, douta[7:0]};
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
   assign addrb = PC_IF[2:13];

   //Wires in RegFile and ALU (second stage)
   assign Address = IMEM_Dout_IF_RA; // output
   assign opcode = IMEM_Dout_IF_RA[31:26];
   assign rs = IMEM_Dout_IF_RA[25:21];
   assign rt = IMEM_Dout_IF_RA[20:16];
   assign rd = IMEM_Dout_IF_RA[15:11];
   assign Imm = IMEM_Dout_IF_RA[15:0];
   assign PC_High_Bits = PC_IF_RA[11:8];
   assign ALU_SrcA = ALU_SrcA_Reg;
   assign ALU_SrcB = ALU_SrcB_Reg;

   assign PC_JAL = {PC_High_Bits, JAL_Target, 2'b00};
   assign Imm_Extended = $signed(Imm);
   assign Imm_Shifted = Imm_Extended << 2;
   assign PC_Branch = Imm_Shifted + PC_4;

   assign addra = ALU_OutMW[13:2];
   

   //Wires in DataMem and WriteBack (third stage)
   assign A3 = A3_RA_DW;
   assign DataOutReady = REUART_Reg; // output
   assign DataInValid = WEUART_Reg; // output
   assign PrevAddr = PrevAddr_Reg; // output
   assign DataIn = rd2[7:0]; // output
   assign WriteData = WriteData_Reg;
   assign UART_Data = UART_Data_Reg;
   assign prev_opcode = PrevAddr_Reg[31:26];
   assign DMEM_dout = douta_masked;
   assign offset = ALU_OutMW_Reg[1:0];
   
endmodule // Datapath

   

   
   
