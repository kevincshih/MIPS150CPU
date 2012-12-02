module Control(
	       input[31:0]Instruction,
	       input[31:0]OldInstruction,
	       input[31:0]Address, PC,	       
	       input branch, reset,
	       input[1:0] offset,
	       output[1:0]PCsel, RegDst, UARTsel, RDsel,
	       output[1:0]AluSelA, AluSelB,
	       output[3:0]ALUop, IMByteSel, DMByteSel,
	       output REUART, WEUART, RegWrite, DinSel,
	       output CTsel, CTreset, REDC, ICacheSel,
	       output SEXTImm, JRsel
	       );
`include "Opcode.vh"
`include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------
  //Reset flush pipelines posedge
  //IMEM and with `reset
  //start PC at 4
  //--|Solution|----------------------------------------------------------------

   reg 	   MemWriteReg, MemReadReg, DinSelReg;
reg[1:0] AluSelAReg, AluSelBReg, PCselReg, RegWriteReg, RegDstReg, RDselreg, UARTselreg;
reg[3:0] ByteSelReg;
reg WEIMreg, WEDMreg, REUARTreg, WEUARTreg;
reg REICreg, REDCreg, REBIOSreg, CTselreg, CTResetreg, ICacheSelreg, JRselreg;

wire[5:0] op, funct, oldop, oldfunct;
wire[4:0] rs, rt, rd, shamt, oldrs, oldrt, oldrd, oldshamt;
wire[15:0] imm, oldimm;
wire[25:0] target, oldtarget;
wire[3:0] addr;
wire weim, wedm;

  //Load and Store

  //base = rs
  //dest = rt
  //signed offset = imm


assign weim = WEIMreg;
assign wedm = WEDMreg;  
  
  //Rtype

assign op = Instruction[31:26];
assign rs = Instruction[25:21];
assign rt = Instruction[20:16];
assign rd = Instruction[15:11];
assign shamt = Instruction[10:6];
assign funct = Instruction[5:0];

assign oldop = OldInstruction[31:26];
assign oldrs = OldInstruction[25:21];
assign oldrt = OldInstruction[20:16];
assign oldrd = OldInstruction[15:11];
assign oldshamt = OldInstruction[10:6];
assign oldfunct = OldInstruction[5:0];

  //Itype

  //src = rs
  //dest = rt
  //immediate = imm

assign imm = Instruction[15:0];
assign oldimm = OldInstruction[15:0];

  //Jump/PCsel

  //src1 = rs
  //src2 = rt

assign target = Instruction[25:0];
assign oldtarget = OldInstruction[25:0];
assign PCsel = (reset) ? 0 : PCselReg;

  //Read/Write
assign addr = Address[31:28];
assign RegWrite = (reset) ? 0 : RegWriteReg;
assign RegDst = (reset) ? 0 : RegDstReg;
assign MemWrite = (reset) ? 0 : MemWriteReg;
assign MemRead = (reset) ? 0 : MemReadReg;
assign REUART = (reset) ? 0 : REUARTreg;
assign WEUART = (reset) ? 0 : WEUARTreg;
assign JRsel = (reset) ? 0 : JRselreg;

assign IMByteSel = (reset || ~weim) ? 4'b0000 : ByteSelReg;
assign DMByteSel = (reset || ~wedm) ? 4'b0000 : ByteSelReg;
    assign REDC = REDCreg;

  //Muxes
   assign AluSelA = (reset) ? 0 : AluSelAReg;
   assign AluSelB = (reset) ? 0 : AluSelBReg;
   assign UARTsel = (reset) ? 0 : UARTselreg;
   assign RDsel = (reset) ? 0 : RDselreg;
   assign DinSel = (reset) ? 0 : DinSelReg;
   assign CTsel = (reset) ? 0 : CTselreg;
   assign CTreset = (reset) ? 0 : CTResetreg;
   assign ICacheSel = (reset) ? 0 : ICacheSelreg;
   assign SEXTImm = ((op >= `ANDI) && (op <= `LUI)) ? 1'b0 : 1'b1;

ALUdec DUT(.funct(funct),
    .opcode(op),
    .ALUop(ALUop));

