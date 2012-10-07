//-----------------------------------------------------------------------------
// UC Berkeley CS150
// Lab 0, Fall 2012
// Module: Mux2_1.v
// Desc: OUT = A*(~SEL) + B*(SEL)
//-----------------------------------------------------------------------------
module Mux2_1(
    input A,
    input B,
    input SEL,
    output OUT
);
   // You may only use structural verilog! (i.e. wires and gates only)
    /********YOUR CODE HERE********/
	wire notsel, awire, bwire;
	nand(notsel,SEL,SEL);
	and(awire,A,notsel);
	and(bwire,B, SEL);
	or(OUT,awire,bwire);
   /********END CODE********/
   //assign OUT = 1'b0; //delete this line once you finish writing your logic
   
endmodule
