//-----------------------------------------------------------------------------
//  Module: RegFile
//  Desc: An array of 32 32-bit registers
//  Inputs Interface:
//    clk: Clock signal
//    ra1: first read address (asynchronous)
//    ra2: second read address (asynchronous)
//    wa: write address (synchronous)
//    we: write enable (synchronous)
//    wd: data to write (synchronous)
//  Output Interface:
//    rd1: data stored at address ra1
//    rd2: data stored at address ra2
//  Author: Andy Hu & Kevin Shih
//-----------------------------------------------------------------------------

module RegFile(input clk,
               input we,
               input  [4:0] ra1, ra2, wa,
               input  [31:0] wd,
               output [31:0] rd1, rd2);

   (* ram_style = "distributed" *) reg[31:0] r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14,
	     r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27,
	     r28, r29, r30, r31;

   (* ram_style = "distributed" *) reg [31:0] r0 = 32'd0;
   (* ram_style = "distributed" *) reg [31:0] rd_1, rd_2;
   
   always @(posedge clk) begin
      if (we) begin
	 case(wa)
	   5'd0: r0 <= 32'd0;
	   5'd1: r1 <= wd;
	   5'd2: r2 <= wd;
	   5'd3: r3 <= wd;
	   5'd4: r4 <= wd;
	   5'd5: r5 <= wd;
	   5'd6: r6 <= wd;
	   5'd7: r7 <= wd;
           5'd8: r8 <= wd;
           5'd9: r9 <= wd;
           5'd10: r10 <= wd;
           5'd11: r11 <= wd;
           5'd12: r12 <= wd;
           5'd13: r13 <= wd;
           5'd14: r14 <= wd;
           5'd15: r15 <= wd;
           5'd16: r16 <= wd;
           5'd17: r17 <= wd;
           5'd18: r18 <= wd;
           5'd19: r19 <= wd;
           5'd20: r20 <= wd;
           5'd21: r21 <= wd;
	   5'd22: r22 <= wd;
	   5'd23: r23 <= wd;
	   5'd24: r24 <= wd;
	   5'd25: r25 <= wd;
	   5'd26: r26 <= wd;
	   5'd27: r27 <= wd;
	   5'd28: r28 <= wd;
	   5'd29: r29 <= wd;
	   5'd30: r30 <= wd;
	   5'd31: r31 <= wd;
	   default: r0 <= 32'd0;
	 endcase
      end // if (we)
   end // always @ (posedge clk)

   always @(*) begin
      
      case(ra1)
	5'd0: rd_1 = r0;
	5'd1: rd_1 = r1;
	5'd2: rd_1 = r2;
	5'd3: rd_1 = r3;
	5'd4: rd_1 = r4;
	5'd5: rd_1 = r5;
	5'd6: rd_1 = r6;
	5'd7: rd_1 = r7;
	5'd8: rd_1 = r8;
	5'd9: rd_1 = r9;
	5'd10: rd_1 = r10;
	5'd11: rd_1 = r11;
	5'd12: rd_1 = r12;
	5'd13: rd_1 = r13;
	5'd14: rd_1 = r14;
	5'd15: rd_1 = r15;
	5'd16: rd_1 = r16;
	5'd17: rd_1 = r17;
	5'd18: rd_1 = r18;
	5'd19: rd_1 = 195;
	5'd20: rd_1 = r20;
	5'd21: rd_1 = r21;
	5'd22: rd_1 = r22;
	5'd23: rd_1 = r23;
	5'd24: rd_1 = r24;
	5'd25: rd_1 = r25;
	5'd26: rd_1 = r26;
	5'd27: rd_1 = r27;
	5'd28: rd_1 = r28;
	5'd29: rd_1 = r29;
	5'd30: rd_1 = r30;
	5'd31: rd_1 = r31;
	default: rd_1 = r0;
      endcase // case (ra1)
      
      case(ra2)
	5'd0: rd_2 = r0;
	5'd1: rd_2 = r1;
	5'd2: rd_2 = r2;
	5'd3: rd_2 = r3;
	5'd4: rd_2 = r4;
	5'd5: rd_2 = r5;
	5'd6: rd_2 = r6;
	5'd7: rd_2 = r7;
	5'd8: rd_2 = r8;
	5'd9: rd_2 = r9;
	5'd10: rd_2 = r10;
	5'd11: rd_2 = r11;
	5'd12: rd_2 = r12;
	5'd13: rd_2 = r13;
	5'd14: rd_2 = r14;
	5'd15: rd_2 = r15;
	5'd16: rd_2 = r16;
	5'd17: rd_2 = r17;
	5'd18: rd_2 = r18;
	5'd19: rd_2 = 195;
	5'd20: rd_2 = r20;
	5'd21: rd_2 = r21;
	5'd22: rd_2 = r22;
	5'd23: rd_2 = r23;
	5'd24: rd_2 = r24;
	5'd25: rd_2 = r25;
	5'd26: rd_2 = r26;
	5'd27: rd_2 = r27;
	5'd28: rd_2 = r28;
	5'd29: rd_2 = r29;
	5'd30: rd_2 = r30;
	5'd31: rd_2 = r31;
	default: rd_2 = r0;
      endcase // case (ra2)
   end // always @ (*)

   assign rd1 = rd_1;
   assign rd2 = rd_2;
   
      
	   
	   
endmodule
