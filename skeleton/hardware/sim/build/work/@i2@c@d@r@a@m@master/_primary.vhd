library verilog;
use verilog.vl_types.all;
entity I2CDRAMMaster is
    generic(
        ClockFreq       : integer := 100000000;
        I2CRate         : integer := 100000;
        WAWidth         : integer := 8;
        SingleSlave     : integer := 1;
        SlaveAddress    : vl_logic_vector(0 to 6) := (Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1)
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        SDA             : inout  vl_logic;
        SCL             : inout  vl_logic;
        CommandAddress  : in     vl_logic_vector;
        Command         : in     vl_logic_vector(0 downto 0);
        CommandValid    : in     vl_logic;
        CommandReady    : out    vl_logic;
        DataIn          : in     vl_logic_vector(7 downto 0);
        DataInValid     : in     vl_logic;
        DataInReady     : out    vl_logic;
        DataOut         : out    vl_logic_vector(7 downto 0);
        DataOutValid    : out    vl_logic;
        DataOutReady    : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ClockFreq : constant is 1;
    attribute mti_svvh_generic_type of I2CRate : constant is 1;
    attribute mti_svvh_generic_type of WAWidth : constant is 1;
    attribute mti_svvh_generic_type of SingleSlave : constant is 1;
    attribute mti_svvh_generic_type of SlaveAddress : constant is 1;
end I2CDRAMMaster;
