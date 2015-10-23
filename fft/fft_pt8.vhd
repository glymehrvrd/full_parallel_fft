LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fft_pt8 IS
    PORT (
        clk          : IN STD_LOGIC;
        rst          : IN STD_LOGIC;
        ce           : IN STD_LOGIC;
        ctrl         : IN STD_LOGIC;

        data_re_in   : IN std_logic_vector(7 DOWNTO 0);
        data_im_in   : IN std_logic_vector(7 DOWNTO 0);

        data_re_out  : OUT std_logic_vector(7 DOWNTO 0);
        data_im_out  : OUT std_logic_vector(7 DOWNTO 0)
    );
END fft_pt8;

ARCHITECTURE Behavioral OF fft_pt8 IS

    COMPONENT fft_pt2 IS
        PORT (
            clk          : IN STD_LOGIC;
            rst          : IN STD_LOGIC;
            ce           : IN STD_LOGIC;
            ctrl         : IN STD_LOGIC;

            data_re_in   : IN std_logic_vector(1 DOWNTO 0);
            data_im_in   : IN std_logic_vector(1 DOWNTO 0);

            data_re_out  : OUT std_logic_vector(1 DOWNTO 0);
            data_im_out  : OUT std_logic_vector(1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT fft_pt4 IS
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
    END COMPONENT;

    SIGNAL first_stage_re_out, first_stage_im_out : std_logic_vector(7 DOWNTO 0);

    TYPE array2_3 IS ARRAY (1 DOWNTO 0) OF std_logic_vector(3 DOWNTO 0);
    SIGNAL stage_1_re_in, stage_1_im_in : array2_3;

BEGIN
    stage_1_re_in(0) <= (data_re_in(6), data_re_in(4), data_re_in(2), data_re_in(0));
    stage_1_im_in(0) <= (data_im_in(6), data_im_in(4), data_im_in(2), data_im_in(0));
    stage_1_re_in(1) <= (data_re_in(7), data_re_in(5), data_re_in(3), data_re_in(1));
    stage_1_im_in(1) <= (data_im_in(7), data_im_in(5), data_im_in(3), data_im_in(1));

    UFFT_4pt0 : fft_pt4
    PORT MAP(
        clk          => clk, 
        rst          => rst, 
        ce           => ce, 
        ctrl         => ctrl, 
        data_re_in   => stage_1_re_in(0), 
        data_im_in   => stage_1_im_in(0), 
        data_re_out  => first_stage_re_out(3 DOWNTO 0), 
        data_im_out  => first_stage_im_out(3 DOWNTO 0)
    );

    UFFT_4pt1 : fft_pt4
    PORT MAP(
        clk          => clk, 
        rst          => rst, 
        ce           => ce, 
        ctrl         => ctrl, 
        data_re_in   => stage_1_re_in(1), 
        data_im_in   => stage_1_im_in(1), 
        data_re_out  => first_stage_re_out(7 DOWNTO 4), 
        data_im_out  => first_stage_im_out(7 DOWNTO 4)
    );

    UFFT_2pt0 : fft_pt2
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl           => ctrl, 
        data_re_in(0)  => first_stage_re_out(0), 
        data_re_in(1)  => first_stage_re_out(4), 
        data_im_in(0)  => first_stage_im_out(0), 
        data_im_in(1)  => first_stage_im_out(4), 
        data_re_out    => data_re_out(1 DOWNTO 0), 
        data_im_out    => data_im_out(1 DOWNTO 0)
    );

    UFFT_2pt1 : fft_pt2
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl           => ctrl, 
        data_re_in(0)  => first_stage_re_out(1), 
        data_re_in(1)  => first_stage_re_out(5), 
        data_im_in(0)  => first_stage_im_out(1), 
        data_im_in(1)  => first_stage_im_out(5), 
        data_re_out    => data_re_out(3 DOWNTO 2), 
        data_im_out    => data_im_out(3 DOWNTO 2)
    );

    UFFT_2pt2 : fft_pt2
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl           => ctrl, 
        data_re_in(0)  => first_stage_re_out(2), 
        data_re_in(1)  => first_stage_re_out(6), 
        data_im_in(0)  => first_stage_im_out(2), 
        data_im_in(1)  => first_stage_im_out(6), 
        data_re_out    => data_re_out(5 DOWNTO 4), 
        data_im_out    => data_im_out(5 DOWNTO 4)
    );

    UFFT_2pt3 : fft_pt2
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl           => ctrl, 
        data_re_in(0)  => first_stage_re_out(3), 
        data_re_in(1)  => first_stage_re_out(7), 
        data_im_in(0)  => first_stage_im_out(3), 
        data_im_in(1)  => first_stage_im_out(7), 
        data_re_out    => data_re_out(7 DOWNTO 6), 
        data_im_out    => data_im_out(7 DOWNTO 6)
    );
END Behavioral;

