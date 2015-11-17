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

    COMPONENT ADDFXLTL IS
        PORT (
            A   : IN STD_LOGIC;
            B   : IN STD_LOGIC;
            CI  : IN STD_LOGIC;
            S   : OUT STD_LOGIC;
            CO  : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UADD : ADDFXLTL
    PORT MAP(
        A   => data1_in, 
        B   => data2_in, 
        CI  => c_in, 
        S   => sum_out, 
        CO  => c_out
    );

END Behavioral;

