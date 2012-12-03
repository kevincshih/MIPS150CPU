library verilog;
use verilog.vl_types.all;
entity chipscope_ila is
    port(
        CONTROL         : inout  vl_logic_vector(35 downto 0);
        CLK             : in     vl_logic;
        DATA            : in     vl_logic_vector(511 downto 0);
        TRIG0           : in     vl_logic_vector(0 downto 0)
    );
end chipscope_ila;
