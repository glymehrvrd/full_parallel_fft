LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ADDFXLTL IS
    PORT (
        A   : IN STD_LOGIC;
        B   : IN STD_LOGIC;
        CI  : IN STD_LOGIC;
        S   : OUT STD_LOGIC;
        CO  : OUT STD_LOGIC
    );
END ADDFXLTL;

ARCHITECTURE Behavioral OF ADDFXLTL IS

BEGIN
    S <= ((A XOR B) XOR CI);
    CO <= (((A XOR B) AND CI)) OR (A AND B);

END Behavioral;

