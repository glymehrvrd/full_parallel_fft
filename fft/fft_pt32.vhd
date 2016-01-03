library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt32 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        tmp_mul_re_out, tmp_mul_im_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_im_in     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        data_re_out    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_im_out    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end fft_pt32;

architecture Behavioral of fft_pt32 is

component fft_pt4 is
    GENERIC (
        ctrl_start     : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        data_im_in     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        data_re_out    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        data_im_out    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end component;

component fft_pt8 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        data_im_in     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);

        data_re_out     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        data_im_out     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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

--- multiplicator declaration
type ArrOfStdlogic is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal re_multiplicator, im_multiplicator : ArrOfStdlogic;

signal first_stage_re_out, first_stage_im_out: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal mul_re_out, mul_im_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
    --- multiplicator definition
    re_multiplicator(9) <= "0011111011000101"; ---  0.980773925781
    im_multiplicator(9) <= "1111001110000100"; --- j-0.195068359375
    re_multiplicator(10) <= "0011101100100001"; ---  0.923889160156
    im_multiplicator(10) <= "1110011110000010"; --- j-0.382690429688
    re_multiplicator(11) <= "0011010100110111"; ---  0.831481933594
    im_multiplicator(11) <= "1101110001110010"; --- j-0.555541992188
    re_multiplicator(12) <= "0010110101000001"; ---  0.707092285156
    im_multiplicator(12) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(13) <= "0010001110001110"; ---  0.555541992188
    im_multiplicator(13) <= "1100101011001001"; --- j-0.831481933594
    re_multiplicator(14) <= "0001100001111110"; ---  0.382690429688
    im_multiplicator(14) <= "1100010011011111"; --- j-0.923889160156
    re_multiplicator(15) <= "0000110001111100"; ---  0.195068359375
    im_multiplicator(15) <= "1100000100111011"; --- j-0.980773925781
    re_multiplicator(17) <= "0011101100100001"; ---  0.923889160156
    im_multiplicator(17) <= "1110011110000010"; --- j-0.382690429688
    re_multiplicator(18) <= "0010110101000001"; ---  0.707092285156
    im_multiplicator(18) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(19) <= "0001100001111110"; ---  0.382690429688
    im_multiplicator(19) <= "1100010011011111"; --- j-0.923889160156
    re_multiplicator(21) <= "1110011110000010"; ---  -0.382690429688
    im_multiplicator(21) <= "1100010011011111"; --- j-0.923889160156
    re_multiplicator(22) <= "1101001010111111"; ---  -0.707092285156
    im_multiplicator(22) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(23) <= "1100010011011111"; ---  -0.923889160156
    im_multiplicator(23) <= "1110011110000010"; --- j-0.382690429688
    re_multiplicator(25) <= "0011010100110111"; ---  0.831481933594
    im_multiplicator(25) <= "1101110001110010"; --- j-0.555541992188
    re_multiplicator(26) <= "0001100001111110"; ---  0.382690429688
    im_multiplicator(26) <= "1100010011011111"; --- j-0.923889160156
    re_multiplicator(27) <= "1111001110000100"; ---  -0.195068359375
    im_multiplicator(27) <= "1100000100111011"; --- j-0.980773925781
    re_multiplicator(28) <= "1101001010111111"; ---  -0.707092285156
    im_multiplicator(28) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(29) <= "1100000100111011"; ---  -0.980773925781
    im_multiplicator(29) <= "1111001110000100"; --- j-0.195068359375
    re_multiplicator(30) <= "1100010011011111"; ---  -0.923889160156
    im_multiplicator(30) <= "0001100001111110"; --- j0.382690429688
    re_multiplicator(31) <= "1101110001110010"; ---  -0.555541992188
    im_multiplicator(31) <= "0011010100110111"; --- j0.831481933594

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;
    tmp_mul_re_out <= mul_re_out;
    tmp_mul_im_out <= mul_im_out;

    --- left-hand-side processors
    ULFFT_PT4_0 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(0),
            data_re_in(1) => data_re_in(8),
            data_re_in(2) => data_re_in(16),
            data_re_in(3) => data_re_in(24),
            data_im_in(0) => data_im_in(0),
            data_im_in(1) => data_im_in(8),
            data_im_in(2) => data_im_in(16),
            data_im_in(3) => data_im_in(24),
            data_re_out(0) => first_stage_re_out(0),
            data_re_out(1) => first_stage_re_out(8),
            data_re_out(2) => first_stage_re_out(16),
            data_re_out(3) => first_stage_re_out(24),
            data_im_out(0) => first_stage_im_out(0),
            data_im_out(1) => first_stage_im_out(8),
            data_im_out(2) => first_stage_im_out(16),
            data_im_out(3) => first_stage_im_out(24)
        );

    ULFFT_PT4_1 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(1),
            data_re_in(1) => data_re_in(9),
            data_re_in(2) => data_re_in(17),
            data_re_in(3) => data_re_in(25),
            data_im_in(0) => data_im_in(1),
            data_im_in(1) => data_im_in(9),
            data_im_in(2) => data_im_in(17),
            data_im_in(3) => data_im_in(25),
            data_re_out(0) => first_stage_re_out(1),
            data_re_out(1) => first_stage_re_out(9),
            data_re_out(2) => first_stage_re_out(17),
            data_re_out(3) => first_stage_re_out(25),
            data_im_out(0) => first_stage_im_out(1),
            data_im_out(1) => first_stage_im_out(9),
            data_im_out(2) => first_stage_im_out(17),
            data_im_out(3) => first_stage_im_out(25)
        );

    ULFFT_PT4_2 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(2),
            data_re_in(1) => data_re_in(10),
            data_re_in(2) => data_re_in(18),
            data_re_in(3) => data_re_in(26),
            data_im_in(0) => data_im_in(2),
            data_im_in(1) => data_im_in(10),
            data_im_in(2) => data_im_in(18),
            data_im_in(3) => data_im_in(26),
            data_re_out(0) => first_stage_re_out(2),
            data_re_out(1) => first_stage_re_out(10),
            data_re_out(2) => first_stage_re_out(18),
            data_re_out(3) => first_stage_re_out(26),
            data_im_out(0) => first_stage_im_out(2),
            data_im_out(1) => first_stage_im_out(10),
            data_im_out(2) => first_stage_im_out(18),
            data_im_out(3) => first_stage_im_out(26)
        );

    ULFFT_PT4_3 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(3),
            data_re_in(1) => data_re_in(11),
            data_re_in(2) => data_re_in(19),
            data_re_in(3) => data_re_in(27),
            data_im_in(0) => data_im_in(3),
            data_im_in(1) => data_im_in(11),
            data_im_in(2) => data_im_in(19),
            data_im_in(3) => data_im_in(27),
            data_re_out(0) => first_stage_re_out(3),
            data_re_out(1) => first_stage_re_out(11),
            data_re_out(2) => first_stage_re_out(19),
            data_re_out(3) => first_stage_re_out(27),
            data_im_out(0) => first_stage_im_out(3),
            data_im_out(1) => first_stage_im_out(11),
            data_im_out(2) => first_stage_im_out(19),
            data_im_out(3) => first_stage_im_out(27)
        );

    ULFFT_PT4_4 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(4),
            data_re_in(1) => data_re_in(12),
            data_re_in(2) => data_re_in(20),
            data_re_in(3) => data_re_in(28),
            data_im_in(0) => data_im_in(4),
            data_im_in(1) => data_im_in(12),
            data_im_in(2) => data_im_in(20),
            data_im_in(3) => data_im_in(28),
            data_re_out(0) => first_stage_re_out(4),
            data_re_out(1) => first_stage_re_out(12),
            data_re_out(2) => first_stage_re_out(20),
            data_re_out(3) => first_stage_re_out(28),
            data_im_out(0) => first_stage_im_out(4),
            data_im_out(1) => first_stage_im_out(12),
            data_im_out(2) => first_stage_im_out(20),
            data_im_out(3) => first_stage_im_out(28)
        );

    ULFFT_PT4_5 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(5),
            data_re_in(1) => data_re_in(13),
            data_re_in(2) => data_re_in(21),
            data_re_in(3) => data_re_in(29),
            data_im_in(0) => data_im_in(5),
            data_im_in(1) => data_im_in(13),
            data_im_in(2) => data_im_in(21),
            data_im_in(3) => data_im_in(29),
            data_re_out(0) => first_stage_re_out(5),
            data_re_out(1) => first_stage_re_out(13),
            data_re_out(2) => first_stage_re_out(21),
            data_re_out(3) => first_stage_re_out(29),
            data_im_out(0) => first_stage_im_out(5),
            data_im_out(1) => first_stage_im_out(13),
            data_im_out(2) => first_stage_im_out(21),
            data_im_out(3) => first_stage_im_out(29)
        );

    ULFFT_PT4_6 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(6),
            data_re_in(1) => data_re_in(14),
            data_re_in(2) => data_re_in(22),
            data_re_in(3) => data_re_in(30),
            data_im_in(0) => data_im_in(6),
            data_im_in(1) => data_im_in(14),
            data_im_in(2) => data_im_in(22),
            data_im_in(3) => data_im_in(30),
            data_re_out(0) => first_stage_re_out(6),
            data_re_out(1) => first_stage_re_out(14),
            data_re_out(2) => first_stage_re_out(22),
            data_re_out(3) => first_stage_re_out(30),
            data_im_out(0) => first_stage_im_out(6),
            data_im_out(1) => first_stage_im_out(14),
            data_im_out(2) => first_stage_im_out(22),
            data_im_out(3) => first_stage_im_out(30)
        );

    ULFFT_PT4_7 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(4 DOWNTO 3),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(7),
            data_re_in(1) => data_re_in(15),
            data_re_in(2) => data_re_in(23),
            data_re_in(3) => data_re_in(31),
            data_im_in(0) => data_im_in(7),
            data_im_in(1) => data_im_in(15),
            data_im_in(2) => data_im_in(23),
            data_im_in(3) => data_im_in(31),
            data_re_out(0) => first_stage_re_out(7),
            data_re_out(1) => first_stage_re_out(15),
            data_re_out(2) => first_stage_re_out(23),
            data_re_out(3) => first_stage_re_out(31),
            data_im_out(0) => first_stage_im_out(7),
            data_im_out(1) => first_stage_im_out(15),
            data_im_out(2) => first_stage_im_out(23),
            data_im_out(3) => first_stage_im_out(31)
        );


    --- right-hand-side processors
    URFFT_PT8_0 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
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
            data_re_out(1) => data_re_out(4),
            data_re_out(2) => data_re_out(8),
            data_re_out(3) => data_re_out(12),
            data_re_out(4) => data_re_out(16),
            data_re_out(5) => data_re_out(20),
            data_re_out(6) => data_re_out(24),
            data_re_out(7) => data_re_out(28),
            data_im_out(0) => data_im_out(0),
            data_im_out(1) => data_im_out(4),
            data_im_out(2) => data_im_out(8),
            data_im_out(3) => data_im_out(12),
            data_im_out(4) => data_im_out(16),
            data_im_out(5) => data_im_out(20),
            data_im_out(6) => data_im_out(24),
            data_im_out(7) => data_im_out(28)
        );           

    URFFT_PT8_1 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
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
            data_re_out(1) => data_re_out(5),
            data_re_out(2) => data_re_out(9),
            data_re_out(3) => data_re_out(13),
            data_re_out(4) => data_re_out(17),
            data_re_out(5) => data_re_out(21),
            data_re_out(6) => data_re_out(25),
            data_re_out(7) => data_re_out(29),
            data_im_out(0) => data_im_out(1),
            data_im_out(1) => data_im_out(5),
            data_im_out(2) => data_im_out(9),
            data_im_out(3) => data_im_out(13),
            data_im_out(4) => data_im_out(17),
            data_im_out(5) => data_im_out(21),
            data_im_out(6) => data_im_out(25),
            data_im_out(7) => data_im_out(29)
        );           

    URFFT_PT8_2 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
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
            data_re_out(1) => data_re_out(6),
            data_re_out(2) => data_re_out(10),
            data_re_out(3) => data_re_out(14),
            data_re_out(4) => data_re_out(18),
            data_re_out(5) => data_re_out(22),
            data_re_out(6) => data_re_out(26),
            data_re_out(7) => data_re_out(30),
            data_im_out(0) => data_im_out(2),
            data_im_out(1) => data_im_out(6),
            data_im_out(2) => data_im_out(10),
            data_im_out(3) => data_im_out(14),
            data_im_out(4) => data_im_out(18),
            data_im_out(5) => data_im_out(22),
            data_im_out(6) => data_im_out(26),
            data_im_out(7) => data_im_out(30)
        );           

    URFFT_PT8_3 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
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
            data_re_out(1) => data_re_out(7),
            data_re_out(2) => data_re_out(11),
            data_re_out(3) => data_re_out(15),
            data_re_out(4) => data_re_out(19),
            data_re_out(5) => data_re_out(23),
            data_re_out(6) => data_re_out(27),
            data_re_out(7) => data_re_out(31),
            data_im_out(0) => data_im_out(3),
            data_im_out(1) => data_im_out(7),
            data_im_out(2) => data_im_out(11),
            data_im_out(3) => data_im_out(15),
            data_im_out(4) => data_im_out(19),
            data_im_out(5) => data_im_out(23),
            data_im_out(6) => data_im_out(27),
            data_im_out(7) => data_im_out(31)
        );           


    --- multipliers
 
    UMUL_0 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(9),
            data_im_in => first_stage_im_out(9),
            re_multiplicator => re_multiplicator(9), ---  0.980773925781
            im_multiplicator => im_multiplicator(9), --- j-0.195068359375
            data_re_out => mul_re_out(9),
            data_im_out => mul_im_out(9)
        );

 
    UMUL_10 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(10),
            data_im_in => first_stage_im_out(10),
            re_multiplicator => re_multiplicator(10), ---  0.923889160156
            im_multiplicator => im_multiplicator(10), --- j-0.382690429688
            data_re_out => mul_re_out(10),
            data_im_out => mul_im_out(10)
        );

 
    UMUL_11 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(11),
            data_im_in => first_stage_im_out(11),
            re_multiplicator => re_multiplicator(11), ---  0.831481933594
            im_multiplicator => im_multiplicator(11), --- j-0.555541992188
            data_re_out => mul_re_out(11),
            data_im_out => mul_im_out(11)
        );

 
    UMUL_12 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(12),
            data_im_in => first_stage_im_out(12),
            re_multiplicator => re_multiplicator(12), ---  0.707092285156
            im_multiplicator => im_multiplicator(12), --- j-0.707092285156
            data_re_out => mul_re_out(12),
            data_im_out => mul_im_out(12)
        );

 
    UMUL_13 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(13),
            data_im_in => first_stage_im_out(13),
            re_multiplicator => re_multiplicator(13), ---  0.555541992188
            im_multiplicator => im_multiplicator(13), --- j-0.831481933594
            data_re_out => mul_re_out(13),
            data_im_out => mul_im_out(13)
        );

 
    UMUL_14 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(14),
            data_im_in => first_stage_im_out(14),
            re_multiplicator => re_multiplicator(14), ---  0.382690429688
            im_multiplicator => im_multiplicator(14), --- j-0.923889160156
            data_re_out => mul_re_out(14),
            data_im_out => mul_im_out(14)
        );

 
    UMUL_15 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(15),
            data_im_in => first_stage_im_out(15),
            re_multiplicator => re_multiplicator(15), ---  0.195068359375
            im_multiplicator => im_multiplicator(15), --- j-0.980773925781
            data_re_out => mul_re_out(15),
            data_im_out => mul_im_out(15)
        );

 
    UMUL_16 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(17),
            data_im_in => first_stage_im_out(17),
            re_multiplicator => re_multiplicator(17), ---  0.923889160156
            im_multiplicator => im_multiplicator(17), --- j-0.382690429688
            data_re_out => mul_re_out(17),
            data_im_out => mul_im_out(17)
        );

 
    UMUL_18 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(18),
            data_im_in => first_stage_im_out(18),
            re_multiplicator => re_multiplicator(18), ---  0.707092285156
            im_multiplicator => im_multiplicator(18), --- j-0.707092285156
            data_re_out => mul_re_out(18),
            data_im_out => mul_im_out(18)
        );

 
    UMUL_19 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(19),
            data_im_in => first_stage_im_out(19),
            re_multiplicator => re_multiplicator(19), ---  0.382690429688
            im_multiplicator => im_multiplicator(19), --- j-0.923889160156
            data_re_out => mul_re_out(19),
            data_im_out => mul_im_out(19)
        );

 
    UMUL_20 : multiplier_mulminusj
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(20),
            data_im_in => first_stage_im_out(20),
            data_re_out => mul_re_out(20),
            data_im_out => mul_im_out(20)
        );

 
    UMUL_21 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(21),
            data_im_in => first_stage_im_out(21),
            re_multiplicator => re_multiplicator(21), ---  -0.382690429688
            im_multiplicator => im_multiplicator(21), --- j-0.923889160156
            data_re_out => mul_re_out(21),
            data_im_out => mul_im_out(21)
        );

 
    UMUL_22 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(22),
            data_im_in => first_stage_im_out(22),
            re_multiplicator => re_multiplicator(22), ---  -0.707092285156
            im_multiplicator => im_multiplicator(22), --- j-0.707092285156
            data_re_out => mul_re_out(22),
            data_im_out => mul_im_out(22)
        );

 
    UMUL_23 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(23),
            data_im_in => first_stage_im_out(23),
            re_multiplicator => re_multiplicator(23), ---  -0.923889160156
            im_multiplicator => im_multiplicator(23), --- j-0.382690429688
            data_re_out => mul_re_out(23),
            data_im_out => mul_im_out(23)
        );

 
    UMUL_24 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
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
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(25),
            data_im_in => first_stage_im_out(25),
            re_multiplicator => re_multiplicator(25), ---  0.831481933594
            im_multiplicator => im_multiplicator(25), --- j-0.555541992188
            data_re_out => mul_re_out(25),
            data_im_out => mul_im_out(25)
        );

 
    UMUL_26 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(26),
            data_im_in => first_stage_im_out(26),
            re_multiplicator => re_multiplicator(26), ---  0.382690429688
            im_multiplicator => im_multiplicator(26), --- j-0.923889160156
            data_re_out => mul_re_out(26),
            data_im_out => mul_im_out(26)
        );

 
    UMUL_27 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(27),
            data_im_in => first_stage_im_out(27),
            re_multiplicator => re_multiplicator(27), ---  -0.195068359375
            im_multiplicator => im_multiplicator(27), --- j-0.980773925781
            data_re_out => mul_re_out(27),
            data_im_out => mul_im_out(27)
        );

 
    UMUL_28 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(28),
            data_im_in => first_stage_im_out(28),
            re_multiplicator => re_multiplicator(28), ---  -0.707092285156
            im_multiplicator => im_multiplicator(28), --- j-0.707092285156
            data_re_out => mul_re_out(28),
            data_im_out => mul_im_out(28)
        );

 
    UMUL_29 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(29),
            data_im_in => first_stage_im_out(29),
            re_multiplicator => re_multiplicator(29), ---  -0.980773925781
            im_multiplicator => im_multiplicator(29), --- j-0.195068359375
            data_re_out => mul_re_out(29),
            data_im_out => mul_im_out(29)
        );

 
    UMUL_30 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(30),
            data_im_in => first_stage_im_out(30),
            re_multiplicator => re_multiplicator(30), ---  -0.923889160156
            im_multiplicator => im_multiplicator(30), --- j0.382690429688
            data_re_out => mul_re_out(30),
            data_im_out => mul_im_out(30)
        );

 
    UMUL_31 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(3),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(31),
            data_im_in => first_stage_im_out(31),
            re_multiplicator => re_multiplicator(31), ---  -0.555541992188
            im_multiplicator => im_multiplicator(31), --- j0.831481933594
            data_re_out => mul_re_out(31),
            data_im_out => mul_im_out(31)
        );

end Behavioral;
