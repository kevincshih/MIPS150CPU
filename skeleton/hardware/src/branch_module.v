module Branch_module(input [31:0] ALUSrcA, ALUSrcB,
		     input [5:0] opcode,
		     input [4:0] rt,
		     output take_branch);

   reg [5:0] 		    branch_reg;

   always @(*) begin
      case(opcode)
	6'b00100: branch_reg = (ALUSrcA == ALUSrcB);
	6'b00101: branch_reg = ~(ALUSrcA == ALUSrcB);
	6'b00110: branch_reg = $signed(ALUSrcA) =< 0;
	6'b00111: branch_reg = $signed(ALUSrcA) > 0;
	6'b00001: branch_reg = (rt==0'b00000)? ($signed(ALUSrcA)<0): ($signed(ALUSrcA) >=0);
	default: branch_reg = 0;
      endcase // case (opcode)
   end

   assign take_branch = branch_reg;

endmodule // Branch_module

   