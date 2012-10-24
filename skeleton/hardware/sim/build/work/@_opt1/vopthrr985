library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        PC_Branch       : in     vl_logic_vector(31 downto 0);
        PC_4            : in     vl_logic_vector(31 downto 0);
        PC_JAL          : in     vl_logic_vector(31 downto 0);
        JR              : in     vl_logic_vector(31 downto 0);
        PC_Sel          : in     vl_logic_vector(1 downto 0);
        EN              : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        flush           : in     vl_logic;
        PC_IF           : out    vl_logic_vector(31 downto 0)
    );
end PC;
