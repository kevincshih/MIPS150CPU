module UATransmit(
  input   Clock,
  input   Reset,

  input   [7:0] DataIn,
  input         DataInValid,
  output        DataInReady,

  output        SOut
);
  // for log2 function
  `include "util.vh"

  //--|Parameters|--------------------------------------------------------------

  parameter   ClockFreq         =   100_000_000;
  parameter   BaudRate          =   115_200;

  // See diagram in the lab guide
  localparam  SymbolEdgeTime    =   ClockFreq / BaudRate;
  localparam  ClockCounterWidth =   log2(SymbolEdgeTime);

  //--|Solution|----------------------------------------------------------------
   reg [9:0] 	TXShift;
   reg 		HandShook;
   reg [3:0] 	BitCounter;
   reg [ClockCounterWidth-1:0] ClockCounter;
   

   wire 	TXRunning;
   wire 	SymbolEdge;
   wire 	Start;
   
   
// Setting Handshake and Capturing Data
   always @(posedge Clock) begin
      if (DataInValid && !TXRunning) begin
	 HandShook <= 1;
	 TXShift <= {1'b1, DataIn, 1'b0};
      end

      if (Reset) begin
	 HandShook <= 0;
	 TXShift <= 10'b0;
      end

      if (Start) HandShook <= 0;
      

      if (SymbolEdge && TXRunning)
	TXShift <= TXShift >> 1;
      
   end // always @ (posedge Clock)

// Setting Counters
   always @(posedge Clock) begin
      ClockCounter <= (Reset || Start || SymbolEdge)? 0 : ClockCounter + 1;
   end

   always @(posedge Clock) begin
      if (Start) begin
	 BitCounter <= 10;
      end else if (Reset) begin
	 BitCounter <= 0;
      end else if (TXRunning && SymbolEdge) begin
	 BitCounter <= BitCounter - 1;
      end
   end   
   
//----------|State/Signal Assignment|----------
   assign TXRunning = (BitCounter != 4'd0);
   assign Start = !TXRunning && HandShook;
   assign SymbolEdge = (ClockCounter == SymbolEdgeTime - 1);
   
   
   
//-----|Output Assignment|----------------------
   assign DataInReady = !TXRunning;
   assign SOut = (TXRunning)? TXShift[0]: 1'b1;
      

   
endmodule
