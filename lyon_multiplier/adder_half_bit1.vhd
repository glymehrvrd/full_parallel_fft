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

BEGIN
    sum_out <= (data1_in OR data2_in) AND (data1_in NAND data2_in);
    c_out <= NOT (data1_in NAND data2_in);

END Behavioral;

