LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fft_pt4 IS
    PORT (
        clk          : IN STD_LOGIC;
        rst          : IN STD_LOGIC;
        ce           : IN STD_LOGIC;
        ctrl         : IN STD_LOGIC;

        data_re_in   : IN std_logic_vector(3 DOWNTO 0);
        data_im_in   : IN std_logic_vector(3 DOWNTO 0);

        data_re_out  : OUT std_logic_vector(3 DOWNTO 0);
        data_im_out  : OUT std_logic_vector(3 DOWNTO 0)
    );
END fft_pt4;

ARCHITECTURE Behavioral OF fft_pt4 IS

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
            rst      : IN STD_LOGIC;
            ce       : IN STD_LOGIC;
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_preload_reg1_init_1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            rst      : IN STD_LOGIC;
            ce       : IN STD_LOGIC;
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL c_re_0 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_re_0 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_re_0 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_im_0 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_im_0 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_im_0 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_re_1 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_re_1 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_re_1 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_im_1 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_im_1 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_im_1 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_re_2 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_re_2 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_re_2 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_im_2 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_im_2 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_im_2 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_re_3 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_re_3 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_re_3 : std_logic_vector(2 DOWNTO 0);

    SIGNAL c_im_3 : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff_im_3 : std_logic_vector(3 DOWNTO 0);
    SIGNAL s_im_3 : std_logic_vector(2 DOWNTO 0);

    SIGNAL not_data_re_in : std_logic_vector(3 DOWNTO 0);
    SIGNAL not_data_im_in : std_logic_vector(3 DOWNTO 0);

    SIGNAL data_re_out_buff : std_logic_vector(3 DOWNTO 0);
    SIGNAL data_im_out_buff : std_logic_vector(3 DOWNTO 0);

