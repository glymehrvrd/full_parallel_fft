LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY complex_multiplier IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk             : IN std_logic;
        rst             : IN std_logic;
        ce              : IN std_logic;
        bypass          : in STD_LOGIC;
        ctrl_delay      : IN std_logic_vector(15 DOWNTO 0);
        data_re_in      : IN std_logic;
        data_im_in      : IN std_logic;
        re_multiplicator: IN std_logic_vector(15 DOWNTO 0);
        im_multiplicator: IN std_logic_vector(15 DOWNTO 0);
        data_re_out  : OUT STD_LOGIC;
        data_im_out  : OUT STD_LOGIC
    );
END complex_multiplier;

ARCHITECTURE Behavioral OF complex_multiplier IS

    COMPONENT lyon_multiplier IS
        GENERIC (
            ctrl_start      : INTEGER
        );
        PORT (
            clk          : IN std_logic;
            rst          : IN std_logic;
            ce           : IN std_logic;
            bypass       : in STD_LOGIC;
            ctrl_delay   : IN std_logic_vector(15 DOWNTO 0);
            data_in      : IN std_logic;
            multiplicator: IN std_logic_vector(15 DOWNTO 0);
            product_out  : OUT STD_LOGIC
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

    SIGNAL acd, bcd, dab, ab : std_logic;
    SIGNAL not_b : std_logic;

    SIGNAL c : std_logic_vector(2 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(2 DOWNTO 0);

    signal product_re_out: std_logic;
    signal product_im_out: std_logic;

    signal c_plus_d  : std_logic_vector(15 downto 0);
    signal c_minus_d : std_logic_vector(15 downto 0);

BEGIN
    --- (a+b*i)*(c+d*i) = (a*c - b*d) + (b*c + a*d)*i = x + y*i
    --- x = a(c-d)+d(a-b)
    --- y = b(c+d)+d(a-b)

    not_b <= NOT data_im_in;
    c_plus_d <= std_logic_vector(signed(re_multiplicator) + signed(im_multiplicator));
    c_minus_d <= std_logic_vector(signed(re_multiplicator) - signed(im_multiplicator));

    --- calculate a(c-d)
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
        multiplicator  => c_minus_d,
        product_out    => acd
    );

    --- calculate b(c+d)
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
        multiplicator  => c_plus_d,
        product_out    => bcd
    );

    --- calculate d(a-b)
    UMUL2 : lyon_multiplier
    GENERIC MAP(
        ctrl_start     => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk          => clk, 
        rst          => rst, 
        ce           => ce, 
        bypass       => bypass,
        ctrl_delay   => ctrl_delay, 
        data_in      => ab, 
        multiplicator  => im_multiplicator, 
        product_out  => dab
    );

    --- a-b
    C_BUFF_AB : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(0), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(0)
    );

    ADDER_AB : adder_bit1
    PORT MAP(
        data1_in  => data_re_in, 
        data2_in  => not_b, 
        c_in      => c_buff(0), 
        sum_out   => ab, 
        c_out     => c(0)
    );

    --- x = a(c-d)+d(a-b)
    C_BUFF_RE : Dff_preload_reg1
    PORT MAP(
        D        => c(1), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(1)
    );

    ADDER_RE : adder_bit1
    PORT MAP(
        data1_in  => acd, 
        data2_in  => dab, 
        c_in      => c_buff(1), 
        sum_out   => product_re_out, 
        c_out     => c(1)
    );

    UMUX_RE: mux_in2
    port map(
        sel=>bypass,
        data1_in=>product_re_out,
        data2_in=>acd,
        data_out=>data_re_out
    );
    --- y = b(c+d)+d(a-b)
    C_BUFF_IM : Dff_preload_reg1
    PORT MAP(
        D        => c(2), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(2)
    );

    ADDER_IM : adder_bit1
    PORT MAP(
        data1_in  => bcd, 
        data2_in  => dab, 
        c_in      => c_buff(2), 
        sum_out   => product_im_out, 
        c_out     => c(2)
    );

    UMUX_IM: mux_in2
    port map(
        sel=>bypass,
        data1_in=>product_im_out,
        data2_in=>bcd,
        data_out=>data_im_out
    );

END Behavioral;
