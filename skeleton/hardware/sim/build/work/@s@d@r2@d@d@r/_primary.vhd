library verilog;
use verilog.vl_types.all;
entity SDR2DDR is
    generic(
        DDRWidth        : integer := 1;
        Interleave      : integer := 1
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Set             : in     vl_logic;
        \In\            : in     vl_logic_vector;
        \Out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DDRWidth : constant is 1;
    attribute mti_svvh_generic_type of Interleave : constant is 1;
end SDR2DDR;
