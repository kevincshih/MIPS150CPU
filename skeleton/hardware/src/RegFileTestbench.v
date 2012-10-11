// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

module RegFileTestbench();

  parameter Halfcycle = 5; //half period is 5ns

  localparam Cycle = 2*Halfcycle;

  reg Clock;

  // Clock Sinal generation:
  initial Clock = 0; 
  always #(Halfcycle) Clock = ~Clock;

  // Register and wires to test the RegFile
  reg [4:0] ra1;
  reg [4:0] ra2;
  reg [4:0] wa;
  reg we;
  reg [31:0] wd;
   reg [31:0] REFOut;
   
  wire [31:0] rd1;
  wire [31:0] rd2;

  RegFile DUT(.clk(Clock),
              .we(we),
              .ra1(ra1),
              .ra2(ra2),
              .wa(wa),
              .wd(wd),
              .rd1(rd1),
              .rd2(rd2));
  

   integer    i;
   localparam loops = 31;
   
  // Testing logic:
  initial begin
    #1;
    // Verify that writing to reg 0 is a nop
     we = 1;
     wd = 32'hFFFFFFFF;
     wa = 5'b00000;
     ra1 = 5'b00000;
     ra2 = 5'b00000;
     #1;
     if (rd1 !== 32'd0) begin
	$display("Writing to reg 0 is not a nop");
	$display("rd1 is: %b", rd1);
     end
     #1;
     
    // Verify that data written to any other register is returned the same
    // cycle
     we = 1;
     wd = 32'hDEADBEEF;
     for (i=1; i < loops; i = i + 1)
       begin
	  wa = i;
	  #1;
	  ra1 = i;
	  if (rd1 != 32'hDEADBEEF)
	    begin
	       $display("Writing to register %b resulted in %b", i, rd1);
	    end
       end
    
    // Verify that the we pin prevents data from being written
     #1;
     we = 0;
     wa = 5'd1;
     wd = 32'hFEEDFEED;
     ra1 = 5'd1;
     if (rd1 !== 32'hDEADBEEF)
       $display("Write Enable singal did not disable writing: r1 = %b", rd1);
     
    // Verify the reads are asynchronous

     ra1 = 5'd0;
     if (rd1 !== 32'd0)
       $display("we have a big problem)");
     ra1 = 5'd1;
     if (rd1 !== 32'hDEADBEEF)
       $display("read was not asynchronous");
     
   
    $display("All tests passed!");
    $finish();
  end
endmodule
