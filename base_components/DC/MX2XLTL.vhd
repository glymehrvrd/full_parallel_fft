LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MX2XLTL IS
    PORT (
        A   : IN STD_LOGIC;
        B   : IN std_logic;
        S0  : IN STD_LOGIC;
        Y   : OUT STD_LOGIC
    );
END MX2XLTL;

ARCHITECTURE Behavioral OF MX2XLTL IS

BEGIN
    Y <= A WHEN S0 = '0' ELSE B;

END Behavioral;

