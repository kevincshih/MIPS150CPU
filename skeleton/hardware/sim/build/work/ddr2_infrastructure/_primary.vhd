library verilog;
use verilog.vl_types.all;
entity ddr2_infrastructure is
    generic(
        RST_ACT_LOW     : integer := 1
    );
    port(
        clk0            : in     vl_logic;
        clk90           : in     vl_logic;
        clk200          : in     vl_logic;
        clkdiv0         : in     vl_logic;
        locked          : in     vl_logic;
        sys_rst_n       : in     vl_logic;
        idelay_ctrl_rdy : in     vl_logic;
        rst0            : out    vl_logic;
        rst90           : out    vl_logic;
        rst200          : out    vl_logic;
        rstdiv0         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RST_ACT_LOW : constant is 1;
end ddr2_infrastructure;
