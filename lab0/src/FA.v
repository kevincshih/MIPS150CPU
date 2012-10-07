//-----------------------------------------------------------------------------
// UC Berkeley CS150
// Lab 0, Fall 2012
// Module: FA.v
// Desc: 1-bit Full Adder
//       You may only use structural verilog in this module.       
//-----------------------------------------------------------------------------
module FA(
    input A, B, Cin,
    output Sum, Cout
);
   // Structural verilog only!
   /********YOUR CODE HERE********/
wire axorb, abc, aandb;   

xor(axorb, A, B);
xor(Sum, axorb, Cin);
and(abc, axorb, Cin);
and(aandb, A, B);
or(Cout, abc, aandb);

   /********END CODE********/
endmodule

