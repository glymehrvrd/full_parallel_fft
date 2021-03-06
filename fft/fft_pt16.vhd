library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt16 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        tmp_mul_re_out, tmp_mul_im_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_in     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_im_in     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_re_out    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_im_out    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end fft_pt16;

architecture Behavioral of fft_pt16 is

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
type ArrOfStdlogic is array (0 to 3, 0 to 3) of STD_LOGIC_VECTOR(15 downto 0);
signal re_multiplicator, im_multiplicator : ArrOfStdlogic;

signal first_stage_re_out, first_stage_im_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal mul_re_out, mul_im_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

begin
    --- multiplicator definition
    re_multiplicator(1,1) <= "0011101100100001"; ---  0.923889160156
    im_multiplicator(1,1) <= "1110011110000010"; --- j-0.382690429688
    re_multiplicator(1,2) <= "0010110101000001"; ---  0.707092285156
    im_multiplicator(1,2) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(1,3) <= "0001100001111110"; ---  0.382690429688
    im_multiplicator(1,3) <= "1100010011011111"; --- j-0.923889160156
    re_multiplicator(2,1) <= "0010110101000001"; ---  0.707092285156
    im_multiplicator(2,1) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(2,3) <= "1101001010111111"; ---  -0.707092285156
    im_multiplicator(2,3) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(3,1) <= "0001100001111110"; ---  0.382690429688
    im_multiplicator(3,1) <= "1100010011011111"; --- j-0.923889160156
    re_multiplicator(3,2) <= "1101001010111111"; ---  -0.707092285156
    im_multiplicator(3,2) <= "1101001010111111"; --- j-0.707092285156
    re_multiplicator(3,3) <= "1100010011011111"; ---  -0.923889160156
    im_multiplicator(3,3) <= "0001100001111110"; --- j0.382690429688

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
            bypass => bypass(3 DOWNTO 2),
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
            bypass => bypass(3 DOWNTO 2),
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
            bypass => bypass(3 DOWNTO 2),
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
            bypass => bypass(3 DOWNTO 2),
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
            bypass => bypass(1 DOWNTO 0),
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
            bypass => bypass(1 DOWNTO 0),
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
            bypass => bypass(1 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(8),
            data_re_in(1) => mul_re_out(9),
            data_re_in(2) => mul_re_out(10),
            data_re_in(3) => mul_re_out(11),
            data_im_in(0) => mul_im_out(8),
            data_im_in(1) => mul_im_out(9),
            data_im_in(2) => mul_im_out(10),
            data_im_in(3) => mul_im_out(11),
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
            bypass => bypass(1 DOWNTO 0),
            ctrl_delay => ctrl_delay,
            data_re_in(0) => mul_re_out(12),
            data_re_in(1) => mul_re_out(13),
            data_re_in(2) => mul_re_out(14),
            data_re_in(3) => mul_re_out(15),
            data_im_in(0) => mul_im_out(12),
            data_im_in(1) => mul_im_out(13),
            data_im_in(2) => mul_im_out(14),
            data_im_in(3) => mul_im_out(15),
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
            bypass => bypass(2),
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
            bypass => bypass(2),
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
            bypass => bypass(2),
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
            bypass => bypass(2),
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
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(4),
            data_im_in => first_stage_im_out(4),
            data_re_out => mul_re_out(4),
            data_im_out => mul_im_out(4)
        );

    UMUL_5 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(5),
            data_im_in => first_stage_im_out(5),
            re_multiplicator => re_multiplicator(1,1), ---  0.923889160156
            im_multiplicator => im_multiplicator(1,1), --- j-0.382690429688
            data_re_out => mul_re_out(5),
            data_im_out => mul_im_out(5)
        );

    UMUL_6 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(6),
            data_im_in => first_stage_im_out(6),
            re_multiplicator => re_multiplicator(1,2), ---  0.707092285156
            im_multiplicator => im_multiplicator(1,2), --- j-0.707092285156
            data_re_out => mul_re_out(6),
            data_im_out => mul_im_out(6)
        );

    UMUL_7 : complex_multiplier
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(7),
            data_im_in => first_stage_im_out(7),
            re_multiplicator => re_multiplicator(1,3), ---  0.382690429688
            im_multiplicator => im_multiplicator(1,3), --- j-0.923889160156
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
            bypass => bypass(2),
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
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(9),
            data_im_in => first_stage_im_out(9),
            re_multiplicator => re_multiplicator(2,1), ---  0.707092285156
            im_multiplicator => im_multiplicator(2,1), --- j-0.707092285156
            data_re_out => mul_re_out(9),
            data_im_out => mul_im_out(9)
        );

    UMUL_10 : multiplier_mulminusj
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(10),
            data_im_in => first_stage_im_out(10),
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
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(11),
            data_im_in => first_stage_im_out(11),
            re_multiplicator => re_multiplicator(2,3), ---  -0.707092285156
            im_multiplicator => im_multiplicator(2,3), --- j-0.707092285156
            data_re_out => mul_re_out(11),
            data_im_out => mul_im_out(11)
        );

    UMUL_12 : multiplier_mul1
    generic map(
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk => clk,
            rst => rst,
            ce => ce,
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(12),
            data_im_in => first_stage_im_out(12),
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
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(13),
            data_im_in => first_stage_im_out(13),
            re_multiplicator => re_multiplicator(3,1), ---  0.382690429688
            im_multiplicator => im_multiplicator(3,1), --- j-0.923889160156
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
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(14),
            data_im_in => first_stage_im_out(14),
            re_multiplicator => re_multiplicator(3,2), ---  -0.707092285156
            im_multiplicator => im_multiplicator(3,2), --- j-0.707092285156
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
            bypass => bypass(2),
            ctrl_delay => ctrl_delay,
            data_re_in => first_stage_re_out(15),
            data_im_in => first_stage_im_out(15),
            re_multiplicator => re_multiplicator(3,3), ---  -0.923889160156
            im_multiplicator => im_multiplicator(3,3), --- j0.382690429688
            data_re_out => mul_re_out(15),
            data_im_out => mul_im_out(15)
        );

end Behavioral;
