LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY complex_multiplier IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk               : IN std_logic;
        rst               : IN std_logic;
        ce                : IN std_logic;
        bypass            : IN STD_LOGIC;
        ctrl_delay        : IN std_logic_vector(15 DOWNTO 0);
        data_re_in        : IN std_logic;
        data_im_in        : IN std_logic;
        re_multiplicator  : IN std_logic_vector(15 DOWNTO 0);
        im_multiplicator  : IN std_logic_vector(15 DOWNTO 0);
        data_re_out       : OUT STD_LOGIC;
        data_im_out       : OUT STD_LOGIC
    );
END complex_multiplier;

ARCHITECTURE Behavioral OF complex_multiplier IS

    COMPONENT lyon_multiplier IS
        GENERIC (
            ctrl_start        : INTEGER
        );
        PORT (
            clk            : IN std_logic;
            rst            : IN std_logic;
            ce             : IN std_logic;
            bypass         : IN STD_LOGIC;
            ctrl_delay     : IN std_logic_vector(15 DOWNTO 0);
            data_in        : IN std_logic;
            multiplicator  : IN std_logic_vector(15 DOWNTO 0);
            product_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT adder_bit1 IS
        PORT (
            data1_in  : IN STD_LOGIC;
            data2_in  : IN STD_LOGIC;
            c_in      : IN STD_LOGIC;
            sum_out   : OUT STD_LOGIC;
            c_out     : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_preload_reg1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            preload  : IN STD_LOGIC; --- active low
            Q        : OUT STD_LOGIC;
            QN       : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_preload_reg1_init_1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            preload  : IN STD_LOGIC; --- active low
            Q        : OUT STD_LOGIC;
            QN       : OUT STD_LOGIC
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

    SIGNAL ac, bd, bc, ad : std_logic;
    SIGNAL not_bd : std_logic;

    SIGNAL c : std_logic_vector(1 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(1 DOWNTO 0);

    SIGNAL product_re_out : std_logic;
    SIGNAL product_im_out : std_logic;

BEGIN
    --- (a+b*i)*(c+d*i) = (a*c - b*d) + (b*c + a*d)*i = x + y*i
    --- x = a*c - b*d
    --- y = b*c + a*d

    --- calculate a*c
    UMUL0 : lyon_multiplier
    GENERIC MAP(
        ctrl_start => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        bypass         => bypass, 
        ctrl_delay     => ctrl_delay, 
        data_in        => data_re_in, 
        multiplicator  => re_multiplicator, 
        product_out    => ac
    );

    --- calculate b*d
    UMUL1 : lyon_multiplier
    GENERIC MAP(
        ctrl_start     => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        bypass         => bypass, 
        ctrl_delay     => ctrl_delay, 
        data_in        => data_im_in, 
        multiplicator  => im_multiplicator, 
        product_out    => bd
    );

    --- calculate b*c
    UMUL2 : lyon_multiplier
    GENERIC MAP(
        ctrl_start     => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        bypass         => bypass, 
        ctrl_delay     => ctrl_delay, 
        data_in        => data_im_in, 
        multiplicator  => re_multiplicator, 
        product_out    => bc
    );

    --- calculate a*d
    UMUL3 : lyon_multiplier
    GENERIC MAP(
        ctrl_start     => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        bypass         => bypass, 
        ctrl_delay     => ctrl_delay, 
        data_in        => data_re_in, 
        multiplicator  => im_multiplicator, 
        product_out    => ad
    );

    --- x=ac-bd
    not_bd <= NOT bd;
    C_BUFF_ACBD : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(0), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(0)
    );

    ADDER_ACBD : adder_bit1
    PORT MAP(
        data1_in  => ac, 
        data2_in  => not_bd, 
        c_in      => c_buff(0), 
        sum_out   => product_re_out, 
        c_out     => c(0)
    );

    --- y=bc+ad
    C_BUFF_RE : Dff_preload_reg1
    PORT MAP(
        D        => c(1), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(1)
    );

    ADDER_RE : adder_bit1
    PORT MAP(
        data1_in  => bc, 
        data2_in  => ad, 
        c_in      => c_buff(1), 
        sum_out   => product_im_out, 
        c_out     => c(1)
    );

    --- bypass selector
    UMUX_RE : mux_in2
    PORT MAP(
        sel       => bypass, 
        data1_in  => product_re_out, 
        data2_in  => ac, 
        data_out  => data_re_out
    );

    UMUX_IM : mux_in2
    PORT MAP(
        sel       => bypass, 
        data1_in  => product_im_out, 
        data2_in  => bd, 
        data_out  => data_im_out
    );

END Behavioral;
