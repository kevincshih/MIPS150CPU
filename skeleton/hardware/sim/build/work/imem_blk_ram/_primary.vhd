library verilog;
use verilog.vl_types.all;
entity imem_blk_ram is
    port(
        clka            : in     vl_logic;
        ena             : in     vl_logic;
        wea             : in     vl_logic_vector(3 downto 0);
        addra           : in     vl_logic_vector(11 downto 0);
        dina            : in     vl_logic_vector(31 downto 0);
        clkb            : in     vl_logic;
        addrb           : in     vl_logic_vector(11 downto 0);
        doutb           : out    vl_logic_vector(31 downto 0)
    );
end imem_blk_ram;
