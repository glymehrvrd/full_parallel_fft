LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_in2 IS
    PORT (
        sel       : IN STD_LOGIC;

        data1_in  : IN STD_LOGIC;
        data2_in  : IN std_logic;
        data_out  : OUT std_logic
    );
END mux_in2;

ARCHITECTURE Behavioral OF mux_in2 IS

    COMPONENT MX2XLTL IS
        PORT (
            A   : IN STD_LOGIC;
            B   : IN std_logic;
            S0  : IN STD_LOGIC;
            Y   : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN
    UMX2 : MX2XLTL
    PORT MAP(
        A   => data2_in, 
        B   => data1_in, 
        S0  => sel, 
        Y   => data_out
    );

END Behavioral;

