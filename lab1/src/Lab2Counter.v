//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Publications/Tutorials/Publications/EECS150/Labs/VerilogSynthesisAndFSMs/Files/Lab2Counter.v $
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
//	Module:		Lab2Counter
//	Desc:			This module parses raw input from a rotary encoder, produces
//					increment and decrement pulses every click.
//
//					Implement this module using behavioral verilog only.
//					A good solution will use on the order of 8 lines of behavioral Verilog.
//
//					Note: the output pulses from RotaryEncoder will arrive too frequently.
//							RotaryEncoder will produce 4 pulses per click of the wheel.
//							Yoi will mask this by maintaining 6 bits to represent Count.
//							You will expose the top 4 bits.
//	Params:		This module is not parameterized.
//	Inputs:			Increment:		Raw 'A' input from a rotary encoder.
//					Decrement:		Raw 'B' input from a rotary encoder.
//	Outputs:		Count:			A 4-bit value used to enter a combination into Lab2Lock.
//									Note: Remember to only increment the count every 4th pulse.
//
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//				YOUR NAME GOES HERE
//	Version:	$Revision: 26904 $
//------------------------------------------------------------------------------
module	Lab2Counter(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Inputs
			//------------------------------------------------------------------
			Increment,
			Decrement,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Outputs
			//------------------------------------------------------------------
			Count
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	// <none>
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
	input					Increment;
	input					Decrement;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Outputs
	//--------------------------------------------------------------------------
	output	[3:0]		Count;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wire Declarations
	//--------------------------------------------------------------------------
	wire i, d;
	reg [3:0] c;	
	reg[5:0] s;
	reg[1:0] r;

	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Logic
	//--------------------------------------------------------------------------
	
	assign i = Increment;
	assign d = Decrement;
	assign Count = c;
		
	always @(posedge Clock) begin
		if (Reset) begin
			$display ("Counter Reset");
			c <= 4'b0000;
			r <= 2'b00;
		end
		else begin
			c <= s / 4;
			r <= s % 4;
		end
	end
	
	always @(i or d) begin
		s = 4 * c + r;
		if (i==1) s = s + 1;
		else if (d==1) s = s - 1;
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
