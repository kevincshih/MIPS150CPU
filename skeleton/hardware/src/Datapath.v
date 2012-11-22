module Datapath(
		input [3:0] ALUop,
		input  REUART, WEUART, DinSel, CTsel, CTreset,
		Stall, CLK, DataOutValid, DataInReady, reset, RegWrite, ICacheSel,
		input [1:0] PC_Sel, ALU_Sel_A, ALU_Sel_B, RegDst, UARTsel, RDsel,
		input [7:0] DataOut,
		input [31:0] dcache_dout, icache_dout,
		output Branch_compare, RCIS,
		output [1:0] offset,
		output [31:0] Instruction, PrevInstruction, Address,
		output DataOutReady, DataInValid,
		output [7:0] DataIn,
		output [31:0] dcache_addr, icache_addr, dcache_din, icache_din, PC_toControl		
		);


`include "Opcode.vh"
`include "ALUop.vh"

   //other control wires
   wire 		      not_stall;
   
   //wires for PC
   wire [31:0] 		      PC_Branch, PC_4, PC_JAL, PC_IF;
   
   //wires for IMEM  stage
   wire [31:0] 		      Instruction_Dout_IF;
   wire [11:0] 		      addrb;
   wire [3:0] 		      PC_High_bits;
   wire 		      InstrSrc;
   
   
   
   //wires for RegFile & ALU stage
   wire [4:0]  rs, rt, rd, A3;
   wire [5:0]  prev_opcode, opcode, funct;
   wire [15:0] Imm;
   wire [25:0] JAL_Target; 
   wire [31:0] ALU_SrcA, ALU_SrcB, Imm_Extended, rd1, rd2, Imm_Shifted, JR;
   
   //wires for DataMem and WriteBack stage
   wire [31:0] ALU_OutMW, WriteData, DMEM_dout, UART_Data, dina_unshifted, bios_douta, bios_doutb, CounterData;
   wire [11:0] addra;
   wire [1:0]  prev_offset;
   wire        RegWrite_WB;
  

   //First Pipeline Register
   reg [31:0]  PC_IF_RA, PC_4_Reg;
   reg [31:0]  Instruction_Dout_IF_RA;
   reg 	       InstrSrc_Reg, stall_reg;

   //Second Pipeline Register
   reg [4:0]   A3_RA_DW;
   reg [1:0]   RDsel_Reg, UARTsel_Reg;
   reg 	       RegWrite_Reg;
   reg 	       REUART_Reg, WEUART_Reg;
   reg [31:0]  PrevInstruction_Reg, ALU_OutMW_Reg, rd1_Reg;
   reg [25:0]  JAL_Target_Reg;
   reg [31:0]  InstrCounter, CycleCounter;
  

   //mux registers
   reg [31:0]  ALU_SrcA_Reg, ALU_SrcB_Reg, UART_Data_Reg, WriteData_Reg, douta_masked, dina_shifted;
   reg [4:0]   A3_Reg, RegDst_Reg;
   reg [1:0]   PC_SelReg;
   
   //reset register
   reg 	       resetReg;

   IFControl the_IF_Control(.PC(PC_IF),
			    .reset(reset),
			    .stall(Stall),
			    .REIC(RCIS),
			    .REBIOS(REBIOS),
			    .stall_reg(stall_reg),
			    .IFSel(InstrSrc));
   
   
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

