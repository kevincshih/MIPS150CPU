library verilog;
use verilog.vl_types.all;
entity FIFORegControl is
    generic(
        FWLatency       : integer := 1;
        BWLatency       : integer := 0;
        InitialValid    : integer := 0;
        ResetValid      : integer := 0
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        InValid         : in     vl_logic;
        InAccept        : out    vl_logic;
        OutSend         : out    vl_logic;
        OutReady        : in     vl_logic;
        Full            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FWLatency : constant is 1;
    attribute mti_svvh_generic_type of BWLatency : constant is 1;
    attribute mti_svvh_generic_type of InitialValid : constant is 1;
    attribute mti_svvh_generic_type of ResetValid : constant is 1;
end FIFORegControl;
