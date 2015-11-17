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

component Dff_regN is
    GENERIC( N: INTEGER );
    Port (
            D : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            Q : out  STD_LOGIC
        );
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
        preload  : IN STD_LOGIC;
        Q        : OUT STD_LOGIC;
        QN       : OUT STD_LOGIC
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

signal first_stage_re_out, first_stage_im_out: std_logic_vector(15 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(15 downto 0);
signal shifter_re,shifter_im:std_logic_vector(15 downto 0);
signal not_first_stage_re_out: std_logic_vector(15 downto 0);
signal opp_first_stage_re_out: std_logic_vector(15 downto 0);
signal c: std_logic_vector(15 downto 0);
signal c_buff: std_logic_vector(15 downto 0);


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
            data_re_in(1)=>data_re_in(4),
            data_re_in(2)=>data_re_in(8),
            data_re_in(3)=>data_re_in(12),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(4),
            data_im_in(2)=>data_im_in(8),
            data_im_in(3)=>data_im_in(12),
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
            data_re_in(1)=>data_re_in(5),
            data_re_in(2)=>data_re_in(9),
            data_re_in(3)=>data_re_in(13),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(5),
            data_im_in(2)=>data_im_in(9),
            data_im_in(3)=>data_im_in(13),
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
            data_re_in(1)=>data_re_in(6),
            data_re_in(2)=>data_re_in(10),
            data_re_in(3)=>data_re_in(14),
            data_im_in(0)=>data_im_in(2),
            data_im_in(1)=>data_im_in(6),
            data_im_in(2)=>data_im_in(10),
            data_im_in(3)=>data_im_in(14),
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
            data_re_in(1)=>data_re_in(7),
            data_re_in(2)=>data_re_in(11),
            data_re_in(3)=>data_re_in(15),
            data_im_in(0)=>data_im_in(3),
            data_im_in(1)=>data_im_in(7),
            data_im_in(2)=>data_im_in(11),
            data_im_in(3)=>data_im_in(15),
            data_re_out=>first_stage_re_out(15 downto 12),
            data_im_out=>first_stage_im_out(15 downto 12)
        );


    --- right-hand-side processors
    URFFT_PT4_0 : fft_pt4
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
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(4),
            data_im_in(2)=>mul_im_out(8),
            data_im_in(3)=>mul_im_out(12),
            data_re_out(0)=>data_re_out(0),
            data_re_out(1)=>data_re_out(4),
            data_re_out(2)=>data_re_out(8),
            data_re_out(3)=>data_re_out(12),
            data_im_out(0)=>data_im_out(0),
            data_im_out(1)=>data_im_out(4),
            data_im_out(2)=>data_im_out(8),
            data_im_out(3)=>data_im_out(12)
        );           

    URFFT_PT4_1 : fft_pt4
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
            data_im_in(0)=>mul_im_out(1),
            data_im_in(1)=>mul_im_out(5),
            data_im_in(2)=>mul_im_out(9),
            data_im_in(3)=>mul_im_out(13),
            data_re_out(0)=>data_re_out(1),
            data_re_out(1)=>data_re_out(5),
            data_re_out(2)=>data_re_out(9),
            data_re_out(3)=>data_re_out(13),
            data_im_out(0)=>data_im_out(1),
            data_im_out(1)=>data_im_out(5),
            data_im_out(2)=>data_im_out(9),
            data_im_out(3)=>data_im_out(13)
        );           

    URFFT_PT4_2 : fft_pt4
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
            data_im_in(0)=>mul_im_out(2),
            data_im_in(1)=>mul_im_out(6),
            data_im_in(2)=>mul_im_out(10),
            data_im_in(3)=>mul_im_out(14),
            data_re_out(0)=>data_re_out(2),
            data_re_out(1)=>data_re_out(6),
            data_re_out(2)=>data_re_out(10),
            data_re_out(3)=>data_re_out(14),
            data_im_out(0)=>data_im_out(2),
            data_im_out(1)=>data_im_out(6),
            data_im_out(2)=>data_im_out(10),
            data_im_out(3)=>data_im_out(14)
        );           

    URFFT_PT4_3 : fft_pt4
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
            data_im_in(0)=>mul_im_out(3),
            data_im_in(1)=>mul_im_out(7),
            data_im_in(2)=>mul_im_out(11),
            data_im_in(3)=>mul_im_out(15),
            data_re_out(0)=>data_re_out(3),
            data_re_out(1)=>data_re_out(7),
            data_re_out(2)=>data_re_out(11),
            data_re_out(3)=>data_re_out(15),
            data_im_out(0)=>data_im_out(3),
            data_im_out(1)=>data_im_out(7),
            data_im_out(2)=>data_im_out(11),
            data_im_out(3)=>data_im_out(15)
        );           


    --- multipliers
    USHIFTER_0_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(0),
            data_out=>shifter_re(0)
        );
    USHIFTER_0_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(0),
            data_out=>shifter_im(0)
        );
    UDELAY_0_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(0),
            clk=>clk,
            Q=>mul_re_out(0)
        );
    UDELAY_0_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(0),
            clk=>clk,
            Q=>mul_im_out(0)
        );

    USHIFTER_1_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(1),
            data_out=>shifter_re(1)
        );
    USHIFTER_1_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(1),
            data_out=>shifter_im(1)
        );
    UDELAY_1_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(1),
            clk=>clk,
            Q=>mul_re_out(1)
        );
    UDELAY_1_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(1),
            clk=>clk,
            Q=>mul_im_out(1)
        );

    USHIFTER_2_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(2),
            data_out=>shifter_re(2)
        );
    USHIFTER_2_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(2),
            data_out=>shifter_im(2)
        );
    UDELAY_2_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(2),
            clk=>clk,
            Q=>mul_re_out(2)
        );
    UDELAY_2_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(2),
            clk=>clk,
            Q=>mul_im_out(2)
        );

    USHIFTER_3_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(3),
            data_out=>shifter_re(3)
        );
    USHIFTER_3_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(3),
            data_out=>shifter_im(3)
        );
    UDELAY_3_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(3),
            clk=>clk,
            Q=>mul_re_out(3)
        );
    UDELAY_3_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(3),
            clk=>clk,
            Q=>mul_im_out(3)
        );

    USHIFTER_4_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(4),
            data_out=>shifter_re(4)
        );
    USHIFTER_4_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(4),
            data_out=>shifter_im(4)
        );
    UDELAY_4_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(4),
            clk=>clk,
            Q=>mul_re_out(4)
        );
    UDELAY_4_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(4),
            clk=>clk,
            Q=>mul_im_out(4)
        );

    UMUL_5 : complex_multiplier
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
            data_re_in=>first_stage_re_out(5),
            data_im_in=>first_stage_im_out(5),
            product_re_out=>mul_re_out(5),
            product_im_out=>mul_im_out(5)
        );

    UMUL_6 : complex_multiplier
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
            data_re_in=>first_stage_re_out(6),
            data_im_in=>first_stage_im_out(6),
            product_re_out=>mul_re_out(6),
            product_im_out=>mul_im_out(6)
        );

    UMUL_7 : complex_multiplier
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
            data_re_in=>first_stage_re_out(7),
            data_im_in=>first_stage_im_out(7),
            product_re_out=>mul_re_out(7),
            product_im_out=>mul_im_out(7)
        );

    USHIFTER_8_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(8),
            data_out=>shifter_re(8)
        );
    USHIFTER_8_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(8),
            data_out=>shifter_im(8)
        );
    UDELAY_8_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(8),
            clk=>clk,
            Q=>mul_re_out(8)
        );
    UDELAY_8_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(8),
            clk=>clk,
            Q=>mul_im_out(8)
        );

    UMUL_9 : complex_multiplier
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
            data_re_in=>first_stage_re_out(9),
            data_im_in=>first_stage_im_out(9),
            product_re_out=>mul_re_out(9),
            product_im_out=>mul_im_out(9)
        );

    not_first_stage_re_out(10) <= not first_stage_re_out(10);
    C_BUFF_10 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(10), 
        clk      => clk, 
        preload  => ctrl_delay((ctrl_start+1) mod 16), 
        Q        => c_buff(10)
    );
    ADDER_10 : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff(10), 
        data2_in  => not_first_stage_re_out(10), 
        sum_out   => opp_first_stage_re_out(10), 
        c_out     => c(10)
    );
    USHIFTER_10_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(10),
            data_out=>shifter_re(10)
        );
    USHIFTER_10_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>opp_first_stage_re_out(10),
            data_out=>shifter_im(10)
        );
    UDELAY_10_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(10),
            clk=>clk,
            Q=>mul_re_out(10)
        );
    UDELAY_10_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(10),
            clk=>clk,
            Q=>mul_im_out(10)
        );

    UMUL_11 : complex_multiplier
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
            data_re_in=>first_stage_re_out(11),
            data_im_in=>first_stage_im_out(11),
            product_re_out=>mul_re_out(11),
            product_im_out=>mul_im_out(11)
        );

    USHIFTER_12_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_re_out(12),
            data_out=>shifter_re(12)
        );
    USHIFTER_12_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+1) mod 16),
            data_in=>first_stage_im_out(12),
            data_out=>shifter_im(12)
        );
    UDELAY_12_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_re(12),
            clk=>clk,
            Q=>mul_re_out(12)
        );
    UDELAY_12_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>shifter_im(12),
            clk=>clk,
            Q=>mul_im_out(12)
        );

    UMUL_13 : complex_multiplier
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
            data_re_in=>first_stage_re_out(13),
            data_im_in=>first_stage_im_out(13),
            product_re_out=>mul_re_out(13),
            product_im_out=>mul_im_out(13)
        );

    UMUL_14 : complex_multiplier
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
            data_re_in=>first_stage_re_out(14),
            data_im_in=>first_stage_im_out(14),
            product_re_out=>mul_re_out(14),
            product_im_out=>mul_im_out(14)
        );

    UMUL_15 : complex_multiplier
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
            data_re_in=>first_stage_re_out(15),
            data_im_in=>first_stage_im_out(15),
            product_re_out=>mul_re_out(15),
            product_im_out=>mul_im_out(15)
        );

end Behavioral;