BEGIN
    not_data_re_in <= NOT data_re_in;
    not_data_im_in <= NOT data_im_in;

    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                data_re_out <= (OTHERS => '0');
                data_im_out <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                data_re_out <= data_re_out_buff;
                data_im_out <= data_im_out_buff;
            END IF;
        END IF;
    END PROCESS;

    --- Re(X[0])=Re(x[0])+Re(x[1])+Re(x[2])+Re(x[3])
    C_BUFF0_RE_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_0(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_0(0)
    );
    ADDER0_RE_0 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_re_in(0), 
        c_in      => c_buff_re_0(0), 
        sum_out   => s_re_0(0), 
        c_out     => c_re_0(0)
    );

    C_BUFF1_RE_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_0(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_0(1)
    );
    ADDER1_RE_0 : adder_bit1
    PORT MAP(
        data1_in  => s_re_0(0), 
        data2_in  => data_re_in(1), 
        c_in      => c_buff_re_0(1), 
        sum_out   => s_re_0(1), 
        c_out     => c_re_0(1)
    );

    C_BUFF2_RE_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_0(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_0(2)
    );
    ADDER2_RE_0 : adder_bit1
    PORT MAP(
        data1_in  => s_re_0(1), 
        data2_in  => data_re_in(2), 
        c_in      => c_buff_re_0(2), 
        sum_out   => s_re_0(2), 
        c_out     => c_re_0(2)
    );

    C_BUFF3_RE_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_0(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_0(3)
    );
    ADDER3_RE_0 : adder_bit1
    PORT MAP(
        data1_in  => s_re_0(2), 
        data2_in  => data_re_in(3), 
        c_in      => c_buff_re_0(3), 
        sum_out   => data_re_out_buff(0), 
        c_out     => c_re_0(3)
    );

    --- Im(X[0])=Im(x[0])+Im(x[1])+Im(x[2])+Im(x[3])
    C_BUFF0_IM_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_0(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_0(0)
    );
    ADDER0_IM_0 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_im_in(0), 
        c_in      => c_buff_im_0(0), 
        sum_out   => s_im_0(0), 
        c_out     => c_im_0(0)
    );

    C_BUFF1_IM_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_0(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_0(1)
    );
    ADDER1_IM_0 : adder_bit1
    PORT MAP(
        data1_in  => s_im_0(0), 
        data2_in  => data_im_in(1), 
        c_in      => c_buff_im_0(1), 
        sum_out   => s_im_0(1), 
        c_out     => c_im_0(1)
    );

    C_BUFF2_IM_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_0(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_0(2)
    );
    ADDER2_IM_0 : adder_bit1
    PORT MAP(
        data1_in  => s_im_0(1), 
        data2_in  => data_im_in(2), 
        c_in      => c_buff_im_0(2), 
        sum_out   => s_im_0(2), 
        c_out     => c_im_0(2)
    );

    C_BUFF3_IM_0 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_0(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_0(3)
    );
    ADDER3_IM_0 : adder_bit1
    PORT MAP(
        data1_in  => s_im_0(2), 
        data2_in  => data_im_in(3), 
        c_in      => c_buff_im_0(3), 
        sum_out   => data_im_out_buff(0), 
        c_out     => c_im_0(3)
    );

    --- Re(X[1])=Re(x[0])+Im(x[1])-Re(x[2])-Im(x[3])
    C_BUFF0_RE_1 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_1(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_1(0)
    );
    ADDER0_RE_1 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_re_in(0), 
        c_in      => c_buff_re_1(0), 
        sum_out   => s_re_1(0), 
        c_out     => c_re_1(0)
    );

    C_BUFF1_RE_1 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_1(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_1(1)
    );
    ADDER1_RE_1 : adder_bit1
    PORT MAP(
        data1_in  => s_re_1(0), 
        data2_in  => data_im_in(1), 
        c_in      => c_buff_re_1(1), 
        sum_out   => s_re_1(1), 
        c_out     => c_re_1(1)
    );

    C_BUFF2_RE_1 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_re_1(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_1(2)
    );
    ADDER2_RE_1 : adder_bit1
    PORT MAP(
        data1_in  => s_re_1(1), 
        data2_in  => not_data_re_in(2), 
        c_in      => c_buff_re_1(2), 
        sum_out   => s_re_1(2), 
        c_out     => c_re_1(2)
    );

    C_BUFF3_RE_1 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_re_1(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_1(3)
    );
    ADDER3_RE_1 : adder_bit1
    PORT MAP(
        data1_in  => s_re_1(2), 
        data2_in  => not_data_im_in(3), 
        c_in      => c_buff_re_1(3), 
        sum_out   => data_re_out_buff(1), 
        c_out     => c_re_1(3)
    );

    --- Im(X[1])=Im(x[0])-Re(x[1])-Im(x[2])+Re(x[3])
    C_BUFF0_IM_1 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_1(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_1(0)
    );
    ADDER0_IM_1 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_im_in(0), 
        c_in      => c_buff_im_1(0), 
        sum_out   => s_im_1(0), 
        c_out     => c_im_1(0)
    );

    C_BUFF1_IM_1 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_im_1(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_1(1)
    );
    ADDER1_IM_1 : adder_bit1
    PORT MAP(
        data1_in  => s_im_1(0), 
        data2_in  => not_data_re_in(1), 
        c_in      => c_buff_im_1(1), 
        sum_out   => s_im_1(1), 
        c_out     => c_im_1(1)
    );

    C_BUFF2_IM_1 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_im_1(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_1(2)
    );
    ADDER2_IM_1 : adder_bit1
    PORT MAP(
        data1_in  => s_im_1(1), 
        data2_in  => not_data_im_in(2), 
        c_in      => c_buff_im_1(2), 
        sum_out   => s_im_1(2), 
        c_out     => c_im_1(2)
    );

    C_BUFF3_IM_1 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_1(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_1(3)
    );
    ADDER3_IM_1 : adder_bit1
    PORT MAP(
        data1_in  => s_im_1(2), 
        data2_in  => data_re_in(3), 
        c_in      => c_buff_im_1(3), 
        sum_out   => data_im_out_buff(1), 
        c_out     => c_im_1(3)
    );

    --- Re(X[2])=Re(x[0])-Re(x[1])+Re(x[2])-Re(x[3])
    C_BUFF0_RE_2 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_2(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_2(0)
    );
    ADDER0_RE_2 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_re_in(0), 
        c_in      => c_buff_re_2(0), 
        sum_out   => s_re_2(0), 
        c_out     => c_re_2(0)
    );

    C_BUFF1_RE_2 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_re_2(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_2(1)
    );
    ADDER1_RE_2 : adder_bit1
    PORT MAP(
        data1_in  => s_re_2(0), 
        data2_in  => not_data_re_in(1), 
        c_in      => c_buff_re_2(1), 
        sum_out   => s_re_2(1), 
        c_out     => c_re_2(1)
    );

    C_BUFF2_RE_2 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_2(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_2(2)
    );
    ADDER2_RE_2 : adder_bit1
    PORT MAP(
        data1_in  => s_re_2(1), 
        data2_in  => data_re_in(2), 
        c_in      => c_buff_re_2(2), 
        sum_out   => s_re_2(2), 
        c_out     => c_re_2(2)
    );

    C_BUFF3_RE_2 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_re_2(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_2(3)
    );
    ADDER3_RE_2 : adder_bit1
    PORT MAP(
        data1_in  => s_re_2(2), 
        data2_in  => not_data_re_in(3), 
        c_in      => c_buff_re_2(3), 
        sum_out   => data_re_out_buff(2), 
        c_out     => c_re_2(3)
    );

    --- Im(X[2])=Im(x[0])-Im(x[1])+Im(x[2])-Im(x[3])
    C_BUFF0_IM_2 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_2(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_2(0)
    );
    ADDER0_IM_2 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_im_in(0), 
        c_in      => c_buff_im_2(0), 
        sum_out   => s_im_2(0), 
        c_out     => c_im_2(0)
    );

    C_BUFF1_IM_2 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_im_2(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_2(1)
    );
    ADDER1_IM_2 : adder_bit1
    PORT MAP(
        data1_in  => s_im_2(0), 
        data2_in  => not_data_im_in(1), 
        c_in      => c_buff_im_2(1), 
        sum_out   => s_im_2(1), 
        c_out     => c_im_2(1)
    );

    C_BUFF2_IM_2 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_2(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_2(2)
    );
    ADDER2_IM_2 : adder_bit1
    PORT MAP(
        data1_in  => s_im_2(1), 
        data2_in  => data_im_in(2), 
        c_in      => c_buff_im_2(2), 
        sum_out   => s_im_2(2), 
        c_out     => c_im_2(2)
    );

    C_BUFF3_IM_2 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_im_2(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_2(3)
    );
    ADDER3_IM_2 : adder_bit1
    PORT MAP(
        data1_in  => s_im_2(2), 
        data2_in  => not_data_im_in(3), 
        c_in      => c_buff_im_2(3), 
        sum_out   => data_im_out_buff(2), 
        c_out     => c_im_2(3)
    );

    --- Re(X[3])=Re(x[0])-Im(x[1])-Re(x[2])+Im(x[3])
    C_BUFF0_RE_3 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_3(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_3(0)
    );
    ADDER0_RE_3 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_re_in(0), 
        c_in      => c_buff_re_3(0), 
        sum_out   => s_re_3(0), 
        c_out     => c_re_3(0)
    );

    C_BUFF1_RE_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_re_3(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_3(1)
    );
    ADDER1_RE_3 : adder_bit1
    PORT MAP(
        data1_in  => s_re_3(0), 
        data2_in  => not_data_im_in(1), 
        c_in      => c_buff_re_3(1), 
        sum_out   => s_re_3(1), 
        c_out     => c_re_3(1)
    );

    C_BUFF2_RE_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_re_3(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_3(2)
    );
    ADDER2_RE_3 : adder_bit1
    PORT MAP(
        data1_in  => s_re_3(1), 
        data2_in  => not_data_re_in(2), 
        c_in      => c_buff_re_3(2), 
        sum_out   => s_re_3(2), 
        c_out     => c_re_3(2)
    );

    C_BUFF3_RE_3 : Dff_preload_reg1
    PORT MAP(
        D        => c_re_3(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_re_3(3)
    );
    ADDER3_RE_3 : adder_bit1
    PORT MAP(
        data1_in  => s_re_3(2), 
        data2_in  => data_im_in(3), 
        c_in      => c_buff_re_3(3), 
        sum_out   => data_re_out_buff(3), 
        c_out     => c_re_3(3)
    );

    --- Im(X[3])=Im(x[0])+Re(X[1])-Im(x[2])-Re(X[3])
    C_BUFF0_IM_3 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_3(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_3(0)
    );
    ADDER0_IM_3 : adder_bit1
    PORT MAP(
        data1_in  => '0', 
        data2_in  => data_im_in(0), 
        c_in      => c_buff_im_3(0), 
        sum_out   => s_im_3(0), 
        c_out     => c_im_3(0)
    );

    C_BUFF1_IM_3 : Dff_preload_reg1
    PORT MAP(
        D        => c_im_3(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_3(1)
    );
    ADDER1_IM_3 : adder_bit1
    PORT MAP(
        data1_in  => s_im_3(0), 
        data2_in  => data_re_in(1), 
        c_in      => c_buff_im_3(1), 
        sum_out   => s_im_3(1), 
        c_out     => c_im_3(1)
    );

    C_BUFF2_IM_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_im_3(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_3(2)
    );
    ADDER2_IM_3 : adder_bit1
    PORT MAP(
        data1_in  => s_im_3(1), 
        data2_in  => not_data_im_in(2), 
        c_in      => c_buff_im_3(2), 
        sum_out   => s_im_3(2), 
        c_out     => c_im_3(2)
    );

    C_BUFF3_IM_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c_im_3(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff_im_3(3)
    );
    ADDER3_IM_3 : adder_bit1
    PORT MAP(
        data1_in  => s_im_3(2), 
        data2_in  => not_data_re_in(3), 
        c_in      => c_buff_im_3(3), 
        sum_out   => data_im_out_buff(3), 
        c_out     => c_im_3(3)
    );
END Behavioral;

