library verilog;
use verilog.vl_types.all;
entity FPGA_TOP_ML505 is
    generic(
        ClockFreq       : integer := 100000000;
        UARTBaudRate    : integer := 115200
    );
    port(
        GPIO_SW_C       : in     vl_logic;
        USER_CLK        : in     vl_logic;
        FPGA_SERIAL_RX  : in     vl_logic;
        FPGA_SERIAL_TX  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ClockFreq : constant is 1;
    attribute mti_svvh_generic_type of UARTBaudRate : constant is 1;
end FPGA_TOP_ML505;
