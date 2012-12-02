library verilog;
use verilog.vl_types.all;
entity ddr2_tb_top is
    generic(
        BANK_WIDTH      : integer := 2;
        COL_WIDTH       : integer := 10;
        DM_WIDTH        : integer := 9;
        DQ_WIDTH        : integer := 72;
        ROW_WIDTH       : integer := 14;
        APPDATA_WIDTH   : integer := 144;
        ECC_ENABLE      : integer := 0;
        BURST_LEN       : integer := 4
    );
    port(
        clk0            : in     vl_logic;
        rst0            : in     vl_logic;
        app_af_afull    : in     vl_logic;
        app_wdf_afull   : in     vl_logic;
        rd_data_valid   : in     vl_logic;
        rd_data_fifo_out: in     vl_logic_vector;
        phy_init_done   : in     vl_logic;
        app_af_wren     : out    vl_logic;
        app_af_cmd      : out    vl_logic_vector(2 downto 0);
        app_af_addr     : out    vl_logic_vector(30 downto 0);
        app_wdf_wren    : out    vl_logic;
        app_wdf_data    : out    vl_logic_vector;
        app_wdf_mask_data: out    vl_logic_vector;
        error           : out    vl_logic;
        error_cmp       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BANK_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of COL_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DM_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DQ_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ROW_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of APPDATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ECC_ENABLE : constant is 1;
    attribute mti_svvh_generic_type of BURST_LEN : constant is 1;
end ddr2_tb_top;
