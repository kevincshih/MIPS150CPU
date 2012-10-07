//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Publications/Tutorials/Publications/EECS150/Labs/VerilogSynthesisAndFSMs/Files/Lab2Lock.v $
//	Version:	$Revision: 26904 $
//	Author:		Ilia Lebedev (ilial@berkeley.edu)
//				YOUR NAME GOES HERE
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Lab2Lock
//	Desc:			This module implements the functionality of a simple combination lock.
//					The lock uses 2 4-bit combination digits.
//					See the lab document for the suggested combination setting.
//	Params:		This module is not parameterized.
//	Inputs:		See Lab2 document
//	Outputs:	See Lab2 document
//
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//				YOUR NAME GOES HERE
//	Version:	$Revision: 26904 $
//------------------------------------------------------------------------------
module	Lab2Lock(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Inputs
			//------------------------------------------------------------------
			Enter,
			Digit,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Outputs
			//------------------------------------------------------------------
			State,
			Open,
			Fail
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	localparam	DIGIT_1	=	4'h2,
				DIGIT_2	=	4'h3;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock;	// System clock
	input					Reset;	// System reset
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Inputs
	//--------------------------------------------------------------------------
	input					Enter;
	input		[3:0]		Digit;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Outputs
	//--------------------------------------------------------------------------
	output	[2:0]		State;
	output				Open;
	output				Fail;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	State Encoding
	//--------------------------------------------------------------------------
	
	localparam LOCKED = 3'd0,
		    OK_1 = 3'd1,
		    OK_2 = 3'd2,
		    BAD_1 = 3'd3,
		    BAD_2 = 3'd4,
		    STATE_5 = 3'd5,
		    STATE_6 = 3'd6,
		    STATE_7 = 3'd7;
	
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wire Declarations
	//--------------------------------------------------------------------------
	
	wire enter;
	wire [3:0] digit;
	
	reg[2:0] CurrentState;
	reg[2:0] NextState;

	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Logic
	//--------------------------------------------------------------------------
	assign enter = Enter;
	assign digit = Digit;
	
	assign State = CurrentState;
	assign Open = (CurrentState == OK_2);
	assign Fail = (CurrentState == BAD_2);	
	
	always@(posedge Clock) begin
		if (Reset) begin
			$display ("Lock Reset");
			CurrentState <= LOCKED;
			end
		else CurrentState <= NextState;
	end

	always@(*) begin
		$display ("Entering Digit");
		NextState = CurrentState;
		if (enter == 1'b1) begin
		case(CurrentState)
			LOCKED: begin
				if (digit == DIGIT_1) NextState = OK_1;
				else NextState = BAD_1;
			end
			OK_1: begin
				if (digit == DIGIT_2) NextState = OK_2;
				else NextState = BAD_2;
			end
			OK_2: begin
				NextState = OK_2;
			end
			BAD_1: begin
				NextState = BAD_2;
			end
			BAD_2: begin
				NextState = BAD_2;
			end
			STATE_5: begin
				NextState = LOCKED;
			end
			STATE_6: begin
				NextState = LOCKED;
			end
			STATE_7: begin
				NextState = LOCKED;
			end
			default: begin
				NextState = LOCKED;
			end
		endcase
		end
	end

	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
