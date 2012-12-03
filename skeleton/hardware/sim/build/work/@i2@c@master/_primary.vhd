library verilog;
use verilog.vl_types.all;
entity I2CMaster is
    generic(
        ClockFreq       : integer := 100000000;
        I2CRate         : integer := 400000
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        SDA             : inout  vl_logic;
        SCL             : inout  vl_logic;
        Command         : in     vl_logic_vector(1 downto 0);
        CommandValid    : in     vl_logic;
        CommandReady    : out    vl_logic;
        DataIn          : in     vl_logic_vector(7 downto 0);
        DataInValid     : in     vl_logic;
        DataInReady     : out    vl_logic;
        DataOut         : out    vl_logic_vector(7 downto 0);
        DataOutAck      : in     vl_logic;
        DataOutValid    : out    vl_logic;
        DataOutReady    : in     vl_logic;
        Ack             : out    vl_logic;
        AckValid        : out    vl_logic;
        AckReady        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ClockFreq : constant is 1;
    attribute mti_svvh_generic_type of I2CRate : constant is 1;
end I2CMaster;
