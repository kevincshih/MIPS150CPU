library verilog;
use verilog.vl_types.all;
entity FIFOInitial is
    generic(
        Width           : integer := 8;
        Depth           : integer := 2;
        Value           : vl_notype
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Done            : out    vl_logic;
        OutData         : out    vl_logic_vector;
        OutValid        : out    vl_logic;
        OutReady        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of Depth : constant is 1;
    attribute mti_svvh_generic_type of Value : constant is 3;
end FIFOInitial;
