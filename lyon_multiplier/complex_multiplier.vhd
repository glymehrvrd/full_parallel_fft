LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY complex_multiplier IS
    GENERIC (
        re_multiplicator : INTEGER := - 15000;
        im_multiplicator : INTEGER := 17000;
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk             : IN std_logic;
        rst             : IN std_logic;
        ce              : IN std_logic;
        ctrl_delay      : IN std_logic_vector(15 DOWNTO 0);
        data_re_in      : IN std_logic;
        data_im_in      : IN std_logic;
        product_re_out  : OUT STD_LOGIC;
        product_im_out  : OUT STD_LOGIC
    );
END complex_multiplier;

ARCHITECTURE Behavioral OF complex_multiplier IS

    COMPONENT lyon_multiplier IS
        GENERIC (
            multiplicator   : INTEGER;
            ctrl_start      : INTEGER
        );
        PORT (
            clk          : IN std_logic;
            rst          : IN std_logic;
            ce           : IN std_logic;
            ctrl_delay   : IN std_logic_vector(15 DOWNTO 0);
            data_in      : IN std_logic;
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

    SIGNAL acd, bcd, dab, ab : std_logic;
    SIGNAL not_b : std_logic;

    SIGNAL c : std_logic_vector(2 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(2 DOWNTO 0);

BEGIN
    --- (a+b*i)*(c+d*i) = (a*c - b*d) + (b*c + a*d)*i = x + y*i
    --- x = a(c-d)+d(a-b)
    --- y = b(c+d)+d(a-b)

    not_b <= NOT data_im_in;

    --- calculate a(c-d)
    UMUL0 : lyon_multiplier
    GENERIC MAP(
        multiplicator => re_multiplicator - im_multiplicator, 
        ctrl_start => ctrl_start MOD 16
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl_delay     => ctrl_delay, 
        data_in        => data_re_in, 
        product_out    => acd
    );

    --- calculate b(c+d)
    UMUL1 : lyon_multiplier
    GENERIC MAP(
        multiplicator  => re_multiplicator + im_multiplicator, 
        ctrl_start     => ctrl_start MOD 16
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl_delay     => ctrl_delay, 
        data_in        => data_im_in, 
        product_out    => bcd
    );

    --- calculate d(a-b)
    UMUL2 : lyon_multiplier
    GENERIC MAP(
        multiplicator  => im_multiplicator, 
        ctrl_start     => ctrl_start MOD 16
    )
    PORT MAP(
        clk          => clk, 
        rst          => rst, 
        ce           => ce, 
        ctrl_delay   => ctrl_delay, 
        data_in      => ab, 
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

END Behavioral;
