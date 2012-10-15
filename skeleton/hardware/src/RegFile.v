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

module RegFile(input clk, we,
               input  [4:0] ra1, ra2, wa,
               input  [31:0] wd,
               output [31:0] rd1, rd2);

   (* ram_style = "distributed" *) reg [31:0] the_registers[0:31];

   always @(*) the_registers[0] = 32'd0;
      
   always @(posedge clk) begin
      if (we) begin
	 case(wa)
	   5'd0: ;
	   5'd1: the_registers[1] <= wd;
	   5'd2: the_registers[2] <= wd;
	   5'd3: the_registers[3] <= wd;
	   5'd4: the_registers[4] <= wd;
	   5'd5: the_registers[5] <= wd;
	   5'd6: the_registers[6] <= wd;
	   5'd7: the_registers[7] <= wd;
           5'd8: the_registers[8] <= wd;
           5'd9: the_registers[9] <= wd;
           5'd10: the_registers[10] <= wd;
           5'd11: the_registers[11] <= wd;
           5'd12: the_registers[12] <= wd;
           5'd13: the_registers[13] <= wd;
           5'd14: the_registers[14] <= wd;
           5'd15: the_registers[15] <= wd;
           5'd16: the_registers[16] <= wd;
           5'd17: the_registers[17] <= wd;
           5'd18: the_registers[18] <= wd;
           5'd19: the_registers[19] <= wd;
           5'd20: the_registers[20] <= wd;
           5'd21: the_registers[21] <= wd;
	   5'd22: the_registers[22] <= wd;
	   5'd23: the_registers[23] <= wd;
	   5'd24: the_registers[24] <= wd;
	   5'd25: the_registers[25] <= wd;
	   5'd26: the_registers[26] <= wd;
	   5'd27: the_registers[27] <= wd;
	   5'd28: the_registers[28] <= wd;
	   5'd29: the_registers[29] <= wd;
	   5'd30: the_registers[30] <= wd;
	   5'd31: the_registers[31] <= wd;
	 endcase
      end // if (we)
   end // always @ (posedge clk)

  /* always @(*) begin
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
	5'd19: rd_1 = r19;
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
	5'd19: rd_2 = r19;
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
      endcase // case (ra2)
   end // always @ (*)
*/
   assign rd1 = the_registers[ra1];
   assign rd2 = the_registers[ra2];
   
   
      
	   
	   
endmodule
