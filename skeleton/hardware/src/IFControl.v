module IFControl(
    input[31:0]PC,
    input reset, stall, stall_reg,
    output REIC, REBIOS, REISR,
	output [1:0] IFSel
    );
    
	reg REICreg, BIOSreg, REISRreg;
	reg [1:0] IFSelreg;
	
	wire [3:0] pctop;
	
	wire mmult_debug;
	assign mmult_debug = 1'b0;
	assign REISR = (reset) ? 0 : REISRreg;
	assign pctop = PC[31:28];
	assign REIC = (reset || mmult_debug) ? 0 : REICreg;
   assign REBIOS = (reset) ? 0 : BIOSreg;
   assign IFSel = (reset || mmult_debug) ? 0 : IFSelreg;
   
	always @(*) begin
	if (pctop == 4'b0001) begin
		REICreg = 1'b1;
		BIOSreg = 1'b0;
		REISRreg = 1'b0;
		IFSelreg = 2'b00;
	end
	else if (pctop == 4'b0100) begin
	   REICreg = 1'b0;
	   REISRreg = 1'b0;
	   if (stall)
	     BIOSreg = 1'b0;
	   else
	     BIOSreg = 1'b1;
	   IFSelreg = 2'b01;
	end
	else if (pctop == 4'b1100) begin
		REICreg = 1'b0;
		BIOSreg = 1'b0;
		REISRreg = 1'b1;
		IFSelreg = 2'b10;
	end
	else begin
		REICreg = 1'b0;
		BIOSreg = 1'b0;
		REISRreg = 1'b0;
		IFSelreg = 2'b00;
	end
	end
	
endmodule
