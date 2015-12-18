LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY fft_pt4 IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out  : OUT std_logic_vector(3 DOWNTO 0);
        tmp_mul_re_out, tmp_mul_im_out                  : OUT std_logic_vector(3 DOWNTO 0);

        clk                                             : IN STD_LOGIC;
        rst                                             : IN STD_LOGIC;
        ce                                              : IN STD_LOGIC;
        bypass                                          : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ctrl_delay                                      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in                                      : IN std_logic_vector(3 DOWNTO 0);
        data_im_in                                      : IN std_logic_vector(3 DOWNTO 0);

        data_re_out                                     : OUT std_logic_vector(3 DOWNTO 0);
        data_im_out                                     : OUT std_logic_vector(3 DOWNTO 0)
    );
END fft_pt4;

ARCHITECTURE Behavioral OF fft_pt4 IS

    COMPONENT Dff_preload_reg1_init_1 IS
        PORT (
            D           : IN STD_LOGIC;
            clk         : IN STD_LOGIC;
            preload     : IN STD_LOGIC;
            Q           : OUT STD_LOGIC;
            QN          : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT fft_pt2 IS
        GENERIC (
            ctrl_start  : INTEGER
        );
        PORT (
            clk          : IN STD_LOGIC;
            rst          : IN STD_LOGIC;
            ce           : IN STD_LOGIC;
            bypass       : IN std_logic;
            ctrl_delay   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            data_re_in   : IN std_logic_vector(1 DOWNTO 0);
            data_im_in   : IN std_logic_vector(1 DOWNTO 0);

            data_re_out  : OUT std_logic_vector(1 DOWNTO 0);
            data_im_out  : OUT std_logic_vector(1 DOWNTO 0)
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

    SIGNAL first_stage_re_out, first_stage_im_out : std_logic_vector(3 DOWNTO 0);
    SIGNAL mul_re_out, mul_im_out : std_logic_vector(3 DOWNTO 0);

    SIGNAL not_first_stage_re_out : std_logic;
    SIGNAL c : std_logic;
    SIGNAL c_buff : std_logic;
    SIGNAL opp_first_stage_re_out : std_logic;

BEGIN
    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;

    --- left-hand-side processors
    ULFFT_PT2_0 : fft_pt2
    GENERIC MAP(
        ctrl_start => ctrl_start
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        bypass         => bypass(1), 
        ctrl_delay     => ctrl_delay, 
        data_re_in(0)  => data_re_in(0), 
        data_re_in(1)  => data_re_in(2), 
        data_im_in(0)  => data_im_in(0), 
        data_im_in(1)  => data_im_in(2), 
        data_re_out    => first_stage_re_out(1 DOWNTO 0), 
        data_im_out    => first_stage_im_out(1 DOWNTO 0)
    );

    ULFFT_PT2_1 : fft_pt2
    GENERIC MAP(
        ctrl_start     => ctrl_start
    )
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        bypass         => bypass(1), 
        ctrl_delay     => ctrl_delay, 
        data_re_in(0)  => data_re_in(1), 
        data_re_in(1)  => data_re_in(3), 
        data_im_in(0)  => data_im_in(1), 
        data_im_in(1)  => data_im_in(3), 
        data_re_out    => first_stage_re_out(3 DOWNTO 2), 
        data_im_out    => first_stage_im_out(3 DOWNTO 2)
    );
    --- right-hand-side processors
    URFFT_PT2_0 : fft_pt2
    GENERIC MAP(
        ctrl_start     => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk             => clk, 
        rst             => rst, 
        ce              => ce, 
        bypass          => bypass(0), 
        ctrl_delay      => ctrl_delay, 
        data_re_in(0)   => mul_re_out(0), 
        data_re_in(1)   => mul_re_out(2), 
        data_im_in(0)   => mul_im_out(0), 
        data_im_in(1)   => mul_im_out(2), 
        data_re_out(0)  => data_re_out(0), 
        data_re_out(1)  => data_re_out(2), 
        data_im_out(0)  => data_im_out(0), 
        data_im_out(1)  => data_im_out(2)
    ); 

    URFFT_PT2_1 : fft_pt2
    GENERIC MAP(
        ctrl_start      => (ctrl_start + 1) MOD 16
    )
    PORT MAP(
        clk             => clk, 
        rst             => rst, 
        ce              => ce, 
        bypass          => bypass(0), 
        ctrl_delay      => ctrl_delay, 
        data_re_in(0)   => mul_re_out(1), 
        data_re_in(1)   => mul_re_out(3), 
        data_im_in(0)   => mul_im_out(1), 
        data_im_in(1)   => mul_im_out(3), 
        data_re_out(0)  => data_re_out(1), 
        data_re_out(1)  => data_re_out(3), 
        data_im_out(0)  => data_im_out(1), 
        data_im_out(1)  => data_im_out(3)
    ); 
    --- multipliers
    mul_re_out(2 DOWNTO 0) <= first_stage_re_out(2 DOWNTO 0);
    mul_im_out(2 DOWNTO 0) <= first_stage_im_out(2 DOWNTO 0);

    UMUX_RE : mux_in2
    PORT MAP(
        sel       => bypass(1), 
        data1_in  => first_stage_im_out(3), 
        data2_in  => first_stage_re_out(3), 
        data_out  => mul_re_out(3)
    );

    UMUX_IM : mux_in2
    PORT MAP(
        sel       => bypass(1), 
        data1_in  => opp_first_stage_re_out, 
        data2_in  => first_stage_im_out(3), 
        data_out  => mul_im_out(3)
    );
 
    not_first_stage_re_out <= NOT first_stage_re_out(3);
    C_BUFF_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c, 
        clk      => clk, 
        preload  => ctrl_delay((ctrl_start + 1) MOD 16), 
        Q        => c_buff
    );
    ADDER_3 : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff, 
        data2_in  => not_first_stage_re_out, 
        sum_out   => opp_first_stage_re_out, 
        c_out     => c
    );

END Behavioral;
