LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY multiplier_mul1 IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk          : IN std_logic;
        rst          : IN std_logic;
        ce           : IN std_logic;
        bypass       : IN std_logic;
        ctrl_delay   : IN std_logic_vector(15 DOWNTO 0);
        data_re_in   : IN std_logic;
        data_im_in   : IN std_logic;
        data_re_out  : OUT STD_LOGIC;
        data_im_out  : OUT STD_LOGIC
    );
END multiplier_mul1;

ARCHITECTURE Behavioral OF multiplier_mul1 IS

    COMPONENT Dff_regN IS
        GENERIC (N : INTEGER );
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC;
            QN   : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT shifter IS
        PORT (
            clk       : IN STD_LOGIC;
            rst       : IN STD_LOGIC;
            ce        : IN STD_LOGIC;
            ctrl      : IN STD_LOGIC;
            data_in   : IN std_logic;
            data_out  : OUT std_logic
        );
    END COMPONENT;

    SIGNAL shifter_re, shifter_im : STD_LOGIC;
    SIGNAL sel : std_logic;

BEGIN
    sel <= ctrl_delay(ctrl_start) AND bypass;

    UDELAY_RE : Dff_regN
    GENERIC MAP(N => 15)
    PORT MAP(
        D    => data_re_in, 
        clk  => clk, 
        Q    => shifter_re
    );
    UDELAY_IM : Dff_regN
    GENERIC MAP(N => 15)
    PORT MAP(
        D    => data_im_in, 
        clk  => clk, 
        Q    => shifter_im
    );
    USHIFTER_RE : shifter
    PORT MAP(
        clk       => clk, 
        rst       => rst, 
        ce        => ce, 
        ctrl      => sel, 
        data_in   => shifter_re, 
        data_out  => data_re_out
    );
    USHIFTER_IM : shifter
    PORT MAP(
        clk       => clk, 
        rst       => rst, 
        ce        => ce, 
        ctrl      => sel, 
        data_in   => shifter_im, 
        data_out  => data_im_out
    );

END Behavioral;
