library verilog;
use verilog.vl_types.all;
entity ml505top is
    port(
        FPGA_SERIAL_RX  : in     vl_logic;
        FPGA_SERIAL_TX  : out    vl_logic;
        GPIO_SW_C       : in     vl_logic;
        GPIO_COMPLED_S  : out    vl_logic;
        GPIO_DIP_0      : in     vl_logic;
        USER_CLK        : in     vl_logic
    );
end ml505top;
