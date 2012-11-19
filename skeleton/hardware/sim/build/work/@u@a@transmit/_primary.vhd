library verilog;
use verilog.vl_types.all;
entity UATransmit is
    generic(
        ClockFreq       : integer := 100000000;
        BaudRate        : integer := 115200
    );
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        DataIn          : in     vl_logic_vector(7 downto 0);
        DataInValid     : in     vl_logic;
        DataInReady     : out    vl_logic;
        SOut            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ClockFreq : constant is 1;
    attribute mti_svvh_generic_type of BaudRate : constant is 1;
end UATransmit;