/*   imem_blk_ram the_imem(.clka(CLK),
			 .clkb(CLK),
			 .ena(1'b1),
			 .wea(IMByteSel),
			 .addra(addra),
			 .dina(bios_doutb),
			 .enb(1'b1),
			 .addrb(addrb),
			 .doutb(IMEM_Dout_IF));*/
   
   bios_mem the_bios(.clka(CLK),
		     .ena(1'b1),
		     .addra(addra),
		     .douta(bios_douta),
		     .clkb(CLK),
		     .enb(REBIOS),
		     .addrb(addrb),
		     .doutb(bios_doutb)
		     );
   

/*   dmem_blk_ram the_dmem(.clka(CLK),
			 .ena(1'b1),
			 .wea(DMByteSel),
			 .addra(addra),
			 .dina(dina),
			 .douta(douta));*/
   
   Branch_module the_branch_comparator(.ALUSrcA(ALU_SrcA),
				       .ALUSrcB(ALU_SrcB),
				       .opcode(opcode),
				       .funct(funct),
				       .rt(rt),
				       .take_branch(Branch_compare));
   
   
   always @(posedge CLK) begin
     resetReg <= reset;
      stall_reg <= Stall;
      
      if (CTreset || reset) begin
	 CycleCounter <= 0;
      end
      
      
	 
	 if (not_stall) begin
	 //First Pipeline Registers
	    PC_IF_RA <= PC_IF;
	    InstrSrc_Reg <= InstrSrc;
	    CycleCounter <= CycleCounter + 1;
	    

	 //Second Pipeline Registers
	    A3_RA_DW <= A3_Reg;
	    UARTsel_Reg <= UARTsel;
		RDsel_Reg <= RDsel;
		RegWrite_Reg <= RegWrite;
	    PC_4_Reg <= PC_4;	    
	    PrevInstruction_Reg <= Instruction_Dout_IF_RA;
	    ALU_OutMW_Reg <= ALU_OutMW;
	 
	 end // if (not_stall)
   end // always @ (posedge CLK)
    
   always @(*) begin
    Instruction_Dout_IF_RA = (resetReg) ? 32'b0 : Instruction_Dout_IF;
	PC_SelReg = PC_Sel;
	rd1_Reg = rd1;
	JAL_Target_Reg = Instruction_Dout_IF_RA[25:0];
	REUART_Reg = REUART;
	WEUART_Reg = WEUART;
	end
	
   always @(Instruction) begin
      if (CTreset || reset) InstrCounter = 0;
      InstrCounter = InstrCounter + 1;
   end
   
   always @(*) begin
      case(ALU_Sel_A)
	2'b01: ALU_SrcA_Reg = rd1; // normal r-type
	2'b00: ALU_SrcA_Reg = PC_IF_RA; // calculate branch address
	2'b10: ALU_SrcA_Reg = ALU_OutMW_Reg; // fwd A
	2'b11: ALU_SrcA_Reg = Instruction_Dout_IF[10:6];
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
	2'b10: A3_Reg = 5'b11111; // set $ra for JAL
	default: A3_Reg = rt;
      endcase // case (RegDst)

      case(UARTsel_Reg)
	2'b01: UART_Data_Reg = {31'd0, DataInReady};
	2'b10: UART_Data_Reg = {31'd0, DataOutValid};
	2'b00: UART_Data_Reg = {24'd0, DataOut};
	2'b11: UART_Data_Reg = bios_douta;
	default: UART_Data_Reg = {24'd0, DataOut};
      endcase // case (UARTSel)

      case (RDsel_Reg)
	2'b00: WriteData_Reg = UART_Data;
	2'b01: WriteData_Reg = ALU_OutMW_Reg;
	2'b10: WriteData_Reg = DMEM_dout;
	2'b11: WriteData_Reg = CounterData;
	default: WriteData_Reg = DMEM_dout;
      endcase // case (RDsel)

      case(prev_opcode)
	6'b100000: case(prev_offset) // LB
/*		     2'b00: douta_masked = $signed(douta[7:0]);
		     2'b01: douta_masked = $signed(douta[15:8]);
		     2'b10: douta_masked = $signed(douta[23:16]);
		     2'b11: douta_masked = $signed(douta[31:24]); */

		     2'b00: douta_masked = $signed(dcache_dout[31:24]);
		     2'b01: douta_masked = $signed(dcache_dout[23:16]);
		     2'b10: douta_masked = $signed(dcache_dout[15:8]);
		     2'b11: douta_masked = $signed(dcache_dout[7:0]);
		   endcase // case (offset)

	6'b100001: case(prev_offset) // LH
		     2'b11: douta_masked = $signed(dcache_dout[15:0]);
		     2'b10: douta_masked = $signed(dcache_dout[15:0]);
		     2'b01: douta_masked = $signed(dcache_dout[31:16]);
		     2'b00: douta_masked = $signed(dcache_dout[31:16]);
		   endcase // case (offset)  
	
	6'b100011: douta_masked = dcache_dout; // LW
	
	6'b100100: case(prev_offset) // LBU
		     2'b11: douta_masked = {24'b0, dcache_dout[7:0]};
		     2'b10: douta_masked = {24'b0, dcache_dout[15:8]};
		     2'b01: douta_masked = {24'b0, dcache_dout[23:16]};
		     2'b00: douta_masked = {24'b0, dcache_dout[31:24]};
		   endcase // case (offset)
	
	6'b100101: case(prev_offset) // LHU
		     2'b11: douta_masked = {24'b0, dcache_dout[15:0]};
		     2'b10: douta_masked = {24'b0, dcache_dout[15:0]};
		     2'b01: douta_masked = {24'b0, dcache_dout[31:16]};
		     2'b00: douta_masked = {24'b0, dcache_dout[31:16]};
		   endcase // case (offset)
	
	default: douta_masked = dcache_dout;
      endcase // case (prev_opcode)

      case(opcode)
	6'b101000: case(offset)
		     2'b00: dina_shifted = dina_unshifted[7:0] << 24;
		     2'b01: dina_shifted = dina_unshifted[7:0] << 16;
		     2'b10: dina_shifted = dina_unshifted[7:0] << 8;
		     2'b11: dina_shifted = dina_unshifted;
		   endcase // case (offset)
	6'b101001: case(offset)
		     2'b00: dina_shifted = dina_unshifted[15:0] << 16;
		     2'b01: dina_shifted = dina_unshifted[15:0] << 16;
		     2'b10: dina_shifted = dina_unshifted;
		     2'b11: dina_shifted = dina_unshifted;
		   endcase // case (offset)
      endcase // case (opcode)
      
	       
	
   end

   //Control wires
   assign not_stall = ~Stall;
   
   //Wires in IFetch/IMEM (first stage)
   assign PC_4 = PC_IF + 4;
   assign addrb = PC_IF[13:2];
   assign PC_top_nibble = PC_IF[31:28];
   assign Instruction_Dout_IF = (InstrSrc_Reg)? bios_doutb : icache_dout;
   assign icache_addr = (ICacheSel)? ALU_OutMW : PC_IF;
   
   //Wires in RegFile and ALU (second stage)
   assign Instruction = Instruction_Dout_IF_RA; // output
   assign opcode = Instruction_Dout_IF_RA[31:26];
   assign rs = Instruction_Dout_IF_RA[25:21];
   assign rt = Instruction_Dout_IF_RA[20:16];
   assign rd = Instruction_Dout_IF_RA[15:11];
   assign Imm = Instruction_Dout_IF_RA[15:0];
   assign funct = Instruction_Dout_IF_RA[5:0];
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
   assign dcache_addr = ALU_OutMW;
   assign JR = rd1_Reg;
   assign dina_unshifted = (DinSel) ? ALU_OutMW_Reg : rd2;
   assign dcache_din = (opcode == `SB || opcode == `SH) ? dina_shifted : dina_unshifted;
   assign icache_din = dcache_din;
   assign CounterData = (CTsel)? InstrCounter : CycleCounter;
   assign PC_toControl = PC_IF_RA;
   
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
   assign prev_offset = ALU_OutMW_Reg[1:0];
   
endmodule // Datapath

   

   
   
