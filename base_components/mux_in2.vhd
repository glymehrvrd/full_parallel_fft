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

    COMPONENT MUX21X1_LVT IS
        PORT (
            A1   : IN STD_LOGIC;
            A2   : IN std_logic;
            S  : IN STD_LOGIC;
            Y   : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN
    UMX2 : MUX21X1_LVT
    PORT MAP(
        A1   => data2_in, 
        A2   => data1_in, 
        S  => sel, 
        Y   => data_out
    );

END Behavioral;

