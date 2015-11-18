LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY adder_bit1 IS
    PORT (
        data1_in  : IN STD_LOGIC;
        data2_in  : IN STD_LOGIC;
        c_in      : IN STD_LOGIC;
        sum_out   : OUT STD_LOGIC;
        c_out     : OUT STD_LOGIC
    );
END adder_bit1;

ARCHITECTURE Behavioral OF adder_bit1 IS

    COMPONENT FADDX1_LVT IS
        PORT (
            A0   : IN STD_LOGIC;
            B0   : IN STD_LOGIC;
            CI  : IN STD_LOGIC;
            S   : OUT STD_LOGIC;
            CO  : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UADD : FADDX1_LVT
    PORT MAP(
        A0   => data1_in, 
        B0   => data2_in, 
        CI  => c_in, 
        S   => sum_out, 
        CO  => c_out
    );

END Behavioral;

