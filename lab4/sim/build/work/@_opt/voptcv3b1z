library verilog;
use verilog.vl_types.all;
entity EchoTestbench is
    generic(
        HalfCycle       : integer := 5;
        Cycle           : vl_notype;
        ClockFreq       : integer := 100000000
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of HalfCycle : constant is 1;
    attribute mti_svvh_generic_type of Cycle : constant is 3;
    attribute mti_svvh_generic_type of ClockFreq : constant is 1;
end EchoTestbench;
