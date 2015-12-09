LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fft_pt2 IS
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk          : IN STD_LOGIC;
        rst          : IN STD_LOGIC;
        ce           : IN STD_LOGIC;
        bypass       : IN std_logic;
        ctrl_delay   : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in   : IN std_logic_vector(1 DOWNTO 0);
        data_im_in   : IN std_logic_vector(1 DOWNTO 0);

        data_re_out  : OUT std_logic_vector(1 DOWNTO 0);
        data_im_out  : OUT std_logic_vector(1 DOWNTO 0)
    );
END fft_pt2;

ARCHITECTURE Behavioral OF fft_pt2 IS

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
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC;
            QN       : OUT STD_LOGIC
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

    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC;
            QN   : OUT STD_LOGIC
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

    SIGNAL c : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(3 DOWNTO 0);

    SIGNAL not_data_re_in1 : std_logic;
    SIGNAL not_data_im_in1 : std_logic;

    SIGNAL data_re_out_buff : std_logic_vector(1 DOWNTO 0);
    SIGNAL data_im_out_buff : std_logic_vector(1 DOWNTO 0);

    SIGNAL data_re_out_nobypass : std_logic_vector(1 DOWNTO 0);
    SIGNAL data_im_out_nobypass : std_logic_vector(1 DOWNTO 0);
BEGIN
    GEN_OUT_MUX : for I in 0 to 1 generate
        UMUXRE : mux_in2
        port map(
            sel=>bypass,
            data1_in=>data_re_out_nobypass(I),
            data2_in=>data_re_in(I),
            data_out=>data_re_out(I)
        );

        UMUXIM : mux_in2
        port map(
            sel=>bypass,
            data1_in=>data_im_out_nobypass(I),
            data2_in=>data_im_in(I),
            data_out=>data_im_out(I)
        );
    end generate ; -- GEN_OUT_MUX

    not_data_re_in1 <= NOT data_re_in(1);
    not_data_im_in1 <= NOT data_im_in(1);

    GEN_OUT_BUFF : for I in 0 to 1 generate
        UDFF_RE_OUT : Dff_reg1 port map(
                D=>data_re_out_buff(I),
                clk=>clk,
                Q=>data_re_out_nobypass(I)
            );

        UDFF_IM_OUT : Dff_reg1 port map(
                D=>data_im_out_buff(I),
                clk=>clk,
                Q=>data_im_out_nobypass(I)
            );
    end generate ; -- GEN_OUT_BUFF


    --- Re(X[0])=Re(x[0])+Re(x[1])
    C_BUFF0_RE : Dff_preload_reg1
    PORT MAP(
        D        => c(0), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(0)
    );

    ADDER0_RE : adder_bit1
    PORT MAP(
        data1_in  => data_re_in(0), 
        data2_in  => data_re_in(1), 
        c_in      => c_buff(0), 
        sum_out   => data_re_out_buff(0), 
        c_out     => c(0)
    );

    --- Im(X[0])=Im(x[0])+Im(x[1])
    C_BUFF0_IM : Dff_preload_reg1
    PORT MAP(
        D        => c(1), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(1)
    );

    ADDER0_IM : adder_bit1
    PORT MAP(
        data1_in  => data_im_in(0), 
        data2_in  => data_im_in(1), 
        c_in      => c_buff(1), 
        sum_out   => data_im_out_buff(0), 
        c_out     => c(1)
    );

    --- Re(X[1])=Re(x[0])-Re(x[1])
    C_BUFF1_RE : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(2), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(2)
    );

    ADDER1_RE : adder_bit1
    PORT MAP(
        data1_in  => data_re_in(0), 
        data2_in  => not_data_re_in1, 
        c_in      => c_buff(2), 
        sum_out   => data_re_out_buff(1), 
        c_out     => c(2)
    );

    --- Im(X[1])=Im(x[0])-Im(x[1])
    C_BUFF1_IM : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(3), 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff(3)
    );

    ADDER1_IM : adder_bit1
    PORT MAP(
        data1_in  => data_im_in(0), 
        data2_in  => not_data_im_in1, 
        c_in      => c_buff(3), 
        sum_out   => data_im_out_buff(1), 
        c_out     => c(3)
    );
END Behavioral;

