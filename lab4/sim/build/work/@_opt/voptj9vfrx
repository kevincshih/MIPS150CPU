library verilog;
use verilog.vl_types.all;
entity Debouncer is
    generic(
        Width           : integer := 16;
        SimWidth        : integer := 4;
        Continuous      : integer := 0;
        AsyncReset      : integer := 0
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Enable          : in     vl_logic;
        \In\            : in     vl_logic;
        \Out\           : out    vl_logic;
        Half            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
    attribute mti_svvh_generic_type of SimWidth : constant is 1;
    attribute mti_svvh_generic_type of Continuous : constant is 1;
    attribute mti_svvh_generic_type of AsyncReset : constant is 1;
end Debouncer;
