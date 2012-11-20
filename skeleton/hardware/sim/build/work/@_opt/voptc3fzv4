library verilog;
use verilog.vl_types.all;
entity mig_wdf is
    port(
        valid           : out    vl_logic;
        rd_en           : in     vl_logic;
        wr_en           : in     vl_logic;
        full            : out    vl_logic;
        empty           : out    vl_logic;
        wr_clk          : in     vl_logic;
        rst             : in     vl_logic;
        rd_clk          : in     vl_logic;
        dout            : out    vl_logic_vector(143 downto 0);
        din             : in     vl_logic_vector(143 downto 0)
    );
end mig_wdf;
