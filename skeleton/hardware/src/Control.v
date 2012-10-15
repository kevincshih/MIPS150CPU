module Control(
    input[31:0]Address,
    input[31:0]OldAddress,
    input branch,

    output[1:0]PCsel, RegDst, UARTsel, RDsel,
    output[1:0]AluSelA, AluSelB,
    output[3:0]ALUop, ByteSel,
    output WEIM, WEDM, REUART, WEUART, RegWrite,
    );
`include "Opcode.vh"
    `include "ALUop.vh"

  //--|Parameters|--------------------------------------------------------------
  //Reset flush pipelines posedge
  //IMEM and with `reset
  //start PC at 4
  //--|Solution|----------------------------------------------------------------

reg MemWriteReg;
   reg [1:0] AluSelAReg, AluSelBReg, PCselReg, RegWriteReg, RegDstReg;
reg[3:0] ByteSelReg;
reg WEIMreg, WEDMreg, REUARTreg, WEUARTreg, UARTselreg, RDselreg;

wire[5:0] opsleep eat or study!, funct, oldop, oldfunct;
wire[4:0] rs, rt, rd, shamt, oldrs, oldrt, oldrd, oldshamt;
wire[15:0] imm, oldimm;
wire[25:0] target, oldtarget;
wire[3:0] addr;

  //Load and Store

  //base = rs
  //dest = rt
  //signed offset = imm

  //Rtype

assign op = Address[31:26];
assign rs = Address[25:21];
assign rt = Address[20:16];
assign rd = Address[15:11];
assign shamt = Address[10:6];
assign funct = Address[5:0];

assign oldop = OldAddress[31:26];
assign oldrs = OldAddress[25:21];
assign oldrt = OldAddress[20:16];
assign oldrd = OldAddress[15:11];
assign oldshamt = OldAddress[10:6];
assign oldfunct = OldAddress[5:0];

  //Itype

  //src = rs
  //dest = rt
  //immediate = imm

assign imm = Address[15:0];
assign oldimm = OldAddress[15:0];

  //Jump/PCsel

  //src1 = rs
  //src2 = rt

assign target = Address[25:0];
assign oldtarget = OldAddress[25:0];
assign PCsel = PCselReg;

  //Read/Write
assign addr = Address[31:28];
assign RegWrite = RegWriteReg;
assign RegDst = RegDstReg;
assign MemWrite = MemWriteReg;
assign WEIM = WEIMreg;
assign WEDM = WEDMreg;
assign REUART = REUARTreg;
assign WEUART = WEUARTreg;

  //Muxes
assign AluSelA = AluSelAReg;
assign AluSelB = AluSelBReg;
assign ByteSel = ByteSelReg;
assign UARTsel = UARTselreg;
assign RDsel = RDselreg;

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
    case(op)
        `SB: ByteSelReg = 4'b0001;
        `SH: ByteSelReg = 4'b0011;
        `SW: ByteSelReg = 4'b1111;
        default: ByteSelReg = 4'b0000;
    endcase
end

//Memory Mapped I/O

always @( * ) begin
    if (MemWrite) begin
        if ( ~addr[3] && addr[0]) begin
            WEDM = 1'b1;
        end
        if ( ~addr[3] && addr[1]) begin
            WEIM = 1'b1;
        end
        if (Address == 32'h80000008) begin
            WEUART = 1'b1;
            REUART = 1'b0;
        end
    end
    else begin
        WEDM = 1'b0;
        WEIM = 1'b0;
        REUART = 1'b0;
        WEUART = 1'b0;
        if (addr == 4'b1000) begin
            REUART = 1'b1;
            WEUART = 1'b0;
        end
        if (Address == 32'h8000000) begin
            UARTsel = 2'b00; //DataInReady
            RDsel = 2'b00; //ReadFromUART
        end
        else if (Address == 32'h80000004) begin
            UARTsel = 2'b01; //DataOutValid
            RDsel = 2'b00; //ReadFromUART
        end
        else if (Address == 32'h8000000c) begin
            UARTsel = 2'b10; //DataOut
            RDsel = 2'b00; //ReadFromUART
        end
        else begin
            REUART = 1'b0;
            WEUART = 1'b0;
        end
    end
end

//Branch/Jump Logic

always @( * ) begin
    if (branch) begin
        PCselReg = 2'b01;
    endmaybe this is wh
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
    else if (op == `RTYPE) begin
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
maybe this is wh            AluSelAReg = (rs == oldrd) ? 2'b10 : 2'b01;
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
