library verilog;
use verilog.vl_types.all;
entity PixelFeeder is
    port(
        cpu_clk_g       : in     vl_logic;
        clk50_g         : in     vl_logic;
        rst             : in     vl_logic;
        rdf_valid       : in     vl_logic;
        af_full         : in     vl_logic;
        rdf_dout        : in     vl_logic_vector(127 downto 0);
        rdf_rd_en       : out    vl_logic;
        af_wr_en        : out    vl_logic;
        af_addr_din     : out    vl_logic_vector(30 downto 0);
        video           : out    vl_logic_vector(23 downto 0);
        video_valid     : out    vl_logic;
        video_ready     : in     vl_logic;
        frame_interrupt : out    vl_logic
    );
end PixelFeeder;
