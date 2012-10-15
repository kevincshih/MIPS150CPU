library verilog;
use verilog.vl_types.all;
entity Branch_module is
    port(
        ALUSrcA         : in     vl_logic_vector(31 downto 0);
        ALUSrcB         : in     vl_logic_vector(31 downto 0);
        opcode          : in     vl_logic_vector(5 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        take_branch     : out    vl_logic
    );
end Branch_module;
