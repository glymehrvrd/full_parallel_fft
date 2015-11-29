library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt16 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(15 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(15 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(15 downto 0);
        data_im_in:in std_logic_vector(15 downto 0);

        data_re_out:out std_logic_vector(15 downto 0);
        data_im_out:out std_logic_vector(15 downto 0)
    );
end fft_pt16;

architecture Behavioral of fft_pt16 is

component fft_pt4 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(3 downto 0);
        data_im_in:in std_logic_vector(3 downto 0);

        data_re_out:out std_logic_vector(3 downto 0);
        data_im_out:out std_logic_vector(3 downto 0)
    );
end component;


component complex_multiplier is
    GENERIC (
        re_multiplicator : INTEGER;
        im_multiplicator : INTEGER;
        ctrl_start       : INTEGER
    );
    PORT (
        clk             : IN std_logic;
        rst             : IN std_logic;
        ce              : IN std_logic;
        ctrl_delay      : IN STD_LOGIC_VECTOR(15 downto 0);
        data_re_in      : IN std_logic;
        data_im_in      : IN std_logic;
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

signal first_stage_re_out, first_stage_im_out: std_logic_vector(15 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(15 downto 0);


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
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(0),
            data_re_in(1) => data_re_in(4),
            data_re_in(2) => data_re_in(8),
            data_re_in(3) => data_re_in(12),
            data_im_in(0) => data_im_in(0),
            data_im_in(1) => data_im_in(4),
            data_im_in(2) => data_im_in(8),
            data_im_in(3) => data_im_in(12),
            data_re_out(0) => first_stage_re_out(0),
            data_re_out(1) => first_stage_re_out(4),
            data_re_out(2) => first_stage_re_out(8),
            data_re_out(3) => first_stage_re_out(12),
            data_im_out(0) => first_stage_im_out(0),
            data_im_out(1) => first_stage_im_out(4),
            data_im_out(2) => first_stage_im_out(8),
            data_im_out(3) => first_stage_im_out(12)
        );

    ULFFT_PT4_1 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(1),
            data_re_in(1) => data_re_in(5),
            data_re_in(2) => data_re_in(9),
            data_re_in(3) => data_re_in(13),
            data_im_in(0) => data_im_in(1),
            data_im_in(1) => data_im_in(5),
            data_im_in(2) => data_im_in(9),
            data_im_in(3) => data_im_in(13),
            data_re_out(0) => first_stage_re_out(1),
            data_re_out(1) => first_stage_re_out(5),
            data_re_out(2) => first_stage_re_out(9),
            data_re_out(3) => first_stage_re_out(13),
            data_im_out(0) => first_stage_im_out(1),
            data_im_out(1) => first_stage_im_out(5),
            data_im_out(2) => first_stage_im_out(9),
            data_im_out(3) => first_stage_im_out(13)
        );

    ULFFT_PT4_2 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(2),
            data_re_in(1) => data_re_in(6),
            data_re_in(2) => data_re_in(10),
            data_re_in(3) => data_re_in(14),
            data_im_in(0) => data_im_in(2),
            data_im_in(1) => data_im_in(6),
            data_im_in(2) => data_im_in(10),
            data_im_in(3) => data_im_in(14),
            data_re_out(0) => first_stage_re_out(2),
            data_re_out(1) => first_stage_re_out(6),
            data_re_out(2) => first_stage_re_out(10),
            data_re_out(3) => first_stage_re_out(14),
            data_im_out(0) => first_stage_im_out(2),
            data_im_out(1) => first_stage_im_out(6),
            data_im_out(2) => first_stage_im_out(10),
            data_im_out(3) => first_stage_im_out(14)
        );

    ULFFT_PT4_3 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0) => data_re_in(3),
            data_re_in(1) => data_re_in(7),
            data_re_in(2) => data_re_in(11),
            data_re_in(3) => data_re_in(15),
            data_im_in(0) => data_im_in(3),
            data_im_in(1) => data_im_in(7),
            data_im_in(2) => data_im_in(11),
            data_im_in(3) => data_im_in(15),
            data_re_out(0) => first_stage_re_out(3),
            data_re_out(1) => first_stage_re_out(7),
            data_re_out(2) => first_stage_re_out(11),
            data_re_out(3) => first_stage_re_out(15),
            data_im_out(0) => first_stage_im_out(3),
            data_im_out(1) => first_stage_im_out(7),
            data_im_out(2) => first_stage_im_out(11),
            data_im_out(3) => first_stage_im_out(15)
        );


    --- right-hand-side processors
    URFFT_PT4_0 : fft_pt4
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0)=>mul_re_out(0),
            data_re_in(1)=>mul_re_out(1),
            data_re_in(2)=>mul_re_out(2),
            data_re_in(3)=>mul_re_out(3),
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(1),
            data_im_in(2)=>mul_im_out(2),
            data_im_in(3)=>mul_im_out(3),
            data_re_out(0) => data_re_out(0),
            data_re_out(1) => data_re_out(4),
            data_re_out(2) => data_re_out(8),
            data_re_out(3) => data_re_out(12),
            data_im_out(0) => data_im_out(0),
            data_im_out(1) => data_im_out(4),
            data_im_out(2) => data_im_out(8),
            data_im_out(3) => data_im_out(12)
        );           

    URFFT_PT4_1 : fft_pt4
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0)=>mul_re_out(4),
            data_re_in(1)=>mul_re_out(5),
            data_re_in(2)=>mul_re_out(6),
            data_re_in(3)=>mul_re_out(7),
            data_im_in(0)=>mul_im_out(4),
            data_im_in(1)=>mul_im_out(5),
            data_im_in(2)=>mul_im_out(6),
            data_im_in(3)=>mul_im_out(7),
            data_re_out(0) => data_re_out(1),
            data_re_out(1) => data_re_out(5),
            data_re_out(2) => data_re_out(9),
            data_re_out(3) => data_re_out(13),
            data_im_out(0) => data_im_out(1),
            data_im_out(1) => data_im_out(5),
            data_im_out(2) => data_im_out(9),
            data_im_out(3) => data_im_out(13)
        );           

    URFFT_PT4_2 : fft_pt4
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0)=>mul_re_out(8),
            data_re_in(1)=>mul_re_out(9),
            data_re_in(2)=>mul_re_out(10),
            data_re_in(3)=>mul_re_out(11),
            data_im_in(0)=>mul_im_out(8),
            data_im_in(1)=>mul_im_out(9),
            data_im_in(2)=>mul_im_out(10),
            data_im_in(3)=>mul_im_out(11),
            data_re_out(0) => data_re_out(2),
            data_re_out(1) => data_re_out(6),
            data_re_out(2) => data_re_out(10),
            data_re_out(3) => data_re_out(14),
            data_im_out(0) => data_im_out(2),
            data_im_out(1) => data_im_out(6),
            data_im_out(2) => data_im_out(10),
            data_im_out(3) => data_im_out(14)
        );           

    URFFT_PT4_3 : fft_pt4
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in(0)=>mul_re_out(12),
            data_re_in(1)=>mul_re_out(13),
            data_re_in(2)=>mul_re_out(14),
            data_re_in(3)=>mul_re_out(15),
            data_im_in(0)=>mul_im_out(12),
            data_im_in(1)=>mul_im_out(13),
            data_im_in(2)=>mul_im_out(14),
            data_im_in(3)=>mul_im_out(15),
            data_re_out(0) => data_re_out(3),
            data_re_out(1) => data_re_out(7),
            data_re_out(2) => data_re_out(11),
            data_re_out(3) => data_re_out(15),
            data_im_out(0) => data_im_out(3),
            data_im_out(1) => data_im_out(7),
            data_im_out(2) => data_im_out(11),
            data_im_out(3) => data_im_out(15)
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

 
    UMUL_5 : complex_multiplier
    generic map(
            re_multiplicator => 15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator => -6269,
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

 
    UMUL_6 : complex_multiplier
    generic map(
            re_multiplicator => 11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator => -11585,
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

 
    UMUL_7 : complex_multiplier
    generic map(
            re_multiplicator => 6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator => -15136,
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
            re_multiplicator => 11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator => -11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(9),
            data_im_in => first_stage_im_out(9),
            product_re_out => mul_re_out(9),
            product_im_out => mul_im_out(9)
        );

 
    UMUL_10 : multiplier_mulminusj
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
            product_re_out => mul_re_out(10),
            product_im_out => mul_im_out(10)
        );

 
    UMUL_11 : complex_multiplier
    generic map(
            re_multiplicator => -11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator => -11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(11),
            data_im_in => first_stage_im_out(11),
            product_re_out => mul_re_out(11),
            product_im_out => mul_im_out(11)
        );

 
    UMUL_12 : multiplier_mul1
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
            product_re_out => mul_re_out(12),
            product_im_out => mul_im_out(12)
        );

 
    UMUL_13 : complex_multiplier
    generic map(
            re_multiplicator => 6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator => -15136,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(13),
            data_im_in => first_stage_im_out(13),
            product_re_out => mul_re_out(13),
            product_im_out => mul_im_out(13)
        );

 
    UMUL_14 : complex_multiplier
    generic map(
            re_multiplicator => -11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator => -11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(14),
            data_im_in => first_stage_im_out(14),
            product_re_out => mul_re_out(14),
            product_im_out => mul_im_out(14)
        );

 
    UMUL_15 : complex_multiplier
    generic map(
            re_multiplicator => -15136, --- -0.923828125 + j0.382629394531
            im_multiplicator => 6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(15),
            data_im_in => first_stage_im_out(15),
            product_re_out => mul_re_out(15),
            product_im_out => mul_im_out(15)
        );

end Behavioral;