//WriteBack Logic

   always @( * ) begin
      if (op == `RTYPE) begin
        RegDstReg = 2'b01;
		RDselreg = 2'b01;
    end
    else if ((op >= `ADDIU) && (op <= `LUI)) begin
        RegDstReg = 2'b00;
		RDselreg = 2'b01;
    end
	else if ((op >= `LB) && (op <= `LHU)) begin
		RegDstReg = 2'b00;
	end
    else if (op == `JAL) begin
        RegDstReg = 2'b10;
		RDselreg = 2'b01;
    end
    else begin
        RegDstReg = 2'b11;
    end
    RegWriteReg = ((op == `RTYPE) && (funct != `JR)) || ((op >= `ADDIU) && (op <= `LUI)) || ((op >= `LB) && (op <= `LHU)) || (op == `JAL);
    MemWriteReg = (op == `SW) || (op == `SH) || (op == `SB);
    MemReadReg = (op == `LW) || (op == `LH) || (op == `LB) || (op == `LHU) || (op == `LBU);
    case(op)
        `SB: ByteSelReg = 4'b1000 >> offset[1:0];
        `SH: ByteSelReg = 4'b1100 >> offset[1] * 2;
        `SW: ByteSelReg = 4'b1111;
        default: ByteSelReg = 4'b0000;
    endcase

//Instruction Cache

    if (MemWrite && ~addr[3] && ~addr[2] && addr[1] && PC[30]) begin
        WEIMreg = 1'b1;
       ICacheSelreg = 1'b1;
    end
    else begin
        WEIMreg = 1'b0;
       ICacheSelreg = 1'b0;
    end
	
   //Data Memory

   if (MemWrite && ~addr[3] && ~addr[2] && addr[0]) begin
      WEDMreg = 1'b1;
   end
   else begin
     WEDMreg = 1'b0;
   end
   
   if (MemRead && ~addr[3] && ~addr[2] && addr[0]) begin
	   RDselreg = 2'b10;
	   REDCreg = 1'b1;
      end
   else
     REDCreg = 1'b0;
		
   //Counter I/O

    if (MemRead && (Address == 32'h80000010)) begin
    	CTselreg = 1'b0;
		RDselreg = 2'b11;
    end
	else if (MemRead && (Address == 32'h80000014)) begin
    	CTselreg = 1'b1;
		RDselreg = 2'b11;
    end
	
	if (MemWrite && (Address == 32'h80000018)) begin
		CTResetreg = 1'b1;
	end
	else CTResetreg = 1'b0;
	
   //UART I/O

    if (MemRead && (Address == 32'h80000000)) begin
        WEUARTreg = 1'b0;
        REUARTreg = 1'b0;
        UARTselreg = 2'b01; //DataInReady
        RDselreg = 2'b00; //ReadFromUART
    end
    else if (MemRead && (Address == 32'h80000004)) begin
        WEUARTreg = 1'b0;
        REUARTreg = 1'b0;
        UARTselreg = 2'b10; //DataOutValid
        RDselreg = 2'b00; //ReadFromUART
    end
    else if (MemWrite && (Address == 32'h80000008)) begin
        WEUARTreg = 1'b1;
        REUARTreg = 1'b0;
    end
    else if (MemRead && (Address == 32'h8000000c)) begin
        WEUARTreg = 1'b0;
        REUARTreg = 1'b1;
        UARTselreg = 2'b00; //DataOut
        RDselreg = 2'b00; //ReadFromUART
    end
    else if (MemRead && (addr == 4'b0100)) begin
        REUARTreg = 1'b0;
        WEUARTreg = 1'b0;
		UARTselreg = 2'b11; //BIOS
        RDselreg = 2'b00; //ReadFromUART
    end
	else begin
		REUARTreg = 1'b0;
		WEUARTreg = 1'b0;
	end
end // always @ ( * )
   
//Branch/Jump Logic

always @( * ) begin
    if (branch) begin
        PCselReg = 2'b01;
    end
    else if ((op == `JAL) || (op == `J)) begin
        PCselReg = 2'b11;
    end
    else if ((op == `RTYPE) && ((funct == `JALR) || (funct == `JR))) begin
        PCselReg = 2'b10;
    end
    else begin
        PCselReg = 2'b00;
    end
end

//ALU Forwarding Logic

always @( * ) begin
    if ((op == `RTYPE) && ((funct == `JALR)||(funct == `JR))) begin
		if ((oldop == `RTYPE) && (oldrd != 0)) begin
          JRselreg = (rs == oldrd) ? 1'b1 : 1'b0;
       end
       else if ((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `LHU))) && (oldrt != 0)) begin
          JRselreg = (rs == oldrt) ? 1'b1 : 1'b0;
       end
       else begin
          JRselreg = 1'b0;
       end
    end

    if ((op == `JAL) || ((op == `RTYPE) && (funct == `JALR))) begin
        AluSelAReg = 2'b00;
        AluSelBReg = 2'b00;
    end
    else if ((funct >= `SLL) && (funct <= `SRA) && op == `RTYPE) begin
       AluSelAReg = 2'b11;
       if ((oldop == `RTYPE) && (oldrd != 0)) begin
	  AluSelBReg = (rt == oldrd) ? 2'b10 : 2'b01;
       end
       else if ((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `LHU))) && (oldrt != 0)) begin
	  AluSelBReg = (rt == oldrt) ? 2'b10 : 2'b01;
       end
       else begin
	  AluSelBReg = 2'b01;
       end // else: !if((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `SW))) && (oldrt != 0))
    end
    else  if ((op >= `RTYPE) && (op <= `BGTZ)) begin
       if ((oldop == `RTYPE) && (oldrd != 0)) begin
          AluSelAReg = (rs == oldrd) ? 2'b10 : 2'b01;
          AluSelBReg = (rt == oldrd) ? 2'b10 : 2'b01;
       end
       else if ((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `LHU))) && (oldrt != 0)) begin
          AluSelAReg = (rs == oldrt) ? 2'b10 : 2'b01;
          AluSelBReg = (rt == oldrt) ? 2'b10 : 2'b01;
       end
       else begin
          AluSelAReg = 2'b01;
          AluSelBReg = 2'b01;
       end
    end
    else if (((op >= `ADDIU) && (op <= `LUI)) || ((op >= `LB) && (op <= `SW))) begin
        if ((oldop == `RTYPE) && (oldrd != 0)) begin
            AluSelAReg = (rs == oldrd) ? 2'b10 : 2'b01;
            AluSelBReg = 2'b11;
	   DinSelReg = (rt == oldrd);
        end
        else if ((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `LHU))) && (oldrt != 0)) begin
            AluSelAReg = (rs == oldrt) ? 2'b10 : 2'b01;
            AluSelBReg = 2'b11;
	   DinSelReg = (rt == oldrt);
        end
        else begin
            AluSelAReg = 2'b01;
            AluSelBReg = 2'b11;
	   DinSelReg = 1'b0;
        end
    end
    else begin
        AluSelAReg = 2'b01;
        AluSelBReg = 2'b01;
    end // else: !if(((op >= `ADDIU) && (op <= `LUI)) || ((op >= `LB) && (op <= `SW)))

end

endmodule
