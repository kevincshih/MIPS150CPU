library verilog;
use verilog.vl_types.all;
entity ButtonParse is
    generic(
        Width           : integer := 1;
        EdgeWidth       : integer := 3;
        EdgeUpWidth     : integer := 2;
        DebWidth        : integer := 16;
        DebSimWidth     : integer := 4;
        EdgeType        : integer := 0;
        Related         : integer := 1;
        EnableEdge      : integer := 0;
        Continuous      : integer := 0;
        EdgeOutWidth    : integer := 1;
        AsyncReset      : integer := 0
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Enable          : in     vl_logic;
        \In\            : in     vl_logic_vector;
        \Out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of EdgeWidth : constant is 1;
    attribute mti_svvh_generic_type of EdgeUpWidth : constant is 1;
    attribute mti_svvh_generic_type of DebWidth : constant is 1;
    attribute mti_svvh_generic_type of DebSimWidth : constant is 1;
    attribute mti_svvh_generic_type of EdgeType : constant is 1;
    attribute mti_svvh_generic_type of Related : constant is 1;
    attribute mti_svvh_generic_type of EnableEdge : constant is 1;
    attribute mti_svvh_generic_type of Continuous : constant is 1;
    attribute mti_svvh_generic_type of EdgeOutWidth : constant is 1;
    attribute mti_svvh_generic_type of AsyncReset : constant is 1;
end ButtonParse;
