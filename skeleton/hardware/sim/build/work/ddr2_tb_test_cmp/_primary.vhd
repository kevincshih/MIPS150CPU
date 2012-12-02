library verilog;
use verilog.vl_types.all;
entity ddr2_tb_test_cmp is
    generic(
        DQ_WIDTH        : integer := 72;
        APPDATA_WIDTH   : integer := 144;
        ECC_ENABLE      : integer := 0
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        phy_init_done   : in     vl_logic;
        rd_data_valid   : in     vl_logic;
        app_cmp_data    : in     vl_logic_vector;
        rd_data_fifo_in : in     vl_logic_vector;
        error           : out    vl_logic;
        error_cmp       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DQ_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of APPDATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ECC_ENABLE : constant is 1;
end ddr2_tb_test_cmp;
