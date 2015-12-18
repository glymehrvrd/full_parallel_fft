LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_reg1 IS
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC;
        QN   : OUT STD_LOGIC
    );
END Dff_reg1;

ARCHITECTURE Behavioral OF Dff_reg1 IS

    COMPONENT DFFX1_LVT IS
        PORT (
            D    : IN STD_LOGIC;
            CLK  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC;
            QN   : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UDFF : DFFX1_LVT
    PORT MAP(
        D    => D, 
        CLK  => clk, 
        Q    => Q, 
        QN   => QN
    );

END Behavioral;
