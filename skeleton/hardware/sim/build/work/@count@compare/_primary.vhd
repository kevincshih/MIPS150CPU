library verilog;
use verilog.vl_types.all;
entity CountCompare is
    generic(
        Width           : integer := 8;
        Compare         : vl_logic_vector(0 to 7) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1)
    );
    port(
        Count           : in     vl_logic_vector;
        TerminalCount   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of Compare : constant is 1;
end CountCompare;
