library verilog;
use verilog.vl_types.all;
entity IORegister is
    generic(
        Width           : integer := 32;
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
        Enable          : in     vl_logic;
        \In\            : in     vl_logic_vector;
        \Out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of Initial : constant is 3;
    attribute mti_svvh_generic_type of AsyncReset : constant is 1;
    attribute mti_svvh_generic_type of AsyncSet : constant is 1;
    attribute mti_svvh_generic_type of ResetValue : constant is 3;
    attribute mti_svvh_generic_type of SetValue : constant is 3;
end IORegister;
