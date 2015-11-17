LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_preload_reg1_init_1 IS
    PORT (
        D        : IN STD_LOGIC;
        clk      : IN STD_LOGIC;
        preload  : IN STD_LOGIC; --- active low
        Q        : OUT STD_LOGIC;
        QN       : OUT STD_LOGIC
    );
END Dff_preload_reg1_init_1;

ARCHITECTURE Behavioral OF Dff_preload_reg1_init_1 IS

    COMPONENT DFFSXLTL IS
        PORT (
            D   : IN STD_LOGIC;
            CK  : IN STD_LOGIC;
            SN  : IN STD_LOGIC;
            Q   : OUT STD_LOGIC;
            QN  : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UDFFR : DFFSXLTL
    PORT MAP(
        D   => D, 
        CK  => clk, 
        SN  => preload, 
        Q   => Q, 
        QN  => QN
    );

END Behavioral;
