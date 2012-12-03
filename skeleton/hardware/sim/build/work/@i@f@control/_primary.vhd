library verilog;
use verilog.vl_types.all;
entity IFControl is
    port(
        PC              : in     vl_logic_vector(31 downto 0);
        reset           : in     vl_logic;
        stall           : in     vl_logic;
        stall_reg       : in     vl_logic;
        REIC            : out    vl_logic;
        REBIOS          : out    vl_logic;
        REISR           : out    vl_logic;
        IFSel           : out    vl_logic_vector(1 downto 0)
    );
end IFControl;
