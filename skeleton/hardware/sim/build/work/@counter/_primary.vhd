library verilog;
use verilog.vl_types.all;
entity Counter is
    generic(
        Width           : integer := 32;
        Limited         : integer := 0;
        Down            : integer := 0;
        Initial         : vl_notype;
        AsyncReset      : integer := 0;
        AsyncSet        : integer := 0;
        ResetValue      : vl_notype;
        SetValue        : vl_notype
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Set             : in     vl_logic;
        Load            : in     vl_logic;
        Enable          : in     vl_logic;
        \In\            : in     vl_logic_vector;
        Count           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of Limited : constant is 1;
    attribute mti_svvh_generic_type of Down : constant is 1;
    attribute mti_svvh_generic_type of Initial : constant is 3;
    attribute mti_svvh_generic_type of AsyncReset : constant is 1;
    attribute mti_svvh_generic_type of AsyncSet : constant is 1;
    attribute mti_svvh_generic_type of ResetValue : constant is 3;
    attribute mti_svvh_generic_type of SetValue : constant is 3;
end Counter;
