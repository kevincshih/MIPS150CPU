library verilog;
use verilog.vl_types.all;
entity Hazard is
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic
    );
end Hazard;
