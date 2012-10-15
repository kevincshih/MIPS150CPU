library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        ALUop           : in     vl_logic_vector(3 downto 0);
        ByteSel         : in     vl_logic_vector(3 downto 0);
        WEIM            : in     vl_logic;
        WEDM            : in     vl_logic;
        REUART          : in     vl_logic;
        WEUART          : in     vl_logic;
        Stall           : in     vl_logic;
        CLK             : in     vl_logic;
        DataOutValid    : in     vl_logic;
        DataInReady     : in     vl_logic;
        reset           : in     vl_logic;
        RegWrite        : in     vl_logic;
        PC_Sel          : in     vl_logic_vector(1 downto 0);
        ALU_Sel_A       : in     vl_logic_vector(1 downto 0);
        ALU_Sel_B       : in     vl_logic_vector(1 downto 0);
        RegDst          : in     vl_logic_vector(1 downto 0);
        UARTsel         : in     vl_logic_vector(1 downto 0);
        RDsel           : in     vl_logic_vector(1 downto 0);
        DataOut         : in     vl_logic_vector(7 downto 0);
        Branch_compare  : out    vl_logic;
        Instruction     : out    vl_logic_vector(31 downto 0);
        PrevInstruction : out    vl_logic_vector(31 downto 0);
        Address         : out    vl_logic_vector(31 downto 0);
        DataOutReady    : out    vl_logic;
        DataInValid     : out    vl_logic;
        DataIn          : out    vl_logic_vector(7 downto 0)
    );
end Datapath;
