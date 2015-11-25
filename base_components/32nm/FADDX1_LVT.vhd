LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FADDX1_LVT IS
    PORT (
        A0   : IN STD_LOGIC;
        B0   : IN STD_LOGIC;
        CI  : IN STD_LOGIC;
        S   : OUT STD_LOGIC;
        CO  : OUT STD_LOGIC
    );
END FADDX1_LVT;

ARCHITECTURE Behavioral OF FADDX1_LVT IS

BEGIN
    S <= ((A0 XOR B0) XOR CI);
    CO <= (((A0 XOR B0) AND CI)) OR (A0 AND B0);

END Behavioral;
