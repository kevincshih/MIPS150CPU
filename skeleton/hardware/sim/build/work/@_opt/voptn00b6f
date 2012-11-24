library verilog;
use verilog.vl_types.all;
entity MIPS150 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        FPGA_SERIAL_RX  : in     vl_logic;
        FPGA_SERIAL_TX  : out    vl_logic;
        dcache_addr     : out    vl_logic_vector(31 downto 0);
        icache_addr     : out    vl_logic_vector(31 downto 0);
        dcache_we       : out    vl_logic_vector(3 downto 0);
        icache_we       : out    vl_logic_vector(3 downto 0);
        dcache_re       : out    vl_logic;
        icache_re       : out    vl_logic;
        dcache_din      : out    vl_logic_vector(31 downto 0);
        icache_din      : out    vl_logic_vector(31 downto 0);
        dcache_dout     : in     vl_logic_vector(31 downto 0);
        instruction     : in     vl_logic_vector(31 downto 0);
        stall           : in     vl_logic
    );
end MIPS150;
