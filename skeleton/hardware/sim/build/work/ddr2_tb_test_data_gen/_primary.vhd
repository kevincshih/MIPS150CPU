library verilog;
use verilog.vl_types.all;
entity ddr2_tb_test_data_gen is
    generic(
        DM_WIDTH        : integer := 9;
        DQ_WIDTH        : integer := 72;
        APPDATA_WIDTH   : integer := 144;
        ECC_ENABLE      : integer := 0
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        wr_data_en      : in     vl_logic;
        rd_data_valid   : in     vl_logic;
        app_wdf_wren    : out    vl_logic;
        app_wdf_data    : out    vl_logic_vector;
        app_wdf_mask_data: out    vl_logic_vector;
        app_cmp_data    : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DM_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DQ_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of APPDATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ECC_ENABLE : constant is 1;
end ddr2_tb_test_data_gen;
