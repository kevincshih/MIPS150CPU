`timescale 1ns / 1ps
module sartest();

    
    // Register and wires to test the ALU
    reg clk, rst;
    //reg [9:0] Vminus;
    reg Cout;
    wire [9:0] SARout;
    wire Done;
    
    //This is where the modules being tested are instantiated. 
    sar dut(.Clock(clk),
        .Reset(rst),
        .TB(Cout),
        .D(SARout),
        .EOC(Done));

        ///////////////////////////////
        // Hard coded tests go here
        ///////////////////////////////
    initial clk = 0;
    always #10 clk = ~clk; // Clock generator
    initial rst = 1;
    
    
    always @(posedge clk)
    begin
        rst = 0;
        Cout = (SARout > 777);
        #10000 $stop;
    end
    
    initial
      $monitor($stime,, rst,, clk,,, SARout); 
  endmodule