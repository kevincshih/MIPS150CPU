library verilog;
use verilog.vl_types.all;
entity LineEngineTestbench is
    generic(
        HalfCycle       : integer := 5
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of HalfCycle : constant is 1;
end LineEngineTestbench;
