library verilog;
use verilog.vl_types.all;
entity DVIData is
    generic(
        Width           : integer := 1328;
        FrontH          : integer := 24;
        PulseH          : integer := 136;
        BackH           : integer := 144;
        Height          : integer := 806;
        FrontV          : integer := 3;
        PulseV          : integer := 6;
        BackV           : integer := 29
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        DVI_D           : out    vl_logic_vector(11 downto 0);
        DVI_DE          : out    vl_logic;
        DVI_H           : out    vl_logic;
        DVI_V           : out    vl_logic;
        DVI_RESET_B     : out    vl_logic;
        DVI_XCLK_N      : out    vl_logic;
        DVI_XCLK_P      : out    vl_logic;
        Video           : in     vl_logic_vector(23 downto 0);
        VideoReady      : out    vl_logic;
        VideoValid      : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of FrontH : constant is 1;
    attribute mti_svvh_generic_type of PulseH : constant is 1;
    attribute mti_svvh_generic_type of BackH : constant is 1;
    attribute mti_svvh_generic_type of Height : constant is 1;
    attribute mti_svvh_generic_type of FrontV : constant is 1;
    attribute mti_svvh_generic_type of PulseV : constant is 1;
    attribute mti_svvh_generic_type of BackV : constant is 1;
end DVIData;
