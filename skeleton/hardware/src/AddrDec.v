module AddrDec(
  input MemWrite,
  input [31:0] Address,
  output WEIM, WEDM, REUART, WEUART, UARTsel, RDsel);

  //--|Parameters|--------------------------------------------------------------

  //--|Solution|----------------------------------------------------------------

  wire [3:0] addr;
  assign addr = Address[31:28];

  always @ (*) begin
	if(MemWrite) begin
		if (~addr[3] && addr[0]) begin
	  	WEDM = 1'b1;
		end
		if (~addr[3] && addr[1]) begin
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
	else if (Address ==32'h8000000c) begin
	  	UARTsel = 2'b10; //DataOut
	  	RDsel = 2'b00; //ReadFromUART
	end
	else begin
	  	REUART = 1'b0;
	  	WEUART = 1'b0;
	end
	end
  end  
endmodule
