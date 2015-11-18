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

    COMPONENT DFFSSRX1_LVT IS
        PORT (
            D   : IN STD_LOGIC;
            CLK  : IN STD_LOGIC;
            SETB  : IN STD_LOGIC;
            RSTB: IN STD_LOGIC;
            Q   : OUT STD_LOGIC;
            QN  : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UDFFR : DFFSSRX1_LVT
    PORT MAP(
        D   => D, 
        CLK  => clk, 
        SETB => preload,
        RSTB => '1',
        Q   => Q, 
        QN  => QN
    );

END Behavioral;
