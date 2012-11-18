module IFControl(
    input[31:0]PC,
    input reset, stall,
    output REIC, REBIOS, IFSel
    );
    
	reg REICreg, BIOSreg, IFSelreg;
	
	wire [3:0] pctop;
	
	assign pctop = PC[31:28];
	assign REIC = REICreg;
	assign REBIOS = BIOSreg;
	assign IFSel = IFSelreg;
	
	always @(*) begin
	if (pctop == 4'b0001) begin
		REICreg = 1'b1;
		BIOSreg = 1'b0;
		IFSelreg = 1'b0;
	end
	else if (pctop == 4'b0100) begin
		REICreg = 1'b0;
		BIOSreg = 1'b1;
		IFSelreg = 1'b1;
	end
	else begin
		REICreg = 1'b0;
		BIOSreg = 1'b0;
		IFSelreg = 1'b0;
	end
	end
	
endmodule
