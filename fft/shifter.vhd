library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
    port(
            clk            : IN STD_LOGIC;
            rst            : IN STD_LOGIC;
            ce             : IN STD_LOGIC;
            ctrl           : IN STD_LOGIC;

            data_in:in std_logic;

            data_out:out std_logic
        );
end shifter;

architecture Behavioral of shifter is
    SIGNAL data_in_delay : std_logic;
begin

    --- buffer for data_in
    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                data_in_delay<='0';
            ELSIF ce = '1' THEN
                data_in_delay<=data_in;
            END IF;
        END IF;
    END PROCESS;

    data_out<=data_in_delay when ctrl='1'
                else data_in;

end Behavioral;

