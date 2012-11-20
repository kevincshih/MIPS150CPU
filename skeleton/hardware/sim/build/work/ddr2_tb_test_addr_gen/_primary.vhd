library verilog;
use verilog.vl_types.all;
entity ddr2_tb_test_addr_gen is
    generic(
        BANK_WIDTH      : integer := 2;
        COL_WIDTH       : integer := 10;
        ROW_WIDTH       : integer := 14
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        wr_addr_en      : in     vl_logic;
        app_af_cmd      : out    vl_logic_vector(2 downto 0);
        app_af_addr     : out    vl_logic_vector(30 downto 0);
        app_af_wren     : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BANK_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of COL_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ROW_WIDTH : constant is 1;
end ddr2_tb_test_addr_gen;
