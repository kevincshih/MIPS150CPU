library verilog;
use verilog.vl_types.all;
entity Cache is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr            : in     vl_logic_vector(31 downto 0);
        din             : in     vl_logic_vector(31 downto 0);
        we              : in     vl_logic_vector(3 downto 0);
        re              : in     vl_logic;
        rdf_valid       : in     vl_logic;
        rdf_dout        : in     vl_logic_vector(127 downto 0);
        af_full         : in     vl_logic;
        wdf_full        : in     vl_logic;
        stall           : out    vl_logic;
        dout            : out    vl_logic_vector(31 downto 0);
        rdf_rd_en       : out    vl_logic;
        af_cmd_din      : out    vl_logic_vector(2 downto 0);
        af_addr_din     : out    vl_logic_vector(30 downto 0);
        af_wr_en        : out    vl_logic;
        wdf_din         : out    vl_logic_vector(127 downto 0);
        wdf_mask_din    : out    vl_logic_vector(15 downto 0);
        wdf_wr_en       : out    vl_logic;
        tag_hit         : out    vl_logic;
        tag_valid       : out    vl_logic;
        state           : out    vl_logic_vector(2 downto 0)
    );
end Cache;
