module Control(
    input[31:0]Instruction,
    input[31:0]OldInstruction,
    input[31:0]Address,
    input branch,
    output[1:0]PCsel, RegDst, UARTsel, RDsel,
    output[1:0]AluSelA, AluSelB,
    output[3:0]ALUop, ByteSel,
    output WEIM, WEDM, REUART, WEUART, RegWrite
    );
    `include "Opcode.vh"
    `include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------
  //Reset flush pipelines posedge
  //IMEM and with `reset
  //start PC at 4
  //--|Solution|----------------------------------------------------------------

reg MemWriteReg, MemReadReg;
reg[1:0] AluSelAReg, AluSelBReg, PCselReg, RegWriteReg, RegDstReg, RDselreg, UARTselreg;
reg[3:0] ByteSelReg;
reg WEIMreg, WEDMreg, REUARTreg, WEUARTreg;

wire[5:0] op, funct, oldop, oldfunct;
wire[4:0] rs, rt, rd, shamt, oldrs, oldrt, oldrd, oldshamt;
wire[15:0] imm, oldimm;
wire[25:0] target, oldtarget;
wire[3:0] addr;

  //Load and Store

  //base = rs
  //dest = rt
  //signed offset = imm

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
assign PCsel = PCselReg;

  //Read/Write
assign addr = Address[31:28];
assign RegWrite = RegWriteReg;
assign RegDst = RegDstReg;
assign MemWrite = MemWriteReg;
assign MemRead = MemReadReg;
assign WEIM = WEIMreg;
assign WEDM = WE
DMreg;
assign REUART = REUARTreg;
assign WEUART = WEUARTreg;

  //Muxes
assign AluSelA = AluSelAReg;
assign AluSelB = AluSelBReg;
assign ByteSel = ByteSelReg;
assign UARTsel = UARTselreg;
assign RDsel = R
Dselreg;

ALUdec DUT(.funct(funct),
    .opcode(op),
    .ALUop(ALUop));

//WriteBack Logic

always @( * ) begin
    if (op == `RTYPE) begin
        RegDstReg = 2'b01;
    end
    else if (((op >= `ADDIU) && (op <= `LUI)) || ((op >= `LB) && (op <= `LHU))) begin
        RegDstReg = 2'b00;
    end
    else if (funct == `JAL) begin
        RegDstReg = 2'b10;
    end
    else begin
        RegDstReg = 2'b11;
    end
    RegWriteReg = (op == `RTYPE) || ((op >= `ADDIU) && (op <= `LUI)) || ((op >= `LB) && (op <= `LHU));
    MemWriteReg = (op == `SW) || (op == `SH) || (op == `SB);
    MemReadReg = (op == `LW) || (op == `LH) || (op == `LB) || (op == `LHU) || (op == `LBU);
    case(op)
        `SB: ByteSelReg = 4'b0001;
        `SH: ByteSelReg = 4'b0011;
        `SW: ByteSelReg = 4'b1111;
        default: ByteSelReg = 4'b0000;
    endcase
end

//Instruction Memory

always @( * ) begin
    if (MemWrite && ~addr[3] && addr[1]) begin
        WEIMreg = 1'b1;
    end
    else begin
        WEIMreg = 1'b0;
    end
end


//Data Memory
always @( * ) begin
    if (MemWrite && ~addr[3] && addr[0]) begin
            WEDMreg = 1'b1;
        end
    else if (MemRead && ~addr[3] && addr[0]) begin
        WEDMreg = 1'b0;
		RDselreg = 2'b10;
        end
    else
        WEDMreg = 1'b0;
end



//UART I/O

always @( * ) begin
    if (MemRead && (Address == 32'h8000000)) begin
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
    else begin
        REUARTreg = 1'b0;
        WEUARTreg = 1'b0;
    end
end

//Branch/Jump Logic

always @( * ) begin
    if (branch) begin
        PCselReg = 2'b01;
    end
    else if ((op == `JAL) || (op == `J)) begin
        PCselReg = 2'b11;
    end
    else if ((op == `RTYPE) && ((funct == `JALR) || (funct == `JAL))) begin
        PCselReg = 2'b00;
    end
    else begin
        PCselReg = 2'b10;
    end
end

//ALU Forwarding Logic

always @( * ) begin
    if ((op == `JAL) || ((op == `RTYPE) && (funct == `JALR))) begin
        AluSelAReg = 2'b00;
        AluSelBReg = 2'b00;
    end
    else if ((op >= `RTYPE) && (op <= `BGTZ)) begin
        if ((oldop == `RTYPE) && (oldrd != 0)) begin
            AluSelAReg = (rs == oldrd) ? 2'b10 : 2'b01;
            AluSelBReg = (rt == oldrd) ? 2'b10 : 2'b01;
        end
        else if ((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `SW))) && (oldrt != 0)) begin
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
        end
        else if ((((oldop >= `ADDIU) && (oldop <= `LUI)) || ((oldop >= `LB) && (oldop <= `SW))) && (oldrt != 0)) begin
            AluSelAReg = (rs == oldrt) ? 2'b10 : 2'b01;
            AluSelBReg = 2'b11;
        end
        else begin
            AluSelAReg = 2'b01;
            AluSelBReg = 2'b11;
        end
    end
    else begin
        AluSelAReg = 2'b01;
        AluSelBReg = 2'b01;
    end
end

endmodule
