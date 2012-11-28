library verilog;
use verilog.vl_types.all;
entity Memory150 is
    generic(
        SIM_ONLY        : vl_logic := Hi0
    );
    port(
        cpu_clk_g       : in     vl_logic;
        clk0_g          : in     vl_logic;
        clk200_g        : in     vl_logic;
        clkdiv0_g       : in     vl_logic;
        clk90_g         : in     vl_logic;
        locked          : in     vl_logic;
        rst             : in     vl_logic;
        init_done       : out    vl_logic;
        DDR2_A          : out    vl_logic_vector(12 downto 0);
        DDR2_BA         : out    vl_logic_vector(1 downto 0);
        DDR2_CAS_B      : out    vl_logic;
        DDR2_CKE        : out    vl_logic;
        DDR2_CLK_N      : out    vl_logic_vector(1 downto 0);
        DDR2_CLK_P      : out    vl_logic_vector(1 downto 0);
        DDR2_CS_B       : out    vl_logic;
        DDR2_D          : inout  vl_logic_vector(63 downto 0);
        DDR2_DM         : out    vl_logic_vector(7 downto 0);
        DDR2_DQS_N      : inout  vl_logic_vector(7 downto 0);
        DDR2_DQS_P      : inout  vl_logic_vector(7 downto 0);
        DDR2_ODT        : out    vl_logic;
        DDR2_RAS_B      : out    vl_logic;
        DDR2_WE_B       : out    vl_logic;
        dcache_addr     : in     vl_logic_vector(31 downto 0);
        icache_addr     : in     vl_logic_vector(31 downto 0);
        dcache_we       : in     vl_logic_vector(3 downto 0);
        icache_we       : in     vl_logic_vector(3 downto 0);
        dcache_re       : in     vl_logic;
        icache_re       : in     vl_logic;
        dcache_din      : in     vl_logic_vector(31 downto 0);
        icache_din      : in     vl_logic_vector(31 downto 0);
        dcache_dout     : out    vl_logic_vector(31 downto 0);
        instruction     : out    vl_logic_vector(31 downto 0);
        stall           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIM_ONLY : constant is 1;
end Memory150;
