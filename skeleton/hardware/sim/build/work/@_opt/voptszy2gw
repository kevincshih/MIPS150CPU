library verilog;
use verilog.vl_types.all;
entity COP0150 is
    port(
        Clock           : in     vl_logic;
        Enable          : in     vl_logic;
        Reset           : in     vl_logic;
        DataAddress     : in     vl_logic_vector(4 downto 0);
        DataOut         : out    vl_logic_vector(31 downto 0);
        DataInEnable    : in     vl_logic;
        DataIn          : in     vl_logic_vector(31 downto 0);
        InterruptedPC   : in     vl_logic_vector(31 downto 0);
        InterruptHandled: in     vl_logic;
        InterruptRequest: out    vl_logic;
        UART0Request    : in     vl_logic;
        UART1Request    : in     vl_logic
    );
end COP0150;
