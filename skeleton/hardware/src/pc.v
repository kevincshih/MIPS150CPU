module PC(input[31:0]  PC_Branch, PC_4, PC_JAL, JR,
	  input [1:0] PC_Sel,
	  input EN, CLK, RST,
	  output[31:0] PC_IF//, PC_IMEM
	  );

   reg [31:0] 	the_pc, the_instant_pc;

   always @(posedge CLK) begin
      if (EN) begin
	 case(PC_Sel)
	   2'b00: the_pc <= PC_4;
	   2'b01: the_pc <= PC_Branch;
	   2'b10: the_pc <= JR;
	   2'b11: the_pc <= PC_JAL;
	   default: the_pc <= PC_4;
	 endcase // case (PC_Sel)
      end

      if (RST) the_pc <= 32'h40000000;
	       
   end // always @ (posedge CLK)
   
   assign PC_IF = the_pc;

endmodule // PC
