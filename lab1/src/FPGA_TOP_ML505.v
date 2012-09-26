//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Publications/Tutorials/Publications/EECS150/Labs/StructuralVerilog/Framework/FPGA_TOP_ML505.v $
//	Version:		$Revision: 26904 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//				Chris Fletcher (http://cwfletcher.net)
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
//	Module:	FPGA_TOP_ML505
//	Desc:	Top level interface from a Xilinx XC5VLX50T or XC5VLX110T FPGA
//			to the ML505-50 or ML505-110 Board respectively.
//			This particular FPGA_TOP is retrofitted for the Structural Verilog
//			lab, used for CS150 (circa Spring 2009).
//	Author:	<a href="http://www.gdgib.com/">Greg Gibeling</a>
//			<a href="http://cwfletcher.net">Chris Fletcher</a>
//	Version:	$Revision: 26904 $
//------------------------------------------------------------------------------
module FPGA_TOP_ML505(
			//------------------------------------------------------------------
			//	Compass Switches & LEDs
			//------------------------------------------------------------------
			GPIO_COMPLED,	// OUT(5b), W4, S3, N2, E1, C0
			GPIO_COMPSW,	// IN(5b), W4, S3, N2, E1, C0
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	 General IO (Dipswitch, LED, Rotary Encoder & Bus Error LEDs)
			//------------------------------------------------------------------
			GPIO_DIP,
			GPIO_LED,
			FPGA_ROTARY_INCA,
			FPGA_ROTARY_INCB,
			FPGA_ROTARY_PUSH,
			//------------------------------------------------------------------

			//------------------------------------------------------------------
			//	FPGA Configuration & Management
			//------------------------------------------------------------------
			FPGA_CPU_RESET_B,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Clocks
			//------------------------------------------------------------------
			CLK_33MHZ_FPGA,
			//------------------------------------------------------------------
		);

	//--------------------------------------------------------------------------
	//	Compass Switches & LEDs (W4, S3, N2, E1, C0)
	//--------------------------------------------------------------------------
    output  [4:0]           GPIO_COMPLED;
	input	[4:0]			GPIO_COMPSW;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	 General IO (Dipswitch, LED, Rotary Encoder & Bus Error LEDs)
	//--------------------------------------------------------------------------
	input	[7:0]			GPIO_DIP;
	output	[7:0]			GPIO_LED;
    input                   FPGA_ROTARY_INCA;
    input                   FPGA_ROTARY_INCB;
    input                   FPGA_ROTARY_PUSH;
	//--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //	FPGA Configuration & Management
    //--------------------------------------------------------------------------
    input                   FPGA_CPU_RESET_B;
    //--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clocks
	//--------------------------------------------------------------------------
	input					CLK_33MHZ_FPGA;
	//--------------------------------------------------------------------------

	wire						Clock;
	BUFG        clock_buf(.I(CLK_33MHZ_FPGA),	.O(Clock));
	
	wire						LockReset, SystemReset;
	wire						Up,	Down;
	wire	[2:0]				State;
	wire	[2:0]				DebugState;
	
	wire						Enter;
	wire						Open;
	wire						Fail;
	wire	[3:0]				Digit;
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter					ClockFreq =				33000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parse input from buttons
	//--------------------------------------------------------------------------
	ButtonParse	#(
			.Width(				1),
			.DebWidth(			`log2(ClockFreq / 100)),
			.EdgeOutWidth(		1)
		) systemResetParse	(	
			.Clock(				Clock),
			.Reset(				1'b0),
			.Enable(			1'b1),
			.In(				FPGA_CPU_RESET_B),
			.Out(				SystemReset));
			
	ButtonParse	#(
			.Width(				1),
			.DebWidth(			`log2(ClockFreq / 100)),
			.EdgeOutWidth(		1)
		) lockEnterParse	(	
			.Clock(				Clock),
			.Reset(				1'b0),
			.Enable(			1'b1),
			.In(				FPGA_ROTARY_PUSH),
			.Out(				Enter));

	ButtonParse	#(
			.Width(				1),
			.DebWidth(			`log2(ClockFreq / 100)),
			.EdgeOutWidth(		1)
		) lockResetParse	(	
			.Clock(				Clock),
			.Reset(				1'b0),
			.Enable(			1'b1),
			.In(				GPIO_COMPSW[0]),
			.Out(				LockReset));
		
	
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Lab 3
	//--------------------------------------------------------------------------
	RotaryEncoder	rotaryEncoder(
			.Clock(				Clock),
			.A(					FPGA_ROTARY_INCA),
			.B(					FPGA_ROTARY_INCB),
			.Up(				Up),
			.Down(				Down));
	
	Lab2Counter	lab2Counter(
			.Clock(				Clock),
			.Reset(				SystemReset),
			.Increment(			Up),
			.Decrement(			Down),
			.Count(				Digit)
	);
	
	Lab2Lock	lab2Lock(
			.Clock(				Clock),
			.Reset(				LockReset | SystemReset),
			.Enter(				Enter),
			.Digit(				Digit),
			.State(				State),
			.Open(				Open),
			.Fail(				Fail));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Logic
	//--------------------------------------------------------------------------

	assign	GPIO_LED[3:0]	=	Digit;	// Combination digit is displayed on the left 4 bits (in reverse order).
    assign  GPIO_LED[4:4]   =   1'b0;           // No undriven outputs
	assign	GPIO_LED[7:5]	=	State;
	// The LEDs on the compass buttons light up when the lock is open, and only the center does when you fail.
	assign	GPIO_COMPLED	=	{{4{Open}}, (Open|Fail)};
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
