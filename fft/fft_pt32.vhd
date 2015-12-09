library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt32 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(31 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(31 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(4 downto 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(31 downto 0);
        data_im_in:in std_logic_vector(31 downto 0);

        data_re_out:out std_logic_vector(31 downto 0);
        data_im_out:out std_logic_vector(31 downto 0)
    );
end fft_pt32;

architecture Behavioral of fft_pt32 is

component fft_pt4 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(1 downto 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(3 downto 0);
        data_im_in:in std_logic_vector(3 downto 0);

        data_re_out:out std_logic_vector(3 downto 0);
        data_im_out:out std_logic_vector(3 downto 0)
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
        bypass         : IN STD_LOGIC_VECTOR(2 downto 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in     : in std_logic_vector(7 downto 0);
        data_im_in     : in std_logic_vector(7 downto 0);

        data_re_out     : out std_logic_vector(7 downto 0);
        data_im_out     : out std_logic_vector(7 downto 0)
    );
end component;

component complex_multiplier is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk             : IN std_logic;
        rst             : IN std_logic;
        ce              : IN std_logic;
        ctrl_delay      : IN STD_LOGIC_VECTOR(15 downto 0);
        data_re_in      : IN std_logic;
        data_im_in      : IN std_logic;
        re_multiplicator: IN std_logic_vector(15 DOWNTO 0);
        im_multiplicator: IN std_logic_vector(15 DOWNTO 0);
        product_re_out  : OUT STD_LOGIC;
        product_im_out  : OUT STD_LOGIC
    );
end component;

component multiplier_mul1 IS
    GENERIC (
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
END component;

component multiplier_mulminusj IS
    GENERIC (
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
END component;

COMPONENT Dff_regN_Nout IS
    GENERIC (N : INTEGER);
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        QN   : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END COMPONENT;

signal first_stage_re_out, first_stage_im_out: std_logic_vector(31 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(31 downto 0);


begin

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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(4 downto 3),
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
            bypass => bypass(2 downto 0),
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
            bypass => bypass(2 downto 0),
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
            bypass => bypass(2 downto 0),
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
            bypass => bypass(2 downto 0),
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
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(0),
            data_im_in => first_stage_im_out(0),
            product_re_out => mul_re_out(0),
            product_im_out => mul_im_out(0)
        );

 
    UMUL_1 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(1),
            data_im_in => first_stage_im_out(1),
            product_re_out => mul_re_out(1),
            product_im_out => mul_im_out(1)
        );

 
    UMUL_2 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(2),
            data_im_in => first_stage_im_out(2),
            product_re_out => mul_re_out(2),
            product_im_out => mul_im_out(2)
        );

 
    UMUL_3 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(3),
            data_im_in => first_stage_im_out(3),
            product_re_out => mul_re_out(3),
            product_im_out => mul_im_out(3)
        );

 
    UMUL_4 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(4),
            data_im_in => first_stage_im_out(4),
            product_re_out => mul_re_out(4),
            product_im_out => mul_im_out(4)
        );

 
    UMUL_5 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(5),
            data_im_in => first_stage_im_out(5),
            product_re_out => mul_re_out(5),
            product_im_out => mul_im_out(5)
        );

 
    UMUL_6 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(6),
            data_im_in => first_stage_im_out(6),
            product_re_out => mul_re_out(6),
            product_im_out => mul_im_out(6)
        );

 
    UMUL_7 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(7),
            data_im_in => first_stage_im_out(7),
            product_re_out => mul_re_out(7),
            product_im_out => mul_im_out(7)
        );

 
    UMUL_8 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(8),
            data_im_in => first_stage_im_out(8),
            product_re_out => mul_re_out(8),
            product_im_out => mul_im_out(8)
        );

 
    UMUL_9 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(9),
            data_im_in => first_stage_im_out(9),
            re_multiplicator => "0011111011000101", --- 0.980773925781 + j-0.195068359375
            im_multiplicator => "1111001110000100",
            product_re_out => mul_re_out(9),
            product_im_out => mul_im_out(9)
        );

 
    UMUL_10 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(10),
            data_im_in => first_stage_im_out(10),
            re_multiplicator => "0011101100100000", --- 0.923828125 + j-0.382629394531
            im_multiplicator => "1110011110000011",
            product_re_out => mul_re_out(10),
            product_im_out => mul_im_out(10)
        );

 
    UMUL_11 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(11),
            data_im_in => first_stage_im_out(11),
            re_multiplicator => "0011010100110110", --- 0.831420898438 + j-0.555541992188
            im_multiplicator => "1101110001110010",
            product_re_out => mul_re_out(11),
            product_im_out => mul_im_out(11)
        );

 
    UMUL_12 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(12),
            data_im_in => first_stage_im_out(12),
            re_multiplicator => "0010110101000001", --- 0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            product_re_out => mul_re_out(12),
            product_im_out => mul_im_out(12)
        );

 
    UMUL_13 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(13),
            data_im_in => first_stage_im_out(13),
            re_multiplicator => "0010001110001110", --- 0.555541992188 + j-0.831420898438
            im_multiplicator => "1100101011001010",
            product_re_out => mul_re_out(13),
            product_im_out => mul_im_out(13)
        );

 
    UMUL_14 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(14),
            data_im_in => first_stage_im_out(14),
            re_multiplicator => "0001100001111101", --- 0.382629394531 + j-0.923828125
            im_multiplicator => "1100010011100000",
            product_re_out => mul_re_out(14),
            product_im_out => mul_im_out(14)
        );

 
    UMUL_15 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(15),
            data_im_in => first_stage_im_out(15),
            re_multiplicator => "0000110001111100", --- 0.195068359375 + j-0.980773925781
            im_multiplicator => "1100000100111011",
            product_re_out => mul_re_out(15),
            product_im_out => mul_im_out(15)
        );

 
    UMUL_16 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(16),
            data_im_in => first_stage_im_out(16),
            product_re_out => mul_re_out(16),
            product_im_out => mul_im_out(16)
        );

 
    UMUL_17 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(17),
            data_im_in => first_stage_im_out(17),
            re_multiplicator => "0011101100100000", --- 0.923828125 + j-0.382629394531
            im_multiplicator => "1110011110000011",
            product_re_out => mul_re_out(17),
            product_im_out => mul_im_out(17)
        );

 
    UMUL_18 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(18),
            data_im_in => first_stage_im_out(18),
            re_multiplicator => "0010110101000001", --- 0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            product_re_out => mul_re_out(18),
            product_im_out => mul_im_out(18)
        );

 
    UMUL_19 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(19),
            data_im_in => first_stage_im_out(19),
            re_multiplicator => "0001100001111101", --- 0.382629394531 + j-0.923828125
            im_multiplicator => "1100010011100000",
            product_re_out => mul_re_out(19),
            product_im_out => mul_im_out(19)
        );

 
    UMUL_20 : multiplier_mulminusj
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(20),
            data_im_in => first_stage_im_out(20),
            product_re_out => mul_re_out(20),
            product_im_out => mul_im_out(20)
        );

 
    UMUL_21 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(21),
            data_im_in => first_stage_im_out(21),
            re_multiplicator => "1110011110000011", --- -0.382629394531 + j-0.923828125
            im_multiplicator => "1100010011100000",
            product_re_out => mul_re_out(21),
            product_im_out => mul_im_out(21)
        );

 
    UMUL_22 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(22),
            data_im_in => first_stage_im_out(22),
            re_multiplicator => "1101001010111111", --- -0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            product_re_out => mul_re_out(22),
            product_im_out => mul_im_out(22)
        );

 
    UMUL_23 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(23),
            data_im_in => first_stage_im_out(23),
            re_multiplicator => "1100010011100000", --- -0.923828125 + j-0.382629394531
            im_multiplicator => "1110011110000011",
            product_re_out => mul_re_out(23),
            product_im_out => mul_im_out(23)
        );

 
    UMUL_24 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(24),
            data_im_in => first_stage_im_out(24),
            product_re_out => mul_re_out(24),
            product_im_out => mul_im_out(24)
        );

 
    UMUL_25 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(25),
            data_im_in => first_stage_im_out(25),
            re_multiplicator => "0011010100110110", --- 0.831420898438 + j-0.555541992188
            im_multiplicator => "1101110001110010",
            product_re_out => mul_re_out(25),
            product_im_out => mul_im_out(25)
        );

 
    UMUL_26 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(26),
            data_im_in => first_stage_im_out(26),
            re_multiplicator => "0001100001111101", --- 0.382629394531 + j-0.923828125
            im_multiplicator => "1100010011100000",
            product_re_out => mul_re_out(26),
            product_im_out => mul_im_out(26)
        );

 
    UMUL_27 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(27),
            data_im_in => first_stage_im_out(27),
            re_multiplicator => "1111001110000100", --- -0.195068359375 + j-0.980773925781
            im_multiplicator => "1100000100111011",
            product_re_out => mul_re_out(27),
            product_im_out => mul_im_out(27)
        );

 
    UMUL_28 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(28),
            data_im_in => first_stage_im_out(28),
            re_multiplicator => "1101001010111111", --- -0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            product_re_out => mul_re_out(28),
            product_im_out => mul_im_out(28)
        );

 
    UMUL_29 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(29),
            data_im_in => first_stage_im_out(29),
            re_multiplicator => "1100000100111011", --- -0.980773925781 + j-0.195068359375
            im_multiplicator => "1111001110000100",
            product_re_out => mul_re_out(29),
            product_im_out => mul_im_out(29)
        );

 
    UMUL_30 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(30),
            data_im_in => first_stage_im_out(30),
            re_multiplicator => "1100010011100000", --- -0.923828125 + j0.382629394531
            im_multiplicator => "0001100001111101",
            product_re_out => mul_re_out(30),
            product_im_out => mul_im_out(30)
        );

 
    UMUL_31 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(31),
            data_im_in => first_stage_im_out(31),
            re_multiplicator => "1101110001110010", --- -0.555541992188 + j0.831420898438
            im_multiplicator => "0011010100110110",
            product_re_out => mul_re_out(31),
            product_im_out => mul_im_out(31)
        );

end Behavioral;
