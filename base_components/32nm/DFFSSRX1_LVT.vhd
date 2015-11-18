LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFFSSRX1_LVT IS
    PORT (
        D   : IN STD_LOGIC;
        CLK  : IN STD_LOGIC;
        SETB  : IN STD_LOGIC;
        RSTB: IN STD_LOGIC;
        Q   : OUT STD_LOGIC;
        QN  : OUT STD_LOGIC
    );
END DFFSSRX1_LVT;

ARCHITECTURE Behavioral OF DFFSSRX1_LVT IS

BEGIN
    PROCESS (CLK, SETB, RSTB)
    BEGIN
        IF CLK'EVENT AND CLK = '1' THEN
            IF SETB = '0' THEN
                Q <= '1';
                QN <= '0';
            ELSIF RSTB = '1' THEN
                Q <= '0';
                QN <= '1';
            ELSE
                Q <= D;
                QN <= NOT D;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
