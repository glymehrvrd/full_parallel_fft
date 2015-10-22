LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fft_pt2 IS
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in     : in std_logic_vector(1 downto 0);
        data_im_in     : in std_logic_vector(1 downto 0);

        data_re_out     : out std_logic_vector(1 downto 0);
        data_im_out     : out std_logic_vector(1 downto 0)
    );
END fft_pt2;

ARCHITECTURE Behavioral OF fft_pt2 IS

    COMPONENT adder_bit1 IS
        PORT (
            data1_in    : IN STD_LOGIC;
            data2_in    : IN STD_LOGIC;
            c_in     : IN STD_LOGIC;
            sum_out  : OUT STD_LOGIC;
            c_out    : OUT STD_LOGIC
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

    SIGNAL c : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(3 DOWNTO 0);

    signal not_data_re_in:std_logic_vector(1 downto 0);
    signal not_data_im_in:std_logic_vector(1 downto 0);

    signal data_re_out_buff : std_logic_vector(1 downto 0);
    signal data_im_out_buff : std_logic_vector(1 downto 0);

BEGIN
    not_data_re_in<=not data_re_in;
    not_data_im_in<=not data_im_in;

    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                data_re_out<=(others=>'0');
                data_im_out<=(others=>'0');
            ELSIF ce = '1' THEN
                data_re_out<=data_re_out_buff;
                data_im_out<=data_im_out_buff;
            END IF;
        END IF;
    END PROCESS;

    --- Re(X[0])=Re(x[0])+Re(x[1])
    C_BUFF0_RE : Dff_preload_reg1
    PORT MAP(
        D        => c(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(0)
    );

    ADDER0_RE : adder_bit1
    PORT MAP(
        data1_in    => data_re_in(0), 
        data2_in    => data_re_in(1), 
        c_in     => c_buff(0), 
        sum_out  => data_re_out_buff(0), 
        c_out    => c(0)
    );

    --- Im(X[0])=Im(x[0])+Im(x[1])
    C_BUFF0_IM : Dff_preload_reg1
    PORT MAP(
        D        => c(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(1)
    );

    ADDER0_IM : adder_bit1
    PORT MAP(
        data1_in    => data_im_in(0), 
        data2_in    => data_im_in(1), 
        c_in     => c_buff(1), 
        sum_out  => data_im_out_buff(0), 
        c_out    => c(1)
    );

    --- Re(X[1])=Re(x[0])-Re(x[1])
    C_BUFF1_RE : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(2)
    );

    ADDER1_RE : adder_bit1
    PORT MAP(
        data1_in    => data_re_in(0), 
        data2_in    => not_data_re_in(1), 
        c_in     => c_buff(2), 
        sum_out  => data_re_out_buff(1), 
        c_out    => c(2)
    );

    --- Im(X[1])=Im(x[0])-Im(x[1])
    C_BUFF1_IM : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(3)
    );

    ADDER1_IM : adder_bit1
    PORT MAP(
        data1_in    => data_im_in(0), 
        data2_in    => not_data_im_in(1), 
        c_in     => c_buff(3), 
        sum_out  => data_im_out_buff(1), 
        c_out    => c(3)
    );
END Behavioral;

