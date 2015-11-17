LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_reg1 IS
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC
    );
END Dff_reg1;

ARCHITECTURE Behavioral OF Dff_reg1 IS

    SIGNAL reg : std_logic_vector(0 DOWNTO 0);

    COMPONENT DFFQXLTL IS
        PORT (
            D   : IN STD_LOGIC;
            CK  : IN STD_LOGIC;
            Q   : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    UDFF : DFFQXLTL
    PORT MAP(
        D   => D, 
        CK  => clk, 
        Q   => Q
    );

END Behavioral;
