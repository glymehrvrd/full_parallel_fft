LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY multiplier_mulminusj IS
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
END multiplier_mulminusj;

ARCHITECTURE Behavioral OF multiplier_mulminusj IS

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

    COMPONENT Dff_preload_reg1_init_1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC;
            QN       : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT adder_half_bit1
        PORT (
            data1_in  : IN STD_LOGIC;
            data2_in  : IN STD_LOGIC;
            sum_out   : OUT STD_LOGIC;
            c_out     : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mux_in2 IS
        PORT (
            sel       : IN STD_LOGIC;

            data1_in  : IN STD_LOGIC;
            data2_in  : IN std_logic;
            data_out  : OUT std_logic
        );
    END COMPONENT;

    SIGNAL not_data_re_in : STD_LOGIC;
    SIGNAL opp_data_re_in : STD_LOGIC;
    SIGNAL c, c_buff : STD_LOGIC;
    SIGNAL shifter_re, shifter_im : STD_LOGIC;
    SIGNAL delay_re_in, delay_im_in : std_logic;
    SIGNAL sel : std_logic;

BEGIN
    sel <= ctrl_delay(ctrl_start) AND bypass;

    not_data_re_in <= NOT data_re_in;
    UC_BUFF : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c, 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff
    );
    ADDER : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff, 
        data2_in  => not_data_re_in, 
        sum_out   => opp_data_re_in, 
        c_out     => c
    );

    UMUX_RE : mux_in2
    PORT MAP(
        sel       => bypass, 
        data1_in  => data_im_in, 
        data2_in  => data_re_in, 
        data_out  => delay_re_in
    );

    UMUX_IM : mux_in2
    PORT MAP(
        sel       => bypass, 
        data1_in  => opp_data_re_in, 
        data2_in  => data_im_in, 
        data_out  => delay_im_in
    );

    UDELAY_RE : Dff_regN
    GENERIC MAP(N => 15)
    PORT MAP(
        D    => delay_re_in, 
        clk  => clk, 
        Q    => shifter_re
    );
    UDELAY_IM : Dff_regN
    GENERIC MAP(N => 15)
    PORT MAP(
        D    => delay_im_in, 
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
