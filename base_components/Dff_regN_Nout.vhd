LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_regN_Nout IS
    GENERIC (N : INTEGER);
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END Dff_regN_Nout;

ARCHITECTURE Behavioral OF Dff_regN_Nout IS

    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL reg : std_logic_vector(N DOWNTO 0);
BEGIN
    reg(0) <= D;
    Q <= reg(N DOWNTO 1);
    GEN_DFF : FOR I IN 0 TO N - 1 GENERATE
        DFF_X : Dff_reg1
        PORT MAP(
            D    => reg(I), 
            clk  => clk, 
            Q    => reg(I + 1)
        );
    END GENERATE; -- GEN_DFF

END Behavioral;
