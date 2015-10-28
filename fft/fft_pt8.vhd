library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt8 is
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(7 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(7 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in:in std_logic_vector(7 downto 0);
        data_im_in:in std_logic_vector(7 downto 0);

        data_re_out:out std_logic_vector(7 downto 0);
        data_im_out:out std_logic_vector(7 downto 0)
    );
end fft_pt8;

architecture Behavioral of fft_pt8 is

component fft_pt4 is
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in:in std_logic_vector(3 downto 0);
        data_im_in:in std_logic_vector(3 downto 0);

        data_re_out:out std_logic_vector(3 downto 0);
        data_im_out:out std_logic_vector(3 downto 0)
    );
end component;

component fft_pt2 is
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in     : in std_logic_vector(1 downto 0);
        data_im_in     : in std_logic_vector(1 downto 0);

        data_re_out     : out std_logic_vector(1 downto 0);
        data_im_out     : out std_logic_vector(1 downto 0)
    );
end component;

component complex_multiplier is
    GENERIC (
        re_multiplicator : INTEGER;
        im_multiplicator : INTEGER
    );
    PORT (
        clk             : IN std_logic;
        rst             : IN std_logic;
        ce              : IN std_logic;
        ctrl            : IN STD_LOGIC;
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

signal first_stage_re_out, first_stage_im_out: std_logic_vector(7 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(7 downto 0);
signal shifter_re,shifter_im:std_logic_vector(7 downto 0);
SIGNAL ctrl_delay : std_logic_vector(1 DOWNTO 0);

begin

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;
    tmp_mul_re_out <= mul_re_out;
    tmp_mul_im_out <= mul_im_out;

    ctrl_delay(0) <= ctrl;
    --- buffer for ctrl
    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                ctrl_delay(1 DOWNTO 1) <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                ctrl_delay(1 DOWNTO 1) <= ctrl_delay(0 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;

    --- left-hand-side processors
    UFFT_PT4_0 : fft_pt4
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl,
            data_re_in(0)=>data_re_in(0),
            data_re_in(1)=>data_re_in(2),
            data_re_in(2)=>data_re_in(4),
            data_re_in(3)=>data_re_in(6),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(2),
            data_im_in(2)=>data_im_in(4),
            data_im_in(3)=>data_im_in(6),
            data_re_out=>first_stage_re_out(3 downto 0),
            data_im_out=>first_stage_im_out(3 downto 0)
        );

    UFFT_PT4_1 : fft_pt4
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl,
            data_re_in(0)=>data_re_in(1),
            data_re_in(1)=>data_re_in(3),
            data_re_in(2)=>data_re_in(5),
            data_re_in(3)=>data_re_in(7),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(3),
            data_im_in(2)=>data_im_in(5),
            data_im_in(3)=>data_im_in(7),
            data_re_out=>first_stage_re_out(7 downto 4),
            data_im_out=>first_stage_im_out(7 downto 4)
        );


    --- right-hand-side processors
    UFFT_PT2_0 : fft_pt2
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in(0)=>mul_re_out(0),
            data_re_in(1)=>mul_re_out(4),
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(4),
            data_re_out(0)=>data_re_out(0),
            data_re_out(1)=>data_re_out(4),
            data_im_out(0)=>data_im_out(0),
            data_im_out(1)=>data_im_out(4)
        );           

    UFFT_PT2_1 : fft_pt2
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in(0)=>mul_re_out(1),
            data_re_in(1)=>mul_re_out(5),
            data_im_in(0)=>mul_im_out(1),
            data_im_in(1)=>mul_im_out(5),
            data_re_out(0)=>data_re_out(1),
            data_re_out(1)=>data_re_out(5),
            data_im_out(0)=>data_im_out(1),
            data_im_out(1)=>data_im_out(5)
        );           

    UFFT_PT2_2 : fft_pt2
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in(0)=>mul_re_out(2),
            data_re_in(1)=>mul_re_out(6),
            data_im_in(0)=>mul_im_out(2),
            data_im_in(1)=>mul_im_out(6),
            data_re_out(0)=>data_re_out(2),
            data_re_out(1)=>data_re_out(6),
            data_im_out(0)=>data_im_out(2),
            data_im_out(1)=>data_im_out(6)
        );           

    UFFT_PT2_3 : fft_pt2
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in(0)=>mul_re_out(3),
            data_re_in(1)=>mul_re_out(7),
            data_im_in(0)=>mul_im_out(3),
            data_im_in(1)=>mul_im_out(7),
            data_re_out(0)=>data_re_out(3),
            data_re_out(1)=>data_re_out(7),
            data_im_out(0)=>data_im_out(3),
            data_im_out(1)=>data_im_out(7)
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
            ctrl=>ctrl_delay(1),
            data_in=>shifter_re(0),
            data_out=>mul_re_out(0)
        );
    USHIFTER_0_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
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
            ctrl=>ctrl_delay(1),
            data_in=>shifter_re(1),
            data_out=>mul_re_out(1)
        );
    USHIFTER_1_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
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
            ctrl=>ctrl_delay(1),
            data_in=>shifter_re(2),
            data_out=>mul_re_out(2)
        );
    USHIFTER_2_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
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
            ctrl=>ctrl_delay(1),
            data_in=>shifter_re(3),
            data_out=>mul_re_out(3)
        );
    USHIFTER_3_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
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
            ctrl=>ctrl_delay(1),
            data_in=>shifter_re(4),
            data_out=>mul_re_out(4)
        );
    USHIFTER_4_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_in=>shifter_im(4),
            data_out=>mul_im_out(4)
        );

    UMUL_5 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in=>first_stage_re_out(5),
            data_im_in=>first_stage_im_out(5),
            product_re_out=>mul_re_out(5),
            product_im_out=>mul_im_out(5)
        );

    UMUL_6 : complex_multiplier
    generic map(
            re_multiplicator=>0, --- 0.0 + j-1.0
            im_multiplicator=>-16384
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in=>first_stage_re_out(6),
            data_im_in=>first_stage_im_out(6),
            product_re_out=>mul_re_out(6),
            product_im_out=>mul_im_out(6)
        );

    UMUL_7 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(1),
            data_re_in=>first_stage_re_out(7),
            data_im_in=>first_stage_im_out(7),
            product_re_out=>mul_re_out(7),
            product_im_out=>mul_im_out(7)
        );

end Behavioral;
