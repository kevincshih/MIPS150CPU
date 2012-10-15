module PC(input[31:0]  PC_Branch, PC_4, PC_JAL, JR,
	  input [1:0] PC_Sel,
	  input EN, CLK, RST, flush,
	  output[31:0] PC_IF
	  );

   reg [31:0] 	the_pc;
   reg [1:0] 	flush_count = 2'd3;
   reg 		flushing;
   
   always @(posedge CLK) begin
      if (EN && ~flushing) begin
	 case(PC_Sel)
	   2'b00: the_pc <= PC_4;
	   2'b01: the_pc <= PC_Branch;
	   2'b10: the_pc <= JR;
	   2'b11: the_pc <= PC_JAL;
	   default: the_pc <= PC_4;
	 endcase // case (PC_Sel)
      end

      if (RST) the_pc <= 32'd0;
	 
      if (flushing) flush_count <= flush_count - 1;
      else flush_count <= 2'd3;
      
   end

   always @(*) begin
      if (flush) flushing = 1;
      if (flush_count == 0) flushing = 0;

      if (RST) flushing = 0;
      
   end      

   assign PC_IF = the_pc;

endmodule // PC

