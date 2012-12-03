library verilog;
use verilog.vl_types.all;
entity CountRegion is
    generic(
        Width           : integer := 8;
        Start           : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        \End\           : vl_logic_vector(0 to 8) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        UseMagnitude    : vl_notype
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Enable          : in     vl_logic;
        Count           : in     vl_logic_vector;
        Max             : in     vl_logic;
        Output          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of Start : constant is 1;
    attribute mti_svvh_generic_type of \End\ : constant is 1;
    attribute mti_svvh_generic_type of UseMagnitude : constant is 3;
end CountRegion;
