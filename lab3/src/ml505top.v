// UC Berkeley CS150
// Lab 4, Spring 2012

module ml505top (
    input  [5:0] GPIO_DIP,
    input        GPIO_COMPSW_C,
    input        CLK_33MHZ_FPGA,
    output [7:0] GPIO_LED,
    output       GPIO_COMPLED_C
);

    // Clock and reset:
    wire clk;
	BUFG clock_buf(.I(CLK_33MHZ_FPGA), .O(clk));

    // Use the center compass switch to reset/trigger chipscope:
    wire rst;
    Debouncer rst_parse(
        .clk(clk),
        .in(GPIO_COMPSW_C),
        .out(rst));

    // Datapath control signals:
    wire        addr_sel;
    wire        wr_en;
    wire [3:0]  alu_op;

    // Datapath output signals:
    wire        ram_zero;
    wire [31:0] accum_result;
    

    Lab3Datapath datapath(
        .clk(clk),
        .rst(rst),
        .addr_sel(addr_sel),
        .wr_en(wr_en),
        .alu_op(alu_op),
        .ram_zero(ram_zero),
        .accum_result(accum_result)
    );

    Lab3Control controller(
        .clk(clk),
        .rst(rst),
        .ram_zero(ram_zero),
        .funct(GPIO_DIP),
        .alu_op(alu_op),
        .addr_sel(addr_sel),
        .wr_en(wr_en),
        .done(GPIO_COMPLED_C)
    );

    // LED output assignments:
    assign GPIO_LED = accum_result[7:0]; 

endmodule
