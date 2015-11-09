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
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in     : in std_logic_vector(7 downto 0);
        data_im_in     : in std_logic_vector(7 downto 0);

        data_re_out     : out std_logic_vector(7 downto 0);
        data_im_out     : out std_logic_vector(7 downto 0)
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

component Dff_regN is
    GENERIC( N: INTEGER );
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ce  : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end component;

component shifter is
    port(
            clk            : IN STD_LOGIC;
            rst            : IN STD_LOGIC;
            ce             : IN STD_LOGIC;
            ctrl           : IN STD_LOGIC;
            data_in:in std_logic;
            data_out:out std_logic
        );
end component;

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

component adder_half_bit1
    PORT (
        data1_in  : IN STD_LOGIC;
        data2_in  : IN STD_LOGIC;
        sum_out   : OUT STD_LOGIC;
        c_out     : OUT STD_LOGIC
    );
end component;

signal first_stage_re_out, first_stage_im_out: std_logic_vector(31 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(31 downto 0);
signal shifter_re,shifter_im:std_logic_vector(31 downto 0);
signal not_first_stage_re_out: std_logic_vector(31 downto 0);
signal opp_first_stage_re_out: std_logic_vector(31 downto 0);
signal c: std_logic_vector(31 downto 0);
signal c_buff: std_logic_vector(31 downto 0);


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
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(0),
            data_re_in(1)=>data_re_in(8),
            data_re_in(2)=>data_re_in(16),
            data_re_in(3)=>data_re_in(24),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(8),
            data_im_in(2)=>data_im_in(16),
            data_im_in(3)=>data_im_in(24),
            data_re_out=>first_stage_re_out(3 downto 0),
            data_im_out=>first_stage_im_out(3 downto 0)
        );

    ULFFT_PT4_1 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(1),
            data_re_in(1)=>data_re_in(9),
            data_re_in(2)=>data_re_in(17),
            data_re_in(3)=>data_re_in(25),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(9),
            data_im_in(2)=>data_im_in(17),
            data_im_in(3)=>data_im_in(25),
            data_re_out=>first_stage_re_out(7 downto 4),
            data_im_out=>first_stage_im_out(7 downto 4)
        );

    ULFFT_PT4_2 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(2),
            data_re_in(1)=>data_re_in(10),
            data_re_in(2)=>data_re_in(18),
            data_re_in(3)=>data_re_in(26),
            data_im_in(0)=>data_im_in(2),
            data_im_in(1)=>data_im_in(10),
            data_im_in(2)=>data_im_in(18),
            data_im_in(3)=>data_im_in(26),
            data_re_out=>first_stage_re_out(11 downto 8),
            data_im_out=>first_stage_im_out(11 downto 8)
        );

    ULFFT_PT4_3 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(3),
            data_re_in(1)=>data_re_in(11),
            data_re_in(2)=>data_re_in(19),
            data_re_in(3)=>data_re_in(27),
            data_im_in(0)=>data_im_in(3),
            data_im_in(1)=>data_im_in(11),
            data_im_in(2)=>data_im_in(19),
            data_im_in(3)=>data_im_in(27),
            data_re_out=>first_stage_re_out(15 downto 12),
            data_im_out=>first_stage_im_out(15 downto 12)
        );

    ULFFT_PT4_4 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(4),
            data_re_in(1)=>data_re_in(12),
            data_re_in(2)=>data_re_in(20),
            data_re_in(3)=>data_re_in(28),
            data_im_in(0)=>data_im_in(4),
            data_im_in(1)=>data_im_in(12),
            data_im_in(2)=>data_im_in(20),
            data_im_in(3)=>data_im_in(28),
            data_re_out=>first_stage_re_out(19 downto 16),
            data_im_out=>first_stage_im_out(19 downto 16)
        );

    ULFFT_PT4_5 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(5),
            data_re_in(1)=>data_re_in(13),
            data_re_in(2)=>data_re_in(21),
            data_re_in(3)=>data_re_in(29),
            data_im_in(0)=>data_im_in(5),
            data_im_in(1)=>data_im_in(13),
            data_im_in(2)=>data_im_in(21),
            data_im_in(3)=>data_im_in(29),
            data_re_out=>first_stage_re_out(23 downto 20),
            data_im_out=>first_stage_im_out(23 downto 20)
        );

    ULFFT_PT4_6 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(6),
            data_re_in(1)=>data_re_in(14),
            data_re_in(2)=>data_re_in(22),
            data_re_in(3)=>data_re_in(30),
            data_im_in(0)=>data_im_in(6),
            data_im_in(1)=>data_im_in(14),
            data_im_in(2)=>data_im_in(22),
            data_im_in(3)=>data_im_in(30),
            data_re_out=>first_stage_re_out(27 downto 24),
            data_im_out=>first_stage_im_out(27 downto 24)
        );

    ULFFT_PT4_7 : fft_pt4
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(7),
            data_re_in(1)=>data_re_in(15),
            data_re_in(2)=>data_re_in(23),
            data_re_in(3)=>data_re_in(31),
            data_im_in(0)=>data_im_in(7),
            data_im_in(1)=>data_im_in(15),
            data_im_in(2)=>data_im_in(23),
            data_im_in(3)=>data_im_in(31),
            data_re_out=>first_stage_re_out(31 downto 28),
            data_im_out=>first_stage_im_out(31 downto 28)
        );


    --- right-hand-side processors
    URFFT_PT8_0 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(0),
            data_re_in(1)=>mul_re_out(4),
            data_re_in(2)=>mul_re_out(8),
            data_re_in(3)=>mul_re_out(12),
            data_re_in(4)=>mul_re_out(16),
            data_re_in(5)=>mul_re_out(20),
            data_re_in(6)=>mul_re_out(24),
            data_re_in(7)=>mul_re_out(28),
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(4),
            data_im_in(2)=>mul_im_out(8),
            data_im_in(3)=>mul_im_out(12),
            data_im_in(4)=>mul_im_out(16),
            data_im_in(5)=>mul_im_out(20),
            data_im_in(6)=>mul_im_out(24),
            data_im_in(7)=>mul_im_out(28),
            data_re_out(0)=>data_re_out(0),
            data_re_out(1)=>data_re_out(4),
            data_re_out(2)=>data_re_out(8),
            data_re_out(3)=>data_re_out(12),
            data_re_out(4)=>data_re_out(16),
            data_re_out(5)=>data_re_out(20),
            data_re_out(6)=>data_re_out(24),
            data_re_out(7)=>data_re_out(28),
            data_im_out(0)=>data_im_out(0),
            data_im_out(1)=>data_im_out(4),
            data_im_out(2)=>data_im_out(8),
            data_im_out(3)=>data_im_out(12),
            data_im_out(4)=>data_im_out(16),
            data_im_out(5)=>data_im_out(20),
            data_im_out(6)=>data_im_out(24),
            data_im_out(7)=>data_im_out(28)
        );           

    URFFT_PT8_1 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(1),
            data_re_in(1)=>mul_re_out(5),
            data_re_in(2)=>mul_re_out(9),
            data_re_in(3)=>mul_re_out(13),
            data_re_in(4)=>mul_re_out(17),
            data_re_in(5)=>mul_re_out(21),
            data_re_in(6)=>mul_re_out(25),
            data_re_in(7)=>mul_re_out(29),
            data_im_in(0)=>mul_im_out(1),
            data_im_in(1)=>mul_im_out(5),
            data_im_in(2)=>mul_im_out(9),
            data_im_in(3)=>mul_im_out(13),
            data_im_in(4)=>mul_im_out(17),
            data_im_in(5)=>mul_im_out(21),
            data_im_in(6)=>mul_im_out(25),
            data_im_in(7)=>mul_im_out(29),
            data_re_out(0)=>data_re_out(1),
            data_re_out(1)=>data_re_out(5),
            data_re_out(2)=>data_re_out(9),
            data_re_out(3)=>data_re_out(13),
            data_re_out(4)=>data_re_out(17),
            data_re_out(5)=>data_re_out(21),
            data_re_out(6)=>data_re_out(25),
            data_re_out(7)=>data_re_out(29),
            data_im_out(0)=>data_im_out(1),
            data_im_out(1)=>data_im_out(5),
            data_im_out(2)=>data_im_out(9),
            data_im_out(3)=>data_im_out(13),
            data_im_out(4)=>data_im_out(17),
            data_im_out(5)=>data_im_out(21),
            data_im_out(6)=>data_im_out(25),
            data_im_out(7)=>data_im_out(29)
        );           

    URFFT_PT8_2 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(2),
            data_re_in(1)=>mul_re_out(6),
            data_re_in(2)=>mul_re_out(10),
            data_re_in(3)=>mul_re_out(14),
            data_re_in(4)=>mul_re_out(18),
            data_re_in(5)=>mul_re_out(22),
            data_re_in(6)=>mul_re_out(26),
            data_re_in(7)=>mul_re_out(30),
            data_im_in(0)=>mul_im_out(2),
            data_im_in(1)=>mul_im_out(6),
            data_im_in(2)=>mul_im_out(10),
            data_im_in(3)=>mul_im_out(14),
            data_im_in(4)=>mul_im_out(18),
            data_im_in(5)=>mul_im_out(22),
            data_im_in(6)=>mul_im_out(26),
            data_im_in(7)=>mul_im_out(30),
            data_re_out(0)=>data_re_out(2),
            data_re_out(1)=>data_re_out(6),
            data_re_out(2)=>data_re_out(10),
            data_re_out(3)=>data_re_out(14),
            data_re_out(4)=>data_re_out(18),
            data_re_out(5)=>data_re_out(22),
            data_re_out(6)=>data_re_out(26),
            data_re_out(7)=>data_re_out(30),
            data_im_out(0)=>data_im_out(2),
            data_im_out(1)=>data_im_out(6),
            data_im_out(2)=>data_im_out(10),
            data_im_out(3)=>data_im_out(14),
            data_im_out(4)=>data_im_out(18),
            data_im_out(5)=>data_im_out(22),
            data_im_out(6)=>data_im_out(26),
            data_im_out(7)=>data_im_out(30)
        );           

    URFFT_PT8_3 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(3),
            data_re_in(1)=>mul_re_out(7),
            data_re_in(2)=>mul_re_out(11),
            data_re_in(3)=>mul_re_out(15),
            data_re_in(4)=>mul_re_out(19),
            data_re_in(5)=>mul_re_out(23),
            data_re_in(6)=>mul_re_out(27),
            data_re_in(7)=>mul_re_out(31),
            data_im_in(0)=>mul_im_out(3),
            data_im_in(1)=>mul_im_out(7),
            data_im_in(2)=>mul_im_out(11),
            data_im_in(3)=>mul_im_out(15),
            data_im_in(4)=>mul_im_out(19),
            data_im_in(5)=>mul_im_out(23),
            data_im_in(6)=>mul_im_out(27),
            data_im_in(7)=>mul_im_out(31),
            data_re_out(0)=>data_re_out(3),
            data_re_out(1)=>data_re_out(7),
            data_re_out(2)=>data_re_out(11),
            data_re_out(3)=>data_re_out(15),
            data_re_out(4)=>data_re_out(19),
            data_re_out(5)=>data_re_out(23),
            data_re_out(6)=>data_re_out(27),
            data_re_out(7)=>data_re_out(31),
            data_im_out(0)=>data_im_out(3),
            data_im_out(1)=>data_im_out(7),
            data_im_out(2)=>data_im_out(11),
            data_im_out(3)=>data_im_out(15),
            data_im_out(4)=>data_im_out(19),
            data_im_out(5)=>data_im_out(23),
            data_im_out(6)=>data_im_out(27),
            data_im_out(7)=>data_im_out(31)
        );           


    --- multipliers
    UDELAY_0_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(0),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(0)
        );
    UDELAY_0_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(0),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(0)
        );
    USHIFTER_0_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(0),
            data_out=>mul_re_out(0)
        );
    USHIFTER_0_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(0),
            data_out=>mul_im_out(0)
        );

    UDELAY_1_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(1),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(1)
        );
    UDELAY_1_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(1),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(1)
        );
    USHIFTER_1_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(1),
            data_out=>mul_re_out(1)
        );
    USHIFTER_1_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(1),
            data_out=>mul_im_out(1)
        );

    UDELAY_2_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(2),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(2)
        );
    UDELAY_2_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(2),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(2)
        );
    USHIFTER_2_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(2),
            data_out=>mul_re_out(2)
        );
    USHIFTER_2_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(2),
            data_out=>mul_im_out(2)
        );

    UDELAY_3_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(3),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(3)
        );
    UDELAY_3_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(3),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(3)
        );
    USHIFTER_3_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(3),
            data_out=>mul_re_out(3)
        );
    USHIFTER_3_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(3),
            data_out=>mul_im_out(3)
        );

    UDELAY_4_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(4),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(4)
        );
    UDELAY_4_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(4),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(4)
        );
    USHIFTER_4_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(4),
            data_out=>mul_re_out(4)
        );
    USHIFTER_4_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(4),
            data_out=>mul_im_out(4)
        );

    UMUL_5 : complex_multiplier
    generic map(
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(5),
            data_im_in=>first_stage_im_out(5),
            product_re_out=>mul_re_out(5),
            product_im_out=>mul_im_out(5)
        );

    UMUL_6 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(6),
            data_im_in=>first_stage_im_out(6),
            product_re_out=>mul_re_out(6),
            product_im_out=>mul_im_out(6)
        );

    UMUL_7 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(7),
            data_im_in=>first_stage_im_out(7),
            product_re_out=>mul_re_out(7),
            product_im_out=>mul_im_out(7)
        );

    UDELAY_8_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(8),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(8)
        );
    UDELAY_8_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(8),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(8)
        );
    USHIFTER_8_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(8),
            data_out=>mul_re_out(8)
        );
    USHIFTER_8_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(8),
            data_out=>mul_im_out(8)
        );

    UMUL_9 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(9),
            data_im_in=>first_stage_im_out(9),
            product_re_out=>mul_re_out(9),
            product_im_out=>mul_im_out(9)
        );

    UMUL_10 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(10),
            data_im_in=>first_stage_im_out(10),
            product_re_out=>mul_re_out(10),
            product_im_out=>mul_im_out(10)
        );

    UMUL_11 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(11),
            data_im_in=>first_stage_im_out(11),
            product_re_out=>mul_re_out(11),
            product_im_out=>mul_im_out(11)
        );

    UDELAY_12_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(12),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(12)
        );
    UDELAY_12_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(12),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(12)
        );
    USHIFTER_12_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(12),
            data_out=>mul_re_out(12)
        );
    USHIFTER_12_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(12),
            data_out=>mul_im_out(12)
        );

    UMUL_13 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(13),
            data_im_in=>first_stage_im_out(13),
            product_re_out=>mul_re_out(13),
            product_im_out=>mul_im_out(13)
        );

    UMUL_14 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(14),
            data_im_in=>first_stage_im_out(14),
            product_re_out=>mul_re_out(14),
            product_im_out=>mul_im_out(14)
        );

    UMUL_15 : complex_multiplier
    generic map(
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(15),
            data_im_in=>first_stage_im_out(15),
            product_re_out=>mul_re_out(15),
            product_im_out=>mul_im_out(15)
        );

    UDELAY_16_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(16),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(16)
        );
    UDELAY_16_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(16),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(16)
        );
    USHIFTER_16_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(16),
            data_out=>mul_re_out(16)
        );
    USHIFTER_16_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(16),
            data_out=>mul_im_out(16)
        );

    UMUL_17 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(17),
            data_im_in=>first_stage_im_out(17),
            product_re_out=>mul_re_out(17),
            product_im_out=>mul_im_out(17)
        );

    not_first_stage_re_out(18) <= not first_stage_re_out(18);
    C_BUFF_18 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(18), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl_delay((ctrl_start+1) mod 16), 
        Q        => c_buff(18)
    );
    ADDER_18 : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff(18), 
        data2_in  => not_first_stage_re_out(18), 
        sum_out   => opp_first_stage_re_out(18), 
        c_out     => c(18)
    );
    UDELAY_18_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(18),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(18)
        );
    UDELAY_18_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>opp_first_stage_re_out(18),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(18)
        );
    USHIFTER_18_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(18),
            data_out=>mul_re_out(18)
        );
    USHIFTER_18_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(18),
            data_out=>mul_im_out(18)
        );

    UMUL_19 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(19),
            data_im_in=>first_stage_im_out(19),
            product_re_out=>mul_re_out(19),
            product_im_out=>mul_im_out(19)
        );

    UDELAY_20_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(20),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(20)
        );
    UDELAY_20_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(20),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(20)
        );
    USHIFTER_20_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(20),
            data_out=>mul_re_out(20)
        );
    USHIFTER_20_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(20),
            data_out=>mul_im_out(20)
        );

    UMUL_21 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(21),
            data_im_in=>first_stage_im_out(21),
            product_re_out=>mul_re_out(21),
            product_im_out=>mul_im_out(21)
        );

    UMUL_22 : complex_multiplier
    generic map(
            re_multiplicator=>-6269, --- -0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(22),
            data_im_in=>first_stage_im_out(22),
            product_re_out=>mul_re_out(22),
            product_im_out=>mul_im_out(22)
        );

    UMUL_23 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(23),
            data_im_in=>first_stage_im_out(23),
            product_re_out=>mul_re_out(23),
            product_im_out=>mul_im_out(23)
        );

    UDELAY_24_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(24),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(24)
        );
    UDELAY_24_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(24),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(24)
        );
    USHIFTER_24_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(24),
            data_out=>mul_re_out(24)
        );
    USHIFTER_24_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(24),
            data_out=>mul_im_out(24)
        );

    UMUL_25 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(25),
            data_im_in=>first_stage_im_out(25),
            product_re_out=>mul_re_out(25),
            product_im_out=>mul_im_out(25)
        );

    UMUL_26 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(26),
            data_im_in=>first_stage_im_out(26),
            product_re_out=>mul_re_out(26),
            product_im_out=>mul_im_out(26)
        );

    UMUL_27 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j0.382629394531
            im_multiplicator=>6269,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(27),
            data_im_in=>first_stage_im_out(27),
            product_re_out=>mul_re_out(27),
            product_im_out=>mul_im_out(27)
        );

    UDELAY_28_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(28),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_re(28)
        );
    UDELAY_28_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(28),
            clk=>clk,
            ce=>ce,
            rst=>rst,
            Q=>shifter_im(28)
        );
    USHIFTER_28_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_re(28),
            data_out=>mul_re_out(28)
        );
    USHIFTER_28_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>shifter_im(28),
            data_out=>mul_im_out(28)
        );

    UMUL_29 : complex_multiplier
    generic map(
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(29),
            data_im_in=>first_stage_im_out(29),
            product_re_out=>mul_re_out(29),
            product_im_out=>mul_im_out(29)
        );

    UMUL_30 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(30),
            data_im_in=>first_stage_im_out(30),
            product_re_out=>mul_re_out(30),
            product_im_out=>mul_im_out(30)
        );

    UMUL_31 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j0.831420898438
            im_multiplicator=>13622,
            ctrl_start => (ctrl_start+1) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(31),
            data_im_in=>first_stage_im_out(31),
            product_re_out=>mul_re_out(31),
            product_im_out=>mul_im_out(31)
        );

end Behavioral;
