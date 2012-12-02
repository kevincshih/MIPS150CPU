library verilog;
use verilog.vl_types.all;
entity Control is
    port(
        OldStall        : in     vl_logic;
        Instruction     : in     vl_logic_vector(31 downto 0);
        OldInstruction  : in     vl_logic_vector(31 downto 0);
        Address         : in     vl_logic_vector(31 downto 0);
        PC              : in     vl_logic_vector(31 downto 0);
        branch          : in     vl_logic;
        reset           : in     vl_logic;
        offset          : in     vl_logic_vector(1 downto 0);
        PCsel           : out    vl_logic_vector(1 downto 0);
        RegDst          : out    vl_logic_vector(1 downto 0);
        UARTsel         : out    vl_logic_vector(1 downto 0);
        RDsel           : out    vl_logic_vector(1 downto 0);
        AluSelA         : out    vl_logic_vector(1 downto 0);
        AluSelB         : out    vl_logic_vector(1 downto 0);
        ALUop           : out    vl_logic_vector(3 downto 0);
        IMByteSel       : out    vl_logic_vector(3 downto 0);
        DMByteSel       : out    vl_logic_vector(3 downto 0);
        REUART          : out    vl_logic;
        WEUART          : out    vl_logic;
        RegWrite        : out    vl_logic;
        DinSel          : out    vl_logic;
        CTsel           : out    vl_logic;
        CTreset         : out    vl_logic;
        REDC            : out    vl_logic;
        ICacheSel       : out    vl_logic;
        SEXTImm         : out    vl_logic;
        JRsel           : out    vl_logic;
        ControlStall    : out    vl_logic
    );
end Control;