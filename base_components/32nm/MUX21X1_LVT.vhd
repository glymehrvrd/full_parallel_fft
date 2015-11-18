LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX21X1_LVT IS
    PORT (
        A1   : IN STD_LOGIC;
        A2   : IN std_logic;
        S  : IN STD_LOGIC;
        Y   : OUT STD_LOGIC
    );
END MUX21X1_LVT;

ARCHITECTURE Behavioral OF MUX21X1_LVT IS

BEGIN
    Y <= A1 WHEN S = '0' ELSE A2;

END Behavioral;

