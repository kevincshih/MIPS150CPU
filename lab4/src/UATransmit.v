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

  localparam STATE_0 = 2'b00,
	     STATE_1 = 2'b01,
	     STATE_2 = 2'b10;
  
  wire [9:0] data;
  reg Start, Transmitting, Ready;
  reg [1:0] CurrentState, NextState;
  reg     [3:0]                   BitCounter;
  reg     [ClockCounterWidth-1:0] ClockCounter;
  reg load;
  
  ShiftReg shift(.clk(SymbolEdge),
		 .si(1'b0),
		 .sload(load),
		 .d(data),
		 .so(SOut));
  
  assign data = {1'b0, DataIn, 1'b1};
  assign  SymbolEdge   = (ClockCounter == SymbolEdgeTime - 1);
  assign DataInReady = Ready;

  always @ (posedge Clock) begin
    ClockCounter <= (!DataInValid || Reset || SymbolEdge)
    ? 0 : ClockCounter + 1;
  end

  always @ (posedge Clock) begin
    if (Reset) begin
      BitCounter <= 0;
    end else if (Start) begin
      BitCounter <= 10;
    end else if (SymbolEdge) begin
      BitCounter <= BitCounter - 1;
    end
  end

  always @(posedge Clock) begin
	if(Reset) CurrentState <= STATE_0;
	else CurrentState <= NextState;
	end

  always @(*) begin
  	NextState = CurrentState;
  case(NextState)
  	STATE_0:begin
	Start = 1'b0;
	Transmitting = 1'b0;
	load = 1'b0;
	Ready = 1'b0;
	NextState = DataInValid ? STATE_0 : STATE_1;
	end
	STATE_1:begin
	Start = 1'b1;
	Transmitting = 1'b0;		
	load = 1'b1;
	Ready = 1'b0;
	NextState = STATE_2;
	end
	STATE_2:begin
	Start = 1'b0;
	Transmitting = 1'b1;
	load = 1'b0;	
	Ready = 1'b1;
	NextState = (BitCounter == 0) ? STATE_2 : STATE_0;
	end
	default:begin
	NextState = STATE_0;	
	end
	endcase
	end
endmodule
