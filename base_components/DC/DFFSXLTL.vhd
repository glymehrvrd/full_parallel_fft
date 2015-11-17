LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFFSXLTL IS
    PORT (
        D   : IN STD_LOGIC;
        CK  : IN STD_LOGIC;
        SN  : IN STD_LOGIC;
        Q   : OUT STD_LOGIC;
        QN  : OUT STD_LOGIC
    );
END DFFSXLTL;

ARCHITECTURE Behavioral OF DFFSXLTL IS

BEGIN

    PROCESS (CK, SN)
    BEGIN
        IF SN = '0' THEN
            Q <= '1';
            QN <= '0';
        ELSIF CK'EVENT AND CK = '1' THEN
            Q <= D;
            QN <= not D;
        END IF;
    END PROCESS;

END Behavioral;
