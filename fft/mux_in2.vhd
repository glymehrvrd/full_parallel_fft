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

BEGIN
    data_out <= data1_in WHEN sel = '0' ELSE data2_in;

END Behavioral;

