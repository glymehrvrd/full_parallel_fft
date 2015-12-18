LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFFX1_LVT IS
    PORT (
        D    : IN STD_LOGIC;
        CLK  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC;
        QN   : OUT STD_LOGIC
    );
END DFFX1_LVT;

ARCHITECTURE Behavioral OF DFFX1_LVT IS

BEGIN
    PROCESS (CLK)
    BEGIN
        IF CLK'EVENT AND CLK = '1' THEN
            Q <= D;
            QN <= NOT D;
        END IF;
    END PROCESS;

END Behavioral;
