library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt64 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        tmp_mul_re_out, tmp_mul_im_out : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in     : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        data_im_in     : IN STD_LOGIC_VECTOR(63 DOWNTO 0);

        data_re_out    : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        data_im_out    : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
end fft_pt64;

architecture Behavioral of fft_pt64 is

component fft_pt8 is
    GENERIC (
        ctrl_start     : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        data_im_in     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);

        data_re_out    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        data_im_out    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;


component complex_multiplier is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk              : IN STD_LOGIC;
        rst              : IN STD_LOGIC;
        ce               : IN STD_LOGIC;
        bypass           : IN STD_LOGIC;
        ctrl_delay       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_re_in       : IN STD_LOGIC;
        data_im_in       : IN STD_LOGIC;
        re_multiplicator : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        im_multiplicator : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_re_out      : OUT STD_LOGIC;
        data_im_out      : OUT STD_LOGIC
    );
end component;

component multiplier_mul1 IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk             : IN STD_LOGIC;
        rst             : IN STD_LOGIC;
        ce              : IN STD_LOGIC;
        bypass          : IN STD_LOGIC;
        ctrl_delay      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_re_in      : IN STD_LOGIC;
        data_im_in      : IN STD_LOGIC;
        data_re_out     : OUT STD_LOGIC;
        data_im_out     : OUT STD_LOGIC
    );
END component;

component multiplier_mulminusj IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk             : IN STD_LOGIC;
        rst             : IN STD_LOGIC;
        ce              : IN STD_LOGIC;
        bypass          : IN STD_LOGIC;
        ctrl_delay      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_re_in      : IN STD_LOGIC;
        data_im_in      : IN STD_LOGIC;
        data_re_out     : OUT STD_LOGIC;
        data_im_out     : OUT STD_LOGIC
    );
END component;

