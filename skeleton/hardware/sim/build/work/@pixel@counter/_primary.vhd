library verilog;
use verilog.vl_types.all;
entity PixelCounter is
    generic(
        Width           : integer := 640;
        Height          : integer := 480;
        FrontH          : integer := 0;
        PulseH          : integer := 0;
        BackH           : integer := 0;
        FrontV          : integer := 0;
        PulseV          : integer := 0;
        BackV           : integer := 0
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        PixelX          : out    vl_logic_vector;
        PixelY          : out    vl_logic_vector;
        PixelActive     : out    vl_logic;
        PixelHSync      : out    vl_logic;
        PixelVSync      : out    vl_logic;
        PixelIncrement  : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of Height : constant is 1;
    attribute mti_svvh_generic_type of FrontH : constant is 1;
    attribute mti_svvh_generic_type of PulseH : constant is 1;
    attribute mti_svvh_generic_type of BackH : constant is 1;
    attribute mti_svvh_generic_type of FrontV : constant is 1;
    attribute mti_svvh_generic_type of PulseV : constant is 1;
    attribute mti_svvh_generic_type of BackV : constant is 1;
end PixelCounter;
