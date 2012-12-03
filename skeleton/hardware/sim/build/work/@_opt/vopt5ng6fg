library verilog;
use verilog.vl_types.all;
entity FrameFiller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        valid           : in     vl_logic;
        color           : in     vl_logic_vector(23 downto 0);
        af_full         : in     vl_logic;
        wdf_full        : in     vl_logic;
        wdf_din         : out    vl_logic_vector(127 downto 0);
        wdf_wr_en       : out    vl_logic;
        af_addr_din     : out    vl_logic_vector(30 downto 0);
        af_wr_en        : out    vl_logic;
        wdf_mask_din    : out    vl_logic_vector(15 downto 0);
        ready           : out    vl_logic;
        FF_frame_base   : in     vl_logic_vector(31 downto 0)
    );
end FrameFiller;
