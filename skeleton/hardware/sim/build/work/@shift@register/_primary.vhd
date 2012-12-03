library verilog;
use verilog.vl_types.all;
entity ShiftRegister is
    generic(
        PWidth          : integer := 32;
        SWidth          : integer := 1;
        Reverse         : integer := 0;
        Initial         : vl_notype;
        AsyncReset      : integer := 0;
        AsyncSet        : integer := 0;
        ResetValue      : vl_notype;
        SetValue        : vl_notype
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Load            : in     vl_logic;
        Enable          : in     vl_logic;
        PIn             : in     vl_logic_vector;
        SIn             : in     vl_logic_vector;
        POut            : out    vl_logic_vector;
        SOut            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PWidth : constant is 1;
    attribute mti_svvh_generic_type of SWidth : constant is 1;
    attribute mti_svvh_generic_type of Reverse : constant is 1;
    attribute mti_svvh_generic_type of Initial : constant is 3;
    attribute mti_svvh_generic_type of AsyncReset : constant is 1;
    attribute mti_svvh_generic_type of AsyncSet : constant is 1;
    attribute mti_svvh_generic_type of ResetValue : constant is 3;
    attribute mti_svvh_generic_type of SetValue : constant is 3;
end ShiftRegister;
