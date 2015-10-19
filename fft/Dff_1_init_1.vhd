LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_reg1_init_1 IS
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        ce   : IN STD_LOGIC;
        rst  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC
    );
END Dff_reg1_init_1;

ARCHITECTURE Behavioral OF Dff_reg1_init_1 IS

    SIGNAL reg : std_logic_vector(0 DOWNTO 0);
BEGIN
    Q <= reg(0);

    PROCESS (clk, rst)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                reg <= (OTHERS => '1');
            ELSIF ce = '1' THEN
                reg(0) <= D;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
