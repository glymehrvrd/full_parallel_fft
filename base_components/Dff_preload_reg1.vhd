LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_preload_reg1 IS
    PORT (
        D        : IN STD_LOGIC;
        clk      : IN STD_LOGIC;
        preload  : IN STD_LOGIC; --- active low
        Q        : OUT STD_LOGIC;
        QN       : OUT STD_LOGIC
    );
END Dff_preload_reg1;

ARCHITECTURE Behavioral OF Dff_preload_reg1 IS
 
    COMPONENT DFFRXLTL IS
        PORT (
            D   : IN STD_LOGIC;
            CK  : IN STD_LOGIC;
            RN  : IN STD_LOGIC;
            Q   : OUT STD_LOGIC;
            QN  : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UDFFR : DFFRXLTL
    PORT MAP(
        D   => D, 
        CK  => clk, 
        RN  => preload, 
        Q   => Q, 
        QN  => QN
    );

END Behavioral;
