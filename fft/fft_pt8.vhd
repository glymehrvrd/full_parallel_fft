library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt8 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(7 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(7 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(2 downto 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(7 downto 0);
        data_im_in:in std_logic_vector(7 downto 0);

        data_re_out:out std_logic_vector(7 downto 0);
        data_im_out:out std_logic_vector(7 downto 0)
    );
end fft_pt8;

architecture Behavioral of fft_pt8 is

component fft_pt2 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(1 downto 0);
        data_im_in:in std_logic_vector(1 downto 0);

        data_re_out:out std_logic_vector(1 downto 0);
        data_im_out:out std_logic_vector(1 downto 0)
    );
end component;

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

        data_re_in     : in std_logic_vector(3 downto 0);
        data_im_in     : in std_logic_vector(3 downto 0);

        data_re_out     : out std_logic_vector(3 downto 0);
        data_im_out     : out std_logic_vector(3 downto 0)
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

signal first_stage_re_out, first_stage_im_out: std_logic_vector(7 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(7 downto 0);


begin

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;
    tmp_mul_re_out <= mul_re_out;
    tmp_mul_im_out <= mul_im_out;

    --- left-hand-side processors
    ULFFT_PT2_0 : fft_pt2
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(0),
            data_re_in(1) => data_re_in(4),
            data_im_in(0) => data_im_in(0),
            data_im_in(1) => data_im_in(4),
            data_re_out(0) => first_stage_re_out(0),
            data_re_out(1) => first_stage_re_out(4),
            data_im_out(0) => first_stage_im_out(0),
            data_im_out(1) => first_stage_im_out(4)
        );

    ULFFT_PT2_1 : fft_pt2
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(1),
            data_re_in(1) => data_re_in(5),
            data_im_in(0) => data_im_in(1),
            data_im_in(1) => data_im_in(5),
            data_re_out(0) => first_stage_re_out(1),
            data_re_out(1) => first_stage_re_out(5),
            data_im_out(0) => first_stage_im_out(1),
            data_im_out(1) => first_stage_im_out(5)
        );

    ULFFT_PT2_2 : fft_pt2
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(2),
            data_re_in(1) => data_re_in(6),
            data_im_in(0) => data_im_in(2),
            data_im_in(1) => data_im_in(6),
            data_re_out(0) => first_stage_re_out(2),
            data_re_out(1) => first_stage_re_out(6),
            data_im_out(0) => first_stage_im_out(2),
            data_im_out(1) => first_stage_im_out(6)
        );

    ULFFT_PT2_3 : fft_pt2
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(3),
            data_re_in(1) => data_re_in(7),
            data_im_in(0) => data_im_in(3),
            data_im_in(1) => data_im_in(7),
            data_re_out(0) => first_stage_re_out(3),
            data_re_out(1) => first_stage_re_out(7),
            data_im_out(0) => first_stage_im_out(3),
            data_im_out(1) => first_stage_im_out(7)
        );


    --- right-hand-side processors
    URFFT_PT4_0 : fft_pt4
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(1 downto 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(0),
            data_re_in(1) => mul_re_out(1),
            data_re_in(2) => mul_re_out(2),
            data_re_in(3) => mul_re_out(3),
            data_im_in(0) => mul_im_out(0),
            data_im_in(1) => mul_im_out(1),
            data_im_in(2) => mul_im_out(2),
            data_im_in(3) => mul_im_out(3),
            data_re_out(0) => data_re_out(0),
            data_re_out(1) => data_re_out(2),
            data_re_out(2) => data_re_out(4),
            data_re_out(3) => data_re_out(6),
            data_im_out(0) => data_im_out(0),
            data_im_out(1) => data_im_out(2),
            data_im_out(2) => data_im_out(4),
            data_im_out(3) => data_im_out(6)
        );           

    URFFT_PT4_1 : fft_pt4
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(1 downto 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(4),
            data_re_in(1) => mul_re_out(5),
            data_re_in(2) => mul_re_out(6),
            data_re_in(3) => mul_re_out(7),
            data_im_in(0) => mul_im_out(4),
            data_im_in(1) => mul_im_out(5),
            data_im_in(2) => mul_im_out(6),
            data_im_in(3) => mul_im_out(7),
            data_re_out(0) => data_re_out(1),
            data_re_out(1) => data_re_out(3),
            data_re_out(2) => data_re_out(5),
            data_re_out(3) => data_re_out(7),
            data_im_out(0) => data_im_out(1),
            data_im_out(1) => data_im_out(3),
            data_im_out(2) => data_im_out(5),
            data_im_out(3) => data_im_out(7)
        );           


    --- multipliers
 
    UMUL_0 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+1) mod 16
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
            ctrl_start => (ctrl_start+1) mod 16
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
            ctrl_start => (ctrl_start+1) mod 16
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
            ctrl_start => (ctrl_start+1) mod 16
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
            ctrl_start => (ctrl_start+1) mod 16
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

 
    UMUL_5 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(5),
            data_im_in => first_stage_im_out(5),
            re_multiplicator => "0010110101000001", --- 0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            product_re_out => mul_re_out(5),
            product_im_out => mul_im_out(5)
        );

 
    UMUL_6 : multiplier_mulminusj
    generic map(
            ctrl_start => (ctrl_start+1) mod 16
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

 
    UMUL_7 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(7),
            data_im_in => first_stage_im_out(7),
            re_multiplicator => "1101001010111111", --- -0.707092285156 + j-0.707092285156
            im_multiplicator => "1101001010111111",
            product_re_out => mul_re_out(7),
            product_im_out => mul_im_out(7)
        );

end Behavioral;
