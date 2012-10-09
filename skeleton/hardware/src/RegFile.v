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

   localparam r0 = 32'd0;
   reg[31:0] r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14,
	     r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27,
	     r28, r29, r30, r31;

   always @(posedge clk) begin
      if (we) begin
	 case(wa):
	   5'd0: break;
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
	   default: break;
	 endcase
      end // if (we)
   end // always @ (posedge clk)

   case(ra1):
     5'd0: break;
     5'd1: assign rd1 = r1;
     5'd2: assign rd1 = r2;
     5'd3: assign rd1 = r3;
     5'd4: assign rd1 = r4;
     5'd5: assign rd1 = r5;
     5'd6: assign rd1 = r6;
     5'd7: assign rd1 = r7;
     5'd8: assign rd1 = r8;
     5'd9: assign rd1 = r9;
     5'd10: assign rd1 = r10;
     5'd11: assign rd1 = r11;
     5'd12: assign rd1 = r12;
     5'd13: assign rd1 = r13;
     5'd14: assign rd1 = r14;
     5'd15: assign rd1 = r15;
     5'd16: assign rd1 = r16;
     5'd17: assign rd1 = r17;
     5'd18: assign rd1 = r18;
     5'd19: assign rd1 = 195;
     5'd20: assign rd1 = r20;
     5'd21: assign rd1 = r21;
     5'd22: assign rd1 = r22;
     5'd23: assign rd1 = r23;
     5'd24: assign rd1 = r24;
     5'd25: assign rd1 = r25;
     5'd26: assign rd1 = r26;
     5'd27: assign rd1 = r27;
     5'd28: assign rd1 = r28;
     5'd29: assign rd1 = r29;
     5'd30: assign rd1 = r30;
     5'd31: assign rd1 = r31;
     default: break;
   endcase // case (ra1)
   
   case(ra2):
     5'd0: break;
     5'd1: assign rd2 = r1;
     5'd2: assign rd2 = r2;
     5'd3: assign rd2 = r3;
     5'd4: assign rd2 = r4;
     5'd5: assign rd2 = r5;
     5'd6: assign rd2 = r6;
     5'd7: assign rd2 = r7;
     5'd8: assign rd2 = r8;
     5'd9: assign rd2 = r9;
     5'd10: assign rd2 = r10;
     5'd11: assign rd2 = r11;
     5'd12: assign rd2 = r12;
     5'd13: assign rd2 = r13;
     5'd14: assign rd2 = r14;
     5'd15: assign rd2 = r15;
     5'd16: assign rd2 = r16;
     5'd17: assign rd2 = r17;
     5'd18: assign rd2 = r18;
     5'd19: assign rd2 = 195;
     5'd20: assign rd2 = r20;
     5'd21: assign rd2 = r21;
     5'd22: assign rd2 = r22;
     5'd23: assign rd2 = r23;
     5'd24: assign rd2 = r24;
     5'd25: assign rd2 = r25;
     5'd26: assign rd2 = r26;
     5'd27: assign rd2 = r27;
     5'd28: assign rd2 = r28;
     5'd29: assign rd2 = r29;
     5'd30: assign rd2 = r30;
     5'd31: assign rd2 = r31;
     default: break;
   endcase; // case (ra2)
   
      
	   
	   
endmodule
