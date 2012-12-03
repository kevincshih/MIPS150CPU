library verilog;
use verilog.vl_types.all;
entity DVIInitial is
    generic(
        ClockFreq       : integer := 100000000;
        I2CRate         : integer := 100000;
        I2CAddress      : vl_logic_vector(0 to 6) := (Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0)
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        I2C_SCL_DVI     : inout  vl_logic;
        I2C_SDA_DVI     : inout  vl_logic;
        InitDone        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ClockFreq : constant is 1;
    attribute mti_svvh_generic_type of I2CRate : constant is 1;
    attribute mti_svvh_generic_type of I2CAddress : constant is 1;
end DVIInitial;