COMPONENT Dff_regN_Nout IS
    GENERIC (N : INTEGER);
    PORT (  
        D      : IN STD_LOGIC;
        clk    : IN STD_LOGIC;
        Q      : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        QN     : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END COMPONENT;

signal first_stage_re_out, first_stage_im_out: STD_LOGIC_VECTOR(63 DOWNTO 0);
signal mul_re_out, mul_im_out : STD_LOGIC_VECTOR(63 DOWNTO 0);


begin

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;
    tmp_mul_re_out <= mul_re_out;
    tmp_mul_im_out <= mul_im_out;

    --- left-hand-side processors
    ULFFT_PT8_0 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(0),
            data_re_in(1) => data_re_in(8),
            data_re_in(2) => data_re_in(16),
            data_re_in(3) => data_re_in(24),
            data_re_in(4) => data_re_in(32),
            data_re_in(5) => data_re_in(40),
            data_re_in(6) => data_re_in(48),
            data_re_in(7) => data_re_in(56),
            data_im_in(0) => data_im_in(0),
            data_im_in(1) => data_im_in(8),
            data_im_in(2) => data_im_in(16),
            data_im_in(3) => data_im_in(24),
            data_im_in(4) => data_im_in(32),
            data_im_in(5) => data_im_in(40),
            data_im_in(6) => data_im_in(48),
            data_im_in(7) => data_im_in(56),
            data_re_out(0) => first_stage_re_out(0),
            data_re_out(1) => first_stage_re_out(8),
            data_re_out(2) => first_stage_re_out(16),
            data_re_out(3) => first_stage_re_out(24),
            data_re_out(4) => first_stage_re_out(32),
            data_re_out(5) => first_stage_re_out(40),
            data_re_out(6) => first_stage_re_out(48),
            data_re_out(7) => first_stage_re_out(56),
            data_im_out(0) => first_stage_im_out(0),
            data_im_out(1) => first_stage_im_out(8),
            data_im_out(2) => first_stage_im_out(16),
            data_im_out(3) => first_stage_im_out(24),
            data_im_out(4) => first_stage_im_out(32),
            data_im_out(5) => first_stage_im_out(40),
            data_im_out(6) => first_stage_im_out(48),
            data_im_out(7) => first_stage_im_out(56)
        );

    ULFFT_PT8_1 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(1),
            data_re_in(1) => data_re_in(9),
            data_re_in(2) => data_re_in(17),
            data_re_in(3) => data_re_in(25),
            data_re_in(4) => data_re_in(33),
            data_re_in(5) => data_re_in(41),
            data_re_in(6) => data_re_in(49),
            data_re_in(7) => data_re_in(57),
            data_im_in(0) => data_im_in(1),
            data_im_in(1) => data_im_in(9),
            data_im_in(2) => data_im_in(17),
            data_im_in(3) => data_im_in(25),
            data_im_in(4) => data_im_in(33),
            data_im_in(5) => data_im_in(41),
            data_im_in(6) => data_im_in(49),
            data_im_in(7) => data_im_in(57),
            data_re_out(0) => first_stage_re_out(1),
            data_re_out(1) => first_stage_re_out(9),
            data_re_out(2) => first_stage_re_out(17),
            data_re_out(3) => first_stage_re_out(25),
            data_re_out(4) => first_stage_re_out(33),
            data_re_out(5) => first_stage_re_out(41),
            data_re_out(6) => first_stage_re_out(49),
            data_re_out(7) => first_stage_re_out(57),
            data_im_out(0) => first_stage_im_out(1),
            data_im_out(1) => first_stage_im_out(9),
            data_im_out(2) => first_stage_im_out(17),
            data_im_out(3) => first_stage_im_out(25),
            data_im_out(4) => first_stage_im_out(33),
            data_im_out(5) => first_stage_im_out(41),
            data_im_out(6) => first_stage_im_out(49),
            data_im_out(7) => first_stage_im_out(57)
        );

    ULFFT_PT8_2 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(2),
            data_re_in(1) => data_re_in(10),
            data_re_in(2) => data_re_in(18),
            data_re_in(3) => data_re_in(26),
            data_re_in(4) => data_re_in(34),
            data_re_in(5) => data_re_in(42),
            data_re_in(6) => data_re_in(50),
            data_re_in(7) => data_re_in(58),
            data_im_in(0) => data_im_in(2),
            data_im_in(1) => data_im_in(10),
            data_im_in(2) => data_im_in(18),
            data_im_in(3) => data_im_in(26),
            data_im_in(4) => data_im_in(34),
            data_im_in(5) => data_im_in(42),
            data_im_in(6) => data_im_in(50),
            data_im_in(7) => data_im_in(58),
            data_re_out(0) => first_stage_re_out(2),
            data_re_out(1) => first_stage_re_out(10),
            data_re_out(2) => first_stage_re_out(18),
            data_re_out(3) => first_stage_re_out(26),
            data_re_out(4) => first_stage_re_out(34),
            data_re_out(5) => first_stage_re_out(42),
            data_re_out(6) => first_stage_re_out(50),
            data_re_out(7) => first_stage_re_out(58),
            data_im_out(0) => first_stage_im_out(2),
            data_im_out(1) => first_stage_im_out(10),
            data_im_out(2) => first_stage_im_out(18),
            data_im_out(3) => first_stage_im_out(26),
            data_im_out(4) => first_stage_im_out(34),
            data_im_out(5) => first_stage_im_out(42),
            data_im_out(6) => first_stage_im_out(50),
            data_im_out(7) => first_stage_im_out(58)
        );

    ULFFT_PT8_3 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(3),
            data_re_in(1) => data_re_in(11),
            data_re_in(2) => data_re_in(19),
            data_re_in(3) => data_re_in(27),
            data_re_in(4) => data_re_in(35),
            data_re_in(5) => data_re_in(43),
            data_re_in(6) => data_re_in(51),
            data_re_in(7) => data_re_in(59),
            data_im_in(0) => data_im_in(3),
            data_im_in(1) => data_im_in(11),
            data_im_in(2) => data_im_in(19),
            data_im_in(3) => data_im_in(27),
            data_im_in(4) => data_im_in(35),
            data_im_in(5) => data_im_in(43),
            data_im_in(6) => data_im_in(51),
            data_im_in(7) => data_im_in(59),
            data_re_out(0) => first_stage_re_out(3),
            data_re_out(1) => first_stage_re_out(11),
            data_re_out(2) => first_stage_re_out(19),
            data_re_out(3) => first_stage_re_out(27),
            data_re_out(4) => first_stage_re_out(35),
            data_re_out(5) => first_stage_re_out(43),
            data_re_out(6) => first_stage_re_out(51),
            data_re_out(7) => first_stage_re_out(59),
            data_im_out(0) => first_stage_im_out(3),
            data_im_out(1) => first_stage_im_out(11),
            data_im_out(2) => first_stage_im_out(19),
            data_im_out(3) => first_stage_im_out(27),
            data_im_out(4) => first_stage_im_out(35),
            data_im_out(5) => first_stage_im_out(43),
            data_im_out(6) => first_stage_im_out(51),
            data_im_out(7) => first_stage_im_out(59)
        );

    ULFFT_PT8_4 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(4),
            data_re_in(1) => data_re_in(12),
            data_re_in(2) => data_re_in(20),
            data_re_in(3) => data_re_in(28),
            data_re_in(4) => data_re_in(36),
            data_re_in(5) => data_re_in(44),
            data_re_in(6) => data_re_in(52),
            data_re_in(7) => data_re_in(60),
            data_im_in(0) => data_im_in(4),
            data_im_in(1) => data_im_in(12),
            data_im_in(2) => data_im_in(20),
            data_im_in(3) => data_im_in(28),
            data_im_in(4) => data_im_in(36),
            data_im_in(5) => data_im_in(44),
            data_im_in(6) => data_im_in(52),
            data_im_in(7) => data_im_in(60),
            data_re_out(0) => first_stage_re_out(4),
            data_re_out(1) => first_stage_re_out(12),
            data_re_out(2) => first_stage_re_out(20),
            data_re_out(3) => first_stage_re_out(28),
            data_re_out(4) => first_stage_re_out(36),
            data_re_out(5) => first_stage_re_out(44),
            data_re_out(6) => first_stage_re_out(52),
            data_re_out(7) => first_stage_re_out(60),
            data_im_out(0) => first_stage_im_out(4),
            data_im_out(1) => first_stage_im_out(12),
            data_im_out(2) => first_stage_im_out(20),
            data_im_out(3) => first_stage_im_out(28),
            data_im_out(4) => first_stage_im_out(36),
            data_im_out(5) => first_stage_im_out(44),
            data_im_out(6) => first_stage_im_out(52),
            data_im_out(7) => first_stage_im_out(60)
        );

    ULFFT_PT8_5 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(5),
            data_re_in(1) => data_re_in(13),
            data_re_in(2) => data_re_in(21),
            data_re_in(3) => data_re_in(29),
            data_re_in(4) => data_re_in(37),
            data_re_in(5) => data_re_in(45),
            data_re_in(6) => data_re_in(53),
            data_re_in(7) => data_re_in(61),
            data_im_in(0) => data_im_in(5),
            data_im_in(1) => data_im_in(13),
            data_im_in(2) => data_im_in(21),
            data_im_in(3) => data_im_in(29),
            data_im_in(4) => data_im_in(37),
            data_im_in(5) => data_im_in(45),
            data_im_in(6) => data_im_in(53),
            data_im_in(7) => data_im_in(61),
            data_re_out(0) => first_stage_re_out(5),
            data_re_out(1) => first_stage_re_out(13),
            data_re_out(2) => first_stage_re_out(21),
            data_re_out(3) => first_stage_re_out(29),
            data_re_out(4) => first_stage_re_out(37),
            data_re_out(5) => first_stage_re_out(45),
            data_re_out(6) => first_stage_re_out(53),
            data_re_out(7) => first_stage_re_out(61),
            data_im_out(0) => first_stage_im_out(5),
            data_im_out(1) => first_stage_im_out(13),
            data_im_out(2) => first_stage_im_out(21),
            data_im_out(3) => first_stage_im_out(29),
            data_im_out(4) => first_stage_im_out(37),
            data_im_out(5) => first_stage_im_out(45),
            data_im_out(6) => first_stage_im_out(53),
            data_im_out(7) => first_stage_im_out(61)
        );

    ULFFT_PT8_6 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(6),
            data_re_in(1) => data_re_in(14),
            data_re_in(2) => data_re_in(22),
            data_re_in(3) => data_re_in(30),
            data_re_in(4) => data_re_in(38),
            data_re_in(5) => data_re_in(46),
            data_re_in(6) => data_re_in(54),
            data_re_in(7) => data_re_in(62),
            data_im_in(0) => data_im_in(6),
            data_im_in(1) => data_im_in(14),
            data_im_in(2) => data_im_in(22),
            data_im_in(3) => data_im_in(30),
            data_im_in(4) => data_im_in(38),
            data_im_in(5) => data_im_in(46),
            data_im_in(6) => data_im_in(54),
            data_im_in(7) => data_im_in(62),
            data_re_out(0) => first_stage_re_out(6),
            data_re_out(1) => first_stage_re_out(14),
            data_re_out(2) => first_stage_re_out(22),
            data_re_out(3) => first_stage_re_out(30),
            data_re_out(4) => first_stage_re_out(38),
            data_re_out(5) => first_stage_re_out(46),
            data_re_out(6) => first_stage_re_out(54),
            data_re_out(7) => first_stage_re_out(62),
            data_im_out(0) => first_stage_im_out(6),
            data_im_out(1) => first_stage_im_out(14),
            data_im_out(2) => first_stage_im_out(22),
            data_im_out(3) => first_stage_im_out(30),
            data_im_out(4) => first_stage_im_out(38),
            data_im_out(5) => first_stage_im_out(46),
            data_im_out(6) => first_stage_im_out(54),
            data_im_out(7) => first_stage_im_out(62)
        );

    ULFFT_PT8_7 : fft_pt8
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(5 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(7),
            data_re_in(1) => data_re_in(15),
            data_re_in(2) => data_re_in(23),
            data_re_in(3) => data_re_in(31),
            data_re_in(4) => data_re_in(39),
            data_re_in(5) => data_re_in(47),
            data_re_in(6) => data_re_in(55),
            data_re_in(7) => data_re_in(63),
            data_im_in(0) => data_im_in(7),
            data_im_in(1) => data_im_in(15),
            data_im_in(2) => data_im_in(23),
            data_im_in(3) => data_im_in(31),
            data_im_in(4) => data_im_in(39),
            data_im_in(5) => data_im_in(47),
            data_im_in(6) => data_im_in(55),
            data_im_in(7) => data_im_in(63),
            data_re_out(0) => first_stage_re_out(7),
            data_re_out(1) => first_stage_re_out(15),
            data_re_out(2) => first_stage_re_out(23),
            data_re_out(3) => first_stage_re_out(31),
            data_re_out(4) => first_stage_re_out(39),
            data_re_out(5) => first_stage_re_out(47),
            data_re_out(6) => first_stage_re_out(55),
            data_re_out(7) => first_stage_re_out(63),
            data_im_out(0) => first_stage_im_out(7),
            data_im_out(1) => first_stage_im_out(15),
            data_im_out(2) => first_stage_im_out(23),
            data_im_out(3) => first_stage_im_out(31),
            data_im_out(4) => first_stage_im_out(39),
            data_im_out(5) => first_stage_im_out(47),
            data_im_out(6) => first_stage_im_out(55),
            data_im_out(7) => first_stage_im_out(63)
        );


    --- right-hand-side processors
    URFFT_PT8_0 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(0),
            data_re_in(1) => mul_re_out(1),
            data_re_in(2) => mul_re_out(2),
            data_re_in(3) => mul_re_out(3),
            data_re_in(4) => mul_re_out(4),
            data_re_in(5) => mul_re_out(5),
            data_re_in(6) => mul_re_out(6),
            data_re_in(7) => mul_re_out(7),
            data_im_in(0) => mul_im_out(0),
            data_im_in(1) => mul_im_out(1),
            data_im_in(2) => mul_im_out(2),
            data_im_in(3) => mul_im_out(3),
            data_im_in(4) => mul_im_out(4),
            data_im_in(5) => mul_im_out(5),
            data_im_in(6) => mul_im_out(6),
            data_im_in(7) => mul_im_out(7),
            data_re_out(0) => data_re_out(0),
            data_re_out(1) => data_re_out(8),
            data_re_out(2) => data_re_out(16),
            data_re_out(3) => data_re_out(24),
            data_re_out(4) => data_re_out(32),
            data_re_out(5) => data_re_out(40),
            data_re_out(6) => data_re_out(48),
            data_re_out(7) => data_re_out(56),
            data_im_out(0) => data_im_out(0),
            data_im_out(1) => data_im_out(8),
            data_im_out(2) => data_im_out(16),
            data_im_out(3) => data_im_out(24),
            data_im_out(4) => data_im_out(32),
            data_im_out(5) => data_im_out(40),
            data_im_out(6) => data_im_out(48),
            data_im_out(7) => data_im_out(56)
        );           

    URFFT_PT8_1 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(8),
            data_re_in(1) => mul_re_out(9),
            data_re_in(2) => mul_re_out(10),
            data_re_in(3) => mul_re_out(11),
            data_re_in(4) => mul_re_out(12),
            data_re_in(5) => mul_re_out(13),
            data_re_in(6) => mul_re_out(14),
            data_re_in(7) => mul_re_out(15),
            data_im_in(0) => mul_im_out(8),
            data_im_in(1) => mul_im_out(9),
            data_im_in(2) => mul_im_out(10),
            data_im_in(3) => mul_im_out(11),
            data_im_in(4) => mul_im_out(12),
            data_im_in(5) => mul_im_out(13),
            data_im_in(6) => mul_im_out(14),
            data_im_in(7) => mul_im_out(15),
            data_re_out(0) => data_re_out(1),
            data_re_out(1) => data_re_out(9),
            data_re_out(2) => data_re_out(17),
            data_re_out(3) => data_re_out(25),
            data_re_out(4) => data_re_out(33),
            data_re_out(5) => data_re_out(41),
            data_re_out(6) => data_re_out(49),
            data_re_out(7) => data_re_out(57),
            data_im_out(0) => data_im_out(1),
            data_im_out(1) => data_im_out(9),
            data_im_out(2) => data_im_out(17),
            data_im_out(3) => data_im_out(25),
            data_im_out(4) => data_im_out(33),
            data_im_out(5) => data_im_out(41),
            data_im_out(6) => data_im_out(49),
            data_im_out(7) => data_im_out(57)
        );           

    URFFT_PT8_2 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(16),
            data_re_in(1) => mul_re_out(17),
            data_re_in(2) => mul_re_out(18),
            data_re_in(3) => mul_re_out(19),
            data_re_in(4) => mul_re_out(20),
            data_re_in(5) => mul_re_out(21),
            data_re_in(6) => mul_re_out(22),
            data_re_in(7) => mul_re_out(23),
            data_im_in(0) => mul_im_out(16),
            data_im_in(1) => mul_im_out(17),
            data_im_in(2) => mul_im_out(18),
            data_im_in(3) => mul_im_out(19),
            data_im_in(4) => mul_im_out(20),
            data_im_in(5) => mul_im_out(21),
            data_im_in(6) => mul_im_out(22),
            data_im_in(7) => mul_im_out(23),
            data_re_out(0) => data_re_out(2),
            data_re_out(1) => data_re_out(10),
            data_re_out(2) => data_re_out(18),
            data_re_out(3) => data_re_out(26),
            data_re_out(4) => data_re_out(34),
            data_re_out(5) => data_re_out(42),
            data_re_out(6) => data_re_out(50),
            data_re_out(7) => data_re_out(58),
            data_im_out(0) => data_im_out(2),
            data_im_out(1) => data_im_out(10),
            data_im_out(2) => data_im_out(18),
            data_im_out(3) => data_im_out(26),
            data_im_out(4) => data_im_out(34),
            data_im_out(5) => data_im_out(42),
            data_im_out(6) => data_im_out(50),
            data_im_out(7) => data_im_out(58)
        );           

    URFFT_PT8_3 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(24),
            data_re_in(1) => mul_re_out(25),
            data_re_in(2) => mul_re_out(26),
            data_re_in(3) => mul_re_out(27),
            data_re_in(4) => mul_re_out(28),
            data_re_in(5) => mul_re_out(29),
            data_re_in(6) => mul_re_out(30),
            data_re_in(7) => mul_re_out(31),
            data_im_in(0) => mul_im_out(24),
            data_im_in(1) => mul_im_out(25),
            data_im_in(2) => mul_im_out(26),
            data_im_in(3) => mul_im_out(27),
            data_im_in(4) => mul_im_out(28),
            data_im_in(5) => mul_im_out(29),
            data_im_in(6) => mul_im_out(30),
            data_im_in(7) => mul_im_out(31),
            data_re_out(0) => data_re_out(3),
            data_re_out(1) => data_re_out(11),
            data_re_out(2) => data_re_out(19),
            data_re_out(3) => data_re_out(27),
            data_re_out(4) => data_re_out(35),
            data_re_out(5) => data_re_out(43),
            data_re_out(6) => data_re_out(51),
            data_re_out(7) => data_re_out(59),
            data_im_out(0) => data_im_out(3),
            data_im_out(1) => data_im_out(11),
            data_im_out(2) => data_im_out(19),
            data_im_out(3) => data_im_out(27),
            data_im_out(4) => data_im_out(35),
            data_im_out(5) => data_im_out(43),
            data_im_out(6) => data_im_out(51),
            data_im_out(7) => data_im_out(59)
        );           

    URFFT_PT8_4 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(32),
            data_re_in(1) => mul_re_out(33),
            data_re_in(2) => mul_re_out(34),
            data_re_in(3) => mul_re_out(35),
            data_re_in(4) => mul_re_out(36),
            data_re_in(5) => mul_re_out(37),
            data_re_in(6) => mul_re_out(38),
            data_re_in(7) => mul_re_out(39),
            data_im_in(0) => mul_im_out(32),
            data_im_in(1) => mul_im_out(33),
            data_im_in(2) => mul_im_out(34),
            data_im_in(3) => mul_im_out(35),
            data_im_in(4) => mul_im_out(36),
            data_im_in(5) => mul_im_out(37),
            data_im_in(6) => mul_im_out(38),
            data_im_in(7) => mul_im_out(39),
            data_re_out(0) => data_re_out(4),
            data_re_out(1) => data_re_out(12),
            data_re_out(2) => data_re_out(20),
            data_re_out(3) => data_re_out(28),
            data_re_out(4) => data_re_out(36),
            data_re_out(5) => data_re_out(44),
            data_re_out(6) => data_re_out(52),
            data_re_out(7) => data_re_out(60),
            data_im_out(0) => data_im_out(4),
            data_im_out(1) => data_im_out(12),
            data_im_out(2) => data_im_out(20),
            data_im_out(3) => data_im_out(28),
            data_im_out(4) => data_im_out(36),
            data_im_out(5) => data_im_out(44),
            data_im_out(6) => data_im_out(52),
            data_im_out(7) => data_im_out(60)
        );           

    URFFT_PT8_5 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(40),
            data_re_in(1) => mul_re_out(41),
            data_re_in(2) => mul_re_out(42),
            data_re_in(3) => mul_re_out(43),
            data_re_in(4) => mul_re_out(44),
            data_re_in(5) => mul_re_out(45),
            data_re_in(6) => mul_re_out(46),
            data_re_in(7) => mul_re_out(47),
            data_im_in(0) => mul_im_out(40),
            data_im_in(1) => mul_im_out(41),
            data_im_in(2) => mul_im_out(42),
            data_im_in(3) => mul_im_out(43),
            data_im_in(4) => mul_im_out(44),
            data_im_in(5) => mul_im_out(45),
            data_im_in(6) => mul_im_out(46),
            data_im_in(7) => mul_im_out(47),
            data_re_out(0) => data_re_out(5),
            data_re_out(1) => data_re_out(13),
            data_re_out(2) => data_re_out(21),
            data_re_out(3) => data_re_out(29),
            data_re_out(4) => data_re_out(37),
            data_re_out(5) => data_re_out(45),
            data_re_out(6) => data_re_out(53),
            data_re_out(7) => data_re_out(61),
            data_im_out(0) => data_im_out(5),
            data_im_out(1) => data_im_out(13),
            data_im_out(2) => data_im_out(21),
            data_im_out(3) => data_im_out(29),
            data_im_out(4) => data_im_out(37),
            data_im_out(5) => data_im_out(45),
            data_im_out(6) => data_im_out(53),
            data_im_out(7) => data_im_out(61)
        );           

    URFFT_PT8_6 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(48),
            data_re_in(1) => mul_re_out(49),
            data_re_in(2) => mul_re_out(50),
            data_re_in(3) => mul_re_out(51),
            data_re_in(4) => mul_re_out(52),
            data_re_in(5) => mul_re_out(53),
            data_re_in(6) => mul_re_out(54),
            data_re_in(7) => mul_re_out(55),
            data_im_in(0) => mul_im_out(48),
            data_im_in(1) => mul_im_out(49),
            data_im_in(2) => mul_im_out(50),
            data_im_in(3) => mul_im_out(51),
            data_im_in(4) => mul_im_out(52),
            data_im_in(5) => mul_im_out(53),
            data_im_in(6) => mul_im_out(54),
            data_im_in(7) => mul_im_out(55),
            data_re_out(0) => data_re_out(6),
            data_re_out(1) => data_re_out(14),
            data_re_out(2) => data_re_out(22),
            data_re_out(3) => data_re_out(30),
            data_re_out(4) => data_re_out(38),
            data_re_out(5) => data_re_out(46),
            data_re_out(6) => data_re_out(54),
            data_re_out(7) => data_re_out(62),
            data_im_out(0) => data_im_out(6),
            data_im_out(1) => data_im_out(14),
            data_im_out(2) => data_im_out(22),
            data_im_out(3) => data_im_out(30),
            data_im_out(4) => data_im_out(38),
            data_im_out(5) => data_im_out(46),
            data_im_out(6) => data_im_out(54),
            data_im_out(7) => data_im_out(62)
        );           

    URFFT_PT8_7 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(56),
            data_re_in(1) => mul_re_out(57),
            data_re_in(2) => mul_re_out(58),
            data_re_in(3) => mul_re_out(59),
            data_re_in(4) => mul_re_out(60),
            data_re_in(5) => mul_re_out(61),
            data_re_in(6) => mul_re_out(62),
            data_re_in(7) => mul_re_out(63),
            data_im_in(0) => mul_im_out(56),
            data_im_in(1) => mul_im_out(57),
            data_im_in(2) => mul_im_out(58),
            data_im_in(3) => mul_im_out(59),
            data_im_in(4) => mul_im_out(60),
            data_im_in(5) => mul_im_out(61),
            data_im_in(6) => mul_im_out(62),
            data_im_in(7) => mul_im_out(63),
            data_re_out(0) => data_re_out(7),
            data_re_out(1) => data_re_out(15),
            data_re_out(2) => data_re_out(23),
            data_re_out(3) => data_re_out(31),
            data_re_out(4) => data_re_out(39),
            data_re_out(5) => data_re_out(47),
            data_re_out(6) => data_re_out(55),
            data_re_out(7) => data_re_out(63),
            data_im_out(0) => data_im_out(7),
            data_im_out(1) => data_im_out(15),
            data_im_out(2) => data_im_out(23),
            data_im_out(3) => data_im_out(31),
            data_im_out(4) => data_im_out(39),
            data_im_out(5) => data_im_out(47),
            data_im_out(6) => data_im_out(55),
            data_im_out(7) => data_im_out(63)
        );           


    --- multipliers
 
    UMUL_0 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(0),
            data_im_in => first_stage_im_out(0),
            data_re_out => mul_re_out(0),
            data_im_out => mul_im_out(0)
        );

 
    UMUL_1 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(1),
            data_im_in => first_stage_im_out(1),
            data_re_out => mul_re_out(1),
            data_im_out => mul_im_out(1)
        );

 
    UMUL_2 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(2),
            data_im_in => first_stage_im_out(2),
            data_re_out => mul_re_out(2),
            data_im_out => mul_im_out(2)
        );

 
    UMUL_3 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(3),
            data_im_in => first_stage_im_out(3),
            data_re_out => mul_re_out(3),
            data_im_out => mul_im_out(3)
        );

 
    UMUL_4 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(4),
            data_im_in => first_stage_im_out(4),
            data_re_out => mul_re_out(4),
            data_im_out => mul_im_out(4)
        );

 
    UMUL_5 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(5),
            data_im_in => first_stage_im_out(5),
            data_re_out => mul_re_out(5),
            data_im_out => mul_im_out(5)
        );

 
    UMUL_6 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(6),
            data_im_in => first_stage_im_out(6),
            data_re_out => mul_re_out(6),
            data_im_out => mul_im_out(6)
        );

 
    UMUL_7 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(7),
            data_im_in => first_stage_im_out(7),
            data_re_out => mul_re_out(7),
            data_im_out => mul_im_out(7)
        );

 
    UMUL_8 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(8),
            data_im_in => first_stage_im_out(8),
            data_re_out => mul_re_out(8),
            data_im_out => mul_im_out(8)
        );

 
    UMUL_9 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(9),
            data_im_in => first_stage_im_out(9),
            re_multiplicator => "0011111110110001", --- 0.995178222656 + j-0.0980224609375
            im_multiplicator => "1111100110111010",
            data_re_out => mul_re_out(9),
            data_im_out => mul_im_out(9)
        );

 
    UMUL_10 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(10),
            data_im_in => first_stage_im_out(10),
            re_multiplicator => "0011111011000101", --- 0.980773925781 + j-0.195068359375
            im_multiplicator => "1111001110000100",
            data_re_out => mul_re_out(10),
            data_im_out => mul_im_out(10)
        );

 
    UMUL_11 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(11),
            data_im_in => first_stage_im_out(11),
            re_multiplicator => "0011110100111111", --- 0.956970214844 + j-0.290283203125
            im_multiplicator => "1110110101101100",
            data_re_out => mul_re_out(11),
            data_im_out => mul_im_out(11)
        );

 
    UMUL_12 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(12),
            data_im_in => first_stage_im_out(12),
            re_multiplicator => "0011101100100001", --- 0.923889160156 + j-0.382690429688
            im_multiplicator => "1110011110000010",
            data_re_out => mul_re_out(12),
            data_im_out => mul_im_out(12)
        );

 
    UMUL_13 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(13),
            data_im_in => first_stage_im_out(13),
            re_multiplicator => "0011100001110001", --- 0.881896972656 + j-0.471374511719
            im_multiplicator => "1110000111010101",
            data_re_out => mul_re_out(13),
            data_im_out => mul_im_out(13)
        );

 
    UMUL_14 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(14),
            data_im_in => first_stage_im_out(14),
            re_multiplicator => "0011010100110111", --- 0.831481933594 + j-0.555541992188
            im_multiplicator => "1101110001110010",
            data_re_out => mul_re_out(14),
            data_im_out => mul_im_out(14)
        );

 
    UMUL_15 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(15),
            data_im_in => first_stage_im_out(15),
            re_multiplicator => "0011000101111001", --- 0.773010253906 + j-0.634399414062
            im_multiplicator => "1101011101100110",
            data_re_out => mul_re_out(15),
            data_im_out => mul_im_out(15)
        );

 
    UMUL_16 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(16),
            data_im_in => first_stage_im_out(16),
            data_re_out => mul_re_out(16),
            data_im_out => mul_im_out(16)
        );

 
    UMUL_17 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(17),
            data_im_in => first_stage_im_out(17),
            re_multiplicator => "0011111011000101", --- 0.980773925781 + j-0.195068359375
            im_multiplicator => "1111001110000100",
            data_re_out => mul_re_out(17),
            data_im_out => mul_im_out(17)
        );

 
    UMUL_18 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(18),
            data_im_in => first_stage_im_out(18),
            re_multiplicator => "0011101100100001", --- 0.923889160156 + j-0.382690429688
            im_multiplicator => "1110011110000010",
            data_re_out => mul_re_out(18),
            data_im_out => mul_im_out(18)
        );

 
    UMUL_19 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(19),
            data_im_in => first_stage_im_out(19),
            re_multiplicator => "0011010100110111", --- 0.831481933594 + j-0.555541992188
            im_multiplicator => "1101110001110010",
            data_re_out => mul_re_out(19),
            data_im_out => mul_im_out(19)
        );

 
    UMUL_20 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(20),
            data_im_in => first_stage_im_out(20),
            re_multiplicator => "0010110101000001", --- 0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            data_re_out => mul_re_out(20),
            data_im_out => mul_im_out(20)
        );

 
    UMUL_21 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(21),
            data_im_in => first_stage_im_out(21),
            re_multiplicator => "0010001110001110", --- 0.555541992188 + j-0.831481933594
            im_multiplicator => "1100101011001001",
            data_re_out => mul_re_out(21),
            data_im_out => mul_im_out(21)
        );

 
    UMUL_22 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(22),
            data_im_in => first_stage_im_out(22),
            re_multiplicator => "0001100001111110", --- 0.382690429688 + j-0.923889160156
            im_multiplicator => "1100010011011111",
            data_re_out => mul_re_out(22),
            data_im_out => mul_im_out(22)
        );

 
    UMUL_23 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(23),
            data_im_in => first_stage_im_out(23),
            re_multiplicator => "0000110001111100", --- 0.195068359375 + j-0.980773925781
            im_multiplicator => "1100000100111011",
            data_re_out => mul_re_out(23),
            data_im_out => mul_im_out(23)
        );

 
    UMUL_24 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(24),
            data_im_in => first_stage_im_out(24),
            data_re_out => mul_re_out(24),
            data_im_out => mul_im_out(24)
        );

 
    UMUL_25 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(25),
            data_im_in => first_stage_im_out(25),
            re_multiplicator => "0011110100111111", --- 0.956970214844 + j-0.290283203125
            im_multiplicator => "1110110101101100",
            data_re_out => mul_re_out(25),
            data_im_out => mul_im_out(25)
        );

 
    UMUL_26 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(26),
            data_im_in => first_stage_im_out(26),
            re_multiplicator => "0011010100110111", --- 0.831481933594 + j-0.555541992188
            im_multiplicator => "1101110001110010",
            data_re_out => mul_re_out(26),
            data_im_out => mul_im_out(26)
        );

 
    UMUL_27 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(27),
            data_im_in => first_stage_im_out(27),
            re_multiplicator => "0010100010011010", --- 0.634399414062 + j-0.773010253906
            im_multiplicator => "1100111010000111",
            data_re_out => mul_re_out(27),
            data_im_out => mul_im_out(27)
        );

 
    UMUL_28 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(28),
            data_im_in => first_stage_im_out(28),
            re_multiplicator => "0001100001111110", --- 0.382690429688 + j-0.923889160156
            im_multiplicator => "1100010011011111",
            data_re_out => mul_re_out(28),
            data_im_out => mul_im_out(28)
        );

 
    UMUL_29 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(29),
            data_im_in => first_stage_im_out(29),
            re_multiplicator => "0000011001000110", --- 0.0980224609375 + j-0.995178222656
            im_multiplicator => "1100000001001111",
            data_re_out => mul_re_out(29),
            data_im_out => mul_im_out(29)
        );

 
    UMUL_30 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(30),
            data_im_in => first_stage_im_out(30),
            re_multiplicator => "1111001110000100", --- -0.195068359375 + j-0.980773925781
            im_multiplicator => "1100000100111011",
            data_re_out => mul_re_out(30),
            data_im_out => mul_im_out(30)
        );

 
    UMUL_31 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(31),
            data_im_in => first_stage_im_out(31),
            re_multiplicator => "1110000111010101", --- -0.471374511719 + j-0.881896972656
            im_multiplicator => "1100011110001111",
            data_re_out => mul_re_out(31),
            data_im_out => mul_im_out(31)
        );

 
    UMUL_32 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(32),
            data_im_in => first_stage_im_out(32),
            data_re_out => mul_re_out(32),
            data_im_out => mul_im_out(32)
        );

 
    UMUL_33 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(33),
            data_im_in => first_stage_im_out(33),
            re_multiplicator => "0011101100100001", --- 0.923889160156 + j-0.382690429688
            im_multiplicator => "1110011110000010",
            data_re_out => mul_re_out(33),
            data_im_out => mul_im_out(33)
        );

 
    UMUL_34 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(34),
            data_im_in => first_stage_im_out(34),
            re_multiplicator => "0010110101000001", --- 0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            data_re_out => mul_re_out(34),
            data_im_out => mul_im_out(34)
        );

 
    UMUL_35 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(35),
            data_im_in => first_stage_im_out(35),
            re_multiplicator => "0001100001111110", --- 0.382690429688 + j-0.923889160156
            im_multiplicator => "1100010011011111",
            data_re_out => mul_re_out(35),
            data_im_out => mul_im_out(35)
        );

 
    UMUL_36 : multiplier_mulminusj
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(36),
            data_im_in => first_stage_im_out(36),
            data_re_out => mul_re_out(36),
            data_im_out => mul_im_out(36)
        );

 
    UMUL_37 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(37),
            data_im_in => first_stage_im_out(37),
            re_multiplicator => "1110011110000010", --- -0.382690429688 + j-0.923889160156
            im_multiplicator => "1100010011011111",
            data_re_out => mul_re_out(37),
            data_im_out => mul_im_out(37)
        );

 
    UMUL_38 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(38),
            data_im_in => first_stage_im_out(38),
            re_multiplicator => "1101001010111111", --- -0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            data_re_out => mul_re_out(38),
            data_im_out => mul_im_out(38)
        );

 
    UMUL_39 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(39),
            data_im_in => first_stage_im_out(39),
            re_multiplicator => "1100010011011111", --- -0.923889160156 + j-0.382690429688
            im_multiplicator => "1110011110000010",
            data_re_out => mul_re_out(39),
            data_im_out => mul_im_out(39)
        );

 
    UMUL_40 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(40),
            data_im_in => first_stage_im_out(40),
            data_re_out => mul_re_out(40),
            data_im_out => mul_im_out(40)
        );

 
    UMUL_41 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(41),
            data_im_in => first_stage_im_out(41),
            re_multiplicator => "0011100001110001", --- 0.881896972656 + j-0.471374511719
            im_multiplicator => "1110000111010101",
            data_re_out => mul_re_out(41),
            data_im_out => mul_im_out(41)
        );

 
    UMUL_42 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(42),
            data_im_in => first_stage_im_out(42),
            re_multiplicator => "0010001110001110", --- 0.555541992188 + j-0.831481933594
            im_multiplicator => "1100101011001001",
            data_re_out => mul_re_out(42),
            data_im_out => mul_im_out(42)
        );

 
    UMUL_43 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(43),
            data_im_in => first_stage_im_out(43),
            re_multiplicator => "0000011001000110", --- 0.0980224609375 + j-0.995178222656
            im_multiplicator => "1100000001001111",
            data_re_out => mul_re_out(43),
            data_im_out => mul_im_out(43)
        );

 
    UMUL_44 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(44),
            data_im_in => first_stage_im_out(44),
            re_multiplicator => "1110011110000010", --- -0.382690429688 + j-0.923889160156
            im_multiplicator => "1100010011011111",
            data_re_out => mul_re_out(44),
            data_im_out => mul_im_out(44)
        );

 
    UMUL_45 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(45),
            data_im_in => first_stage_im_out(45),
            re_multiplicator => "1100111010000111", --- -0.773010253906 + j-0.634399414062
            im_multiplicator => "1101011101100110",
            data_re_out => mul_re_out(45),
            data_im_out => mul_im_out(45)
        );

 
    UMUL_46 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(46),
            data_im_in => first_stage_im_out(46),
            re_multiplicator => "1100000100111011", --- -0.980773925781 + j-0.195068359375
            im_multiplicator => "1111001110000100",
            data_re_out => mul_re_out(46),
            data_im_out => mul_im_out(46)
        );

 
    UMUL_47 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(47),
            data_im_in => first_stage_im_out(47),
            re_multiplicator => "1100001011000001", --- -0.956970214844 + j0.290283203125
            im_multiplicator => "0001001010010100",
            data_re_out => mul_re_out(47),
            data_im_out => mul_im_out(47)
        );

 
    UMUL_48 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(48),
            data_im_in => first_stage_im_out(48),
            data_re_out => mul_re_out(48),
            data_im_out => mul_im_out(48)
        );

 
    UMUL_49 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(49),
            data_im_in => first_stage_im_out(49),
            re_multiplicator => "0011010100110111", --- 0.831481933594 + j-0.555541992188
            im_multiplicator => "1101110001110010",
            data_re_out => mul_re_out(49),
            data_im_out => mul_im_out(49)
        );

 
    UMUL_50 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(50),
            data_im_in => first_stage_im_out(50),
            re_multiplicator => "0001100001111110", --- 0.382690429688 + j-0.923889160156
            im_multiplicator => "1100010011011111",
            data_re_out => mul_re_out(50),
            data_im_out => mul_im_out(50)
        );

 
    UMUL_51 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(51),
            data_im_in => first_stage_im_out(51),
            re_multiplicator => "1111001110000100", --- -0.195068359375 + j-0.980773925781
            im_multiplicator => "1100000100111011",
            data_re_out => mul_re_out(51),
            data_im_out => mul_im_out(51)
        );

 
    UMUL_52 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(52),
            data_im_in => first_stage_im_out(52),
            re_multiplicator => "1101001010111111", --- -0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            data_re_out => mul_re_out(52),
            data_im_out => mul_im_out(52)
        );

 
    UMUL_53 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(53),
            data_im_in => first_stage_im_out(53),
            re_multiplicator => "1100000100111011", --- -0.980773925781 + j-0.195068359375
            im_multiplicator => "1111001110000100",
            data_re_out => mul_re_out(53),
            data_im_out => mul_im_out(53)
        );

 
    UMUL_54 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(54),
            data_im_in => first_stage_im_out(54),
            re_multiplicator => "1100010011011111", --- -0.923889160156 + j0.382690429688
            im_multiplicator => "0001100001111110",
            data_re_out => mul_re_out(54),
            data_im_out => mul_im_out(54)
        );

 
    UMUL_55 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(55),
            data_im_in => first_stage_im_out(55),
            re_multiplicator => "1101110001110010", --- -0.555541992188 + j0.831481933594
            im_multiplicator => "0011010100110111",
            data_re_out => mul_re_out(55),
            data_im_out => mul_im_out(55)
        );

 
    UMUL_56 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(56),
            data_im_in => first_stage_im_out(56),
            data_re_out => mul_re_out(56),
            data_im_out => mul_im_out(56)
        );

 
    UMUL_57 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(57),
            data_im_in => first_stage_im_out(57),
            re_multiplicator => "0011000101111001", --- 0.773010253906 + j-0.634399414062
            im_multiplicator => "1101011101100110",
            data_re_out => mul_re_out(57),
            data_im_out => mul_im_out(57)
        );

 
    UMUL_58 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(58),
            data_im_in => first_stage_im_out(58),
            re_multiplicator => "0000110001111100", --- 0.195068359375 + j-0.980773925781
            im_multiplicator => "1100000100111011",
            data_re_out => mul_re_out(58),
            data_im_out => mul_im_out(58)
        );

 
    UMUL_59 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(59),
            data_im_in => first_stage_im_out(59),
            re_multiplicator => "1110000111010101", --- -0.471374511719 + j-0.881896972656
            im_multiplicator => "1100011110001111",
            data_re_out => mul_re_out(59),
            data_im_out => mul_im_out(59)
        );

 
    UMUL_60 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(60),
            data_im_in => first_stage_im_out(60),
            re_multiplicator => "1100010011011111", --- -0.923889160156 + j-0.382690429688
            im_multiplicator => "1110011110000010",
            data_re_out => mul_re_out(60),
            data_im_out => mul_im_out(60)
        );

 
    UMUL_61 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(61),
            data_im_in => first_stage_im_out(61),
            re_multiplicator => "1100001011000001", --- -0.956970214844 + j0.290283203125
            im_multiplicator => "0001001010010100",
            data_re_out => mul_re_out(61),
            data_im_out => mul_im_out(61)
        );

 
    UMUL_62 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(62),
            data_im_in => first_stage_im_out(62),
            re_multiplicator => "1101110001110010", --- -0.555541992188 + j0.831481933594
            im_multiplicator => "0011010100110111",
            data_re_out => mul_re_out(62),
            data_im_out => mul_im_out(62)
        );

 
    UMUL_63 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(63),
            data_im_in => first_stage_im_out(63),
            re_multiplicator => "0000011001000110", --- 0.0980224609375 + j0.995178222656
            im_multiplicator => "0011111110110001",
            data_re_out => mul_re_out(63),
            data_im_out => mul_im_out(63)
        );

end Behavioral;
