LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFFRXLTL IS
    PORT (
        D   : IN STD_LOGIC;
        CK  : IN STD_LOGIC;
        RN  : IN STD_LOGIC;
        Q   : OUT STD_LOGIC;
        QN  : OUT STD_LOGIC
    );
END DFFRXLTL;

ARCHITECTURE Behavioral OF DFFRXLTL IS

BEGIN

    PROCESS (CK, RN)
    BEGIN
        IF RN = '0' THEN
            Q <= '0';
            QN <= '1';
        ELSIF CK'EVENT AND CK = '1' THEN
            Q <= D;
            QN <= not D;
        END IF;
    END PROCESS;

END Behavioral;
