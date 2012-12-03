
/*
 Command procesor module that handles the logic for parsing the graphics commands
 Three graphics commands for line engine:
 1. Write start point
 2. Write end-point
 3. Write line color
 If trigger bit set in command, command will also fire on start or end point
 Frame buffer fill will trigger automatically
 
 */
`include "gpcommands.vh"

module GraphicsProcessor(
    input clk,
    input rst,

    //line engine processor interface
    input LE_ready,
    output [31:0] LE_color,
    output [9:0] LE_point,
    output LE_color_valid,
    output LE_x0_valid,
    output LE_y0_valid,
    output LE_x1_valid,
    output LE_y1_valid,

    output LE_trigger,
    output [31:0] LE_frame,
		       
    //frame filler processor interface
    input FF_ready,
    output FF_valid,
    output [23:0] FF_color,
    output [31:0] FF_frame,
		       
    //DRAM request controller interface
    input rdf_valid,
    input af_full,
    input [127:0] rdf_dout,
    output rdf_rd_en,
    output af_wr_en,
    output [31:0] af_addr_din,
		       
    //processor interface
    input [31:0] GP_CODE,
    input [31:0] GP_FRAME,
    input GP_valid);
     
   
   //Your code goes here. GL HF.

   reg [31:0] Code_Reg, Frame_Reg;
   reg Valid_Reg;
   reg [3:0] CurrentState, NextState;
   
   localparam Idle = 4'h0,
			  Stop = 4'h1,
			  Fill = 4'h2,
			  LineColor = 4'h3,
			  LineStart = 4'h4,
			  LineEnd = 4'h5;
			  
   always@(posedge clk) begin
   if (rst) CurrentState <= Idle;
		else CurrentState <= NextState;
   end
   
   always@(*) begin
		NextState = CurrentState;
		case(CurrentState)
		Idle: begin
		if (GP_CODE[31:24] == `STOP) begin
		NextState = Idle;
		end
		else if (GP_CODE[31:24] == `FILL) begin
		NextState = Idle;
		end
		else if (GP_CODE[31:24] == `LINE) begin
		NextState = LineStart;
		end
		else NextState = Idle;
		end
		LineStart: begin
		NextState = LineEnd;
		end
		LineEnd: begin
		NextState = Idle;
		end
		default: NextState = Idle;
		endcase
   end
   

   //output assignment placeholders - delete these later
   
   assign LE_color = 0;
   assign LE_point = 0;
   
   assign LE_color_valid = 0;
   assign LE_x0_valid = 0;
   assign LE_y0_valid = 0;
   assign LE_x1_valid = 0;
   assign LE_y1_valid = 0;

   assign LE_trigger = 0;
   assign LE_frame = 0;
		       
   //frame filler processor interface
   assign FF_valid  = 0;
   assign FF_color = 0;
   assign FF_frame = 0;
		       
   //DRAM request controller interface
   assign rdf_rd_en = 0;
   
   assign af_wr_en = 0;
   assign af_addr_din = 0;
		       
endmodule
