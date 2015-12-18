LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HADDX1_LVT IS
    PORT (
        A0  : IN STD_LOGIC;
        B0  : IN STD_LOGIC;
        S0  : OUT STD_LOGIC;
        C1  : OUT STD_LOGIC
    );
END HADDX1_LVT;

ARCHITECTURE Behavioral OF HADDX1_LVT IS

BEGIN
    S0 <= (A0 OR B0) AND (A0 NAND B0);
    C1 <= NOT (A0 NAND B0);

END Behavioral;

