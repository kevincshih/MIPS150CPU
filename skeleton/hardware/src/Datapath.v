module Datapath(
		input [3:0] ALUop, ISRByteSel,  
		input  REUART, WEUART, DinSel, CTsel, CTreset, isr_pc, mtc0, mfc0, irh, 
		Stall, CLK, DataOutValid, DataInReady, reset, RegWrite, ICacheSel, SEXTImm, JRsel,
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
	
	wire mmult_debug;
	assign mmult_debug = 1'b0;
	
   //other control wires
   wire 		      not_stall;
   
   //wires for PC
   wire [31:0] 		      PC_Branch, PC_4, PC_JAL, PC_IF, PC_IF2;
   
   //wires for IMEM  stage
   wire [31:0] 		      Instruction_Dout_IF;
   wire [11:0] 		      addrb;
   wire [3:0] 		      PC_High_bits;
   wire [1:0]		      InstrSrc;
   
   
   
   //wires for RegFile & ALU stage
   wire [4:0]  rs, rt, rd, A3;
   wire [5:0]  prev_opcode, opcode, funct;
   wire [15:0] Imm;
   wire [25:0] JAL_Target; 
   wire [31:0] ALU_SrcA, ALU_SrcB, Imm_Extended, Imm_Zero, Immediate, rd1, rd2, Imm_Shifted, JR;
   
   //wires for DataMem and WriteBack stage
   wire [31:0] ALU_OutMW, WriteData, DMEM_dout, UART_Data, dina_unshifted, bios_douta, bios_doutb, CounterData, icache_addr_prestall;
   wire [11:0] addra;
   wire [1:0]  prev_offset;
   wire        RegWrite_WB;
   wire [31:0] ALU_OutMW_ALU;

  

   //First Pipeline Register
   reg [31:0]  PC_IF_RA, PC_4_Reg;
   reg [31:0]  Instruction_Dout_IF_RA, Instruction_Dout_IF_Reg;
   reg 	       InstrSrc_Reg, stall_reg;

   //Second Pipeline Register
   reg [4:0]   A3_RA_DW;
   reg [1:0]   RDsel_Reg, UARTsel_Reg;
   reg 	       RegWrite_Reg, mfc0_Reg;
   reg 	       REUART_Reg, WEUART_Reg;
   reg [31:0]  PrevInstruction_Reg, ALU_OutMW_Reg, rd1_Reg, icache_addr_prestall_reg, dcache_addr_prestall_reg;
   reg [25:0]  JAL_Target_Reg;
   reg [31:0]  InstrCounter, CycleCounter;
  
   //UART Registers
   reg DataOutValidReg, DataInReadyReg;
  

   //mux registers
   reg [31:0]  ALU_SrcA_Reg, ALU_SrcB_Reg, UART_Data_Reg, WriteData_Reg, douta_masked, dina_shifted, bios_douta_masked;
   reg [4:0]   A3_Reg;
   reg [1:0]   PC_SelReg;
   
   //reset register
   reg 	       resetReg;
   
   wire REBIOS, REISR;
   
   wire [31:0] isr_doutb;
   
   IFControl the_IF_Control(.PC(PC_IF),
			    .reset(reset),
			    .stall(Stall),
			    .REIC(RCIS),
			    .REBIOS(REBIOS),
				.REISR(REISR),
			    .stall_reg(stall_reg),
			    .IFSel(InstrSrc));
   
   
   ALU the_ALU(.A(ALU_SrcA),
	       .B(ALU_SrcB),
	       .ALUop(ALUop),
	       .Out(ALU_OutMW_ALU));
   

   PC the_PC(.PC_Branch(PC_Branch),
	     .PC_4(PC_4),
	     .PC_JAL(PC_JAL),
	     .PC_Sel(PC_SelReg),
	     .JR(JR),
	     .EN(not_stall),
	     .CLK(CLK),
	     .RST(reset),
	     .PC_IF(PC_IF2));

   RegFile the_regfile(.clk(CLK),
		       .we(RegWrite_WB),
		       .ra1(rs),
		       .ra2(rt),
		       .wa(A3_RA_DW),
		       .wd(WriteData),
		       .rd1(rd1),
		       .rd2(rd2));

   bios_mem the_bios(.clka(CLK),
		     .ena(1'b1),
		     .addra(addra),
		     .douta(bios_douta),
		     .clkb(CLK),
		     .enb(REBIOS),
		     .addrb(addrb),
		     .doutb(bios_doutb)
		     );
			 
	isr_mem the_isr(.clka(CLK),
		     .ena(1'b1),
			 .wea(ISRByteSel),
		     .addra(addra),
			 .dina(icache_din),
		     .clkb(CLK),
		     .addrb(addrb),
		     .doutb(isr_doutb)
		     );		 
   
   Branch_module the_branch_comparator(.ALUSrcA(ALU_SrcA),
				       .ALUSrcB(ALU_SrcB),
				       .opcode(opcode),
				       .funct(funct),
				       .rt(rt),
				       .take_branch(Branch_compare));
   
   
   wire irq, ur0, ur1;
   wire [31:0] cop_dout;
   //wire cop_din_en;
   
   
   	COP0150 the_COP0150(
	.Clock(CLK), //Done
    .Enable(1'b1), //Done
    .Reset(reset), //Done

    .DataAddress(rd), //Done
    .DataOut(cop_dout), //connect to ALU, Done
    .DataInEnable(mtc0), //done
    .DataIn(ALU_SrcB), //done

    .InterruptedPC(PC_IF2), //done
    .InterruptHandled(irh), //done
    .InterruptRequest(irq), //done in COP0150

    .UART0Request(ur0), //done
    .UART1Request(ur1) //done
	);
   
   
   assign ur0 = (DataOutValid == 1'b1) && (DataOutValidReg == 1'b0);
   assign ur1 = (DataInReady == 1'b1) && (DataInReadyReg == 1'b0);
   assign ALU_OutMW = (isr_pc) ? cop_dout : ALU_OutMW_ALU;
   
   
   always @(Instruction) begin
      if (CTreset || reset) InstrCounter = 0;
      else InstrCounter = InstrCounter + 1;
   end   
   
   always @(posedge CLK) begin
      resetReg <= reset;
      stall_reg <= Stall;
      
      if (CTreset || reset) begin
	 CycleCounter <= 0;
      end
      else CycleCounter <= CycleCounter + 1;
      
      if (not_stall) begin
	 //First Pipeline Registers
	 PC_IF_RA <= PC_IF;
	 InstrSrc_Reg <= InstrSrc;
	 icache_addr_prestall_reg <= icache_addr_prestall;
	 
	 //Second Pipeline Registers
	 mfc0_Reg <= mfc0;
	 A3_RA_DW <= A3_Reg;
	 UARTsel_Reg <= UARTsel;
	 RDsel_Reg <= RDsel;
	 RegWrite_Reg <= RegWrite;
	 PC_4_Reg <= PC_4;	    
	 PrevInstruction_Reg <= Instruction_Dout_IF_RA;
	 ALU_OutMW_Reg <= ALU_OutMW;
	 dcache_addr_prestall_reg <= dcache_addr;
	 
	 //UART registers
	 DataOutValidReg <= DataOutValid;
	 DataInReadyReg <= DataInReady;
	 
	 
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
   
   
   
   always @(*) begin
	
	case(InstrSrc_Reg)
	2'b00: Instruction_Dout_IF_Reg = icache_dout;
	2'b01: Instruction_Dout_IF_Reg = bios_doutb;
	2'b10: Instruction_Dout_IF_Reg = isr_doutb;
	default: Instruction_Dout_IF_Reg = bios_doutb;
	endcase
	
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
	2'b11: ALU_SrcB_Reg = Immediate; // immediate, zero or SE'd, for i-type
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
	2'b11: UART_Data_Reg = bios_douta_masked;
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


      // masks for bios_douta
          case(prev_opcode)
	    6'b100000: case(prev_offset) // LB
			 2'b00: bios_douta_masked = $signed(bios_douta[31:24]);
			 2'b01: bios_douta_masked = $signed(bios_douta[23:16]);
			 2'b10: bios_douta_masked = $signed(bios_douta[15:8]);
			 2'b11: bios_douta_masked = $signed(bios_douta[7:0]);
			    endcase // case (offset)

	    6'b100001: case(prev_offset) // LH
			 2'b11: bios_douta_masked = $signed(bios_douta[15:0]);
			 2'b10: bios_douta_masked = $signed(bios_douta[15:0]);
			 2'b01: bios_douta_masked = $signed(bios_douta[31:16]);
			 2'b00: bios_douta_masked = $signed(bios_douta[31:16]);
		       endcase // case (offset)
	    
	    6'b100011: bios_douta_masked = bios_douta;
	     // LW
	    6'b100100: case(prev_offset) // LBU
			 2'b11: bios_douta_masked = {24'b0, bios_douta[7:0]};
			 2'b10: bios_douta_masked = {24'b0, bios_douta[15:8]};
			 2'b01: bios_douta_masked = {24'b0, bios_douta[23:16]};
			 2'b00: bios_douta_masked = {24'b0, bios_douta[31:24]};
		       endcase // case (offset)
	    
	    6'b100101: case(prev_offset) // LHU
			 2'b11: bios_douta_masked = {24'b0, bios_douta[15:0]};
			 2'b10: bios_douta_masked = {24'b0, bios_douta[15:0]};
			 2'b01: bios_douta_masked = {24'b0, bios_douta[31:16]};
			 2'b00: bios_douta_masked = {24'b0, bios_douta[31:16]};
		       endcase // case (offset)
	    
	    default: bios_douta_masked = bios_douta;
	  endcase // case (prev_opcode)
	       
	
   end

   //Control wires
   assign not_stall = ~Stall;
   
   //Wires in IFetch/IMEM (first stage)
   //assign PC_IF = (mmult_debug) ? {4'b0100, PC_IF2[27:0]}: PC_IF2;
   assign PC_IF = (irq) ? 32'hc0000000 : PC_IF2;
   assign PC_4 = PC_IF + 4;
   assign addrb = PC_IF[13:2];
   assign PC_top_nibble = PC_IF[31:28];
   assign Instruction_Dout_IF = Instruction_Dout_IF_Reg;
   assign icache_addr_prestall = (ICacheSel)? ALU_OutMW : PC_IF;
   assign icache_addr = (not_stall)? icache_addr_prestall : icache_addr_prestall_reg;
   
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
   assign RegWrite_WB = (RegWrite_Reg || mfc0_Reg);

   assign PC_High_bits = PC_IF_RA[31:28];
   assign JAL_Target = JAL_Target_Reg;
   assign PC_JAL = {PC_High_bits, JAL_Target, 2'b00};
   assign Imm_Extended = $signed(Imm);
   assign Imm_Zero = {16'b0, Imm};
   assign Imm_Shifted = Imm_Extended << 2;
   assign Immediate = (SEXTImm)? Imm_Extended : Imm_Zero;
   assign PC_Branch = Imm_Shifted + PC_4_Reg;

   assign addra = ALU_OutMW[13:2];
   assign dcache_addr = (not_stall)? ALU_OutMW : dcache_addr_prestall_reg;
   assign JR = (JRsel)? ALU_OutMW_Reg: rd1_Reg;
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

   

   
   
