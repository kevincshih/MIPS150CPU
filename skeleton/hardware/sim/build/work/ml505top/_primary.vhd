library verilog;
use verilog.vl_types.all;
entity ml505top is
    port(
        FPGA_SERIAL_RX  : in     vl_logic;
        FPGA_SERIAL_TX  : out    vl_logic;
        GPIO_SW_C       : in     vl_logic;
        GPIO_SW_S       : in     vl_logic;
        USER_CLK        : in     vl_logic;
        GPIO_LED        : out    vl_logic_vector(7 downto 0);
        DDR2_A          : out    vl_logic_vector(12 downto 0);
        DDR2_BA         : out    vl_logic_vector(1 downto 0);
        DDR2_CAS_B      : out    vl_logic;
        DDR2_CKE        : out    vl_logic;
        DDR2_CLK_N      : out    vl_logic_vector(1 downto 0);
        DDR2_CLK_P      : out    vl_logic_vector(1 downto 0);
        DDR2_CS_B       : out    vl_logic;
        DDR2_D          : inout  vl_logic_vector(63 downto 0);
        DDR2_DM         : out    vl_logic_vector(7 downto 0);
        DDR2_DQS_N      : inout  vl_logic_vector(7 downto 0);
        DDR2_DQS_P      : inout  vl_logic_vector(7 downto 0);
        DDR2_ODT        : out    vl_logic;
        DDR2_RAS_B      : out    vl_logic;
        DDR2_WE_B       : out    vl_logic;
        DVI_D           : out    vl_logic_vector(11 downto 0);
        DVI_DE          : out    vl_logic;
        DVI_H           : out    vl_logic;
        DVI_RESET_B     : out    vl_logic;
        DVI_V           : out    vl_logic;
        DVI_XCLK_N      : out    vl_logic;
        DVI_XCLK_P      : out    vl_logic;
        IIC_SCL_VIDEO   : inout  vl_logic;
        IIC_SDA_VIDEO   : inout  vl_logic
    );
end ml505top;
