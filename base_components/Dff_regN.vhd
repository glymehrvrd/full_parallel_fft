LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Dff_regN IS
    GENERIC (N : INTEGER);
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC;
        QN : OUT STD_LOGIC
    );
END Dff_regN;

ARCHITECTURE Behavioral OF Dff_regN IS

    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC;
            QN : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL reg : std_logic_vector(N - 1 DOWNTO 0);
BEGIN
    reg(0) <= D;
    GEN_DFF : FOR I IN 0 TO N - 1 GENERATE
        DFFX : IF I < N - 1 GENERATE
        DFF_X : Dff_reg1
        PORT MAP(
            D    => reg(I), 
            clk  => clk, 
            Q    => reg(I + 1)
        );
    END GENERATE DFFX;

    LAST_DFF : IF I = N - 1 GENERATE
    DFF_LAST : Dff_reg1
    PORT MAP(
        D    => reg(I), 
        clk  => clk, 
        Q    => Q,
        QN   => QN
    );
END GENERATE LAST_DFF;
END GENERATE; -- GEN_DFF

END Behavioral;
