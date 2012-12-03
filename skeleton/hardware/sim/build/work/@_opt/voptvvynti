library verilog;
use verilog.vl_types.all;
entity LineEngine is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        LE_ready        : out    vl_logic;
        LE_color        : in     vl_logic_vector(31 downto 0);
        LE_point        : in     vl_logic_vector(9 downto 0);
        LE_color_valid  : in     vl_logic;
        LE_x0_valid     : in     vl_logic;
        LE_y0_valid     : in     vl_logic;
        LE_x1_valid     : in     vl_logic;
        LE_y1_valid     : in     vl_logic;
        LE_trigger      : in     vl_logic;
        af_full         : in     vl_logic;
        wdf_full        : in     vl_logic;
        af_addr_din     : out    vl_logic_vector(30 downto 0);
        af_wr_en        : out    vl_logic;
        wdf_din         : out    vl_logic_vector(127 downto 0);
        wdf_mask_din    : out    vl_logic_vector(15 downto 0);
        wdf_wr_en       : out    vl_logic;
        LE_frame_base   : in     vl_logic_vector(31 downto 0)
    );
end LineEngine;
