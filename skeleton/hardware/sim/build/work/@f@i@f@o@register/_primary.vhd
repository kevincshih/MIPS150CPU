library verilog;
use verilog.vl_types.all;
entity FIFORegister is
    generic(
        Width           : integer := 32;
        FWLatency       : integer := 1;
        BWLatency       : integer := 0;
        Initial         : vl_notype;
        InitialValid    : vl_logic := Hi0;
        ResetValue      : vl_notype;
        ResetValid      : vl_logic := Hi0;
        Conservative    : integer := 0
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        InData          : in     vl_logic_vector;
        InValid         : in     vl_logic;
        InAccept        : out    vl_logic;
        OutData         : out    vl_logic_vector;
        OutSend         : out    vl_logic;
        OutReady        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of FWLatency : constant is 1;
    attribute mti_svvh_generic_type of BWLatency : constant is 1;
    attribute mti_svvh_generic_type of Initial : constant is 3;
    attribute mti_svvh_generic_type of InitialValid : constant is 1;
    attribute mti_svvh_generic_type of ResetValue : constant is 3;
    attribute mti_svvh_generic_type of ResetValid : constant is 1;
    attribute mti_svvh_generic_type of Conservative : constant is 1;
end FIFORegister;
