library verilog;
use verilog.vl_types.all;
entity Control is
    port(
        Instruction     : in     vl_logic_vector(31 downto 0);
        OldInstruction  : in     vl_logic_vector(31 downto 0);
        Address         : in     vl_logic_vector(31 downto 0);
        branch          : in     vl_logic;
        reset           : in     vl_logic;
        PCsel           : out    vl_logic_vector(1 downto 0);
        RegDst          : out    vl_logic_vector(1 downto 0);
        UARTsel         : out    vl_logic_vector(1 downto 0);
        RDsel           : out    vl_logic_vector(1 downto 0);
        AluSelA         : out    vl_logic_vector(1 downto 0);
        AluSelB         : out    vl_logic_vector(1 downto 0);
        ALUop           : out    vl_logic_vector(3 downto 0);
        ByteSel         : out    vl_logic_vector(3 downto 0);
        WEIM            : out    vl_logic;
        WEDM            : out    vl_logic;
        REUART          : out    vl_logic;
        WEUART          : out    vl_logic;
        RegWrite        : out    vl_logic;
        DinSel          : out    vl_logic
    );
end Control;
