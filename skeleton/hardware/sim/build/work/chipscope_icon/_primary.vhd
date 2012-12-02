library verilog;
use verilog.vl_types.all;
entity chipscope_icon is
    port(
        CONTROL0        : inout  vl_logic_vector(35 downto 0)
    );
end chipscope_icon;
