LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY adder_half_bit1 IS
    PORT (
        data1_in  : IN STD_LOGIC;
        data2_in  : IN STD_LOGIC;
        sum_out   : OUT STD_LOGIC;
        c_out     : OUT STD_LOGIC
    );
END adder_half_bit1;

ARCHITECTURE Behavioral OF adder_half_bit1 IS

    COMPONENT HADDX1_LVT IS
        PORT (
            A0   : IN STD_LOGIC;
            B0   : IN STD_LOGIC;
            S0   : OUT STD_LOGIC;
            C1  : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UADD : HADDX1_LVT
    PORT MAP(
        A0   => data1_in, 
        B0   => data2_in, 
        S0   => sum_out, 
        C1  => c_out
    );
END Behavioral;

