module ShiftReg (
        input        clk, si, sload,
        input  [9:0] d,
        output       so
);
        reg    [9:0] tmp;

	always @(posedge clk)
       	begin
           	if (sload)
              	tmp <= d;
           	else
              	tmp <= {tmp[8:0], si};
        end
           assign so = tmp[9];
        endmodule