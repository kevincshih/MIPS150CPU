library verilog;
use verilog.vl_types.all;
entity GraphicsProcessor is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        LE_ready        : in     vl_logic;
        LE_color        : out    vl_logic_vector(31 downto 0);
        LE_point        : out    vl_logic_vector(9 downto 0);
        LE_color_valid  : out    vl_logic;
        LE_x0_valid     : out    vl_logic;
        LE_y0_valid     : out    vl_logic;
        LE_x1_valid     : out    vl_logic;
        LE_y1_valid     : out    vl_logic;
        LE_trigger      : out    vl_logic;
        LE_frame        : out    vl_logic_vector(31 downto 0);
        FF_ready        : in     vl_logic;
        FF_valid        : out    vl_logic;
        FF_color        : out    vl_logic_vector(23 downto 0);
        FF_frame        : out    vl_logic_vector(31 downto 0);
        rdf_valid       : in     vl_logic;
        af_full         : in     vl_logic;
        rdf_dout        : in     vl_logic_vector(127 downto 0);
        rdf_rd_en       : out    vl_logic;
        af_wr_en        : out    vl_logic;
        af_addr_din     : out    vl_logic_vector(31 downto 0);
        GP_CODE         : in     vl_logic_vector(31 downto 0);
        GP_FRAME        : in     vl_logic_vector(31 downto 0);
        GP_valid        : in     vl_logic
    );
end GraphicsProcessor;
