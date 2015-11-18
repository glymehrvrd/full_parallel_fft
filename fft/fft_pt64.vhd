library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt64 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(63 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(63 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(63 downto 0);
        data_im_in:in std_logic_vector(63 downto 0);

        data_re_out:out std_logic_vector(63 downto 0);
        data_im_out:out std_logic_vector(63 downto 0)
    );
end fft_pt64;

architecture Behavioral of fft_pt64 is

component fft_pt8 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(7 downto 0);
        data_im_in:in std_logic_vector(7 downto 0);

        data_re_out:out std_logic_vector(7 downto 0);
        data_im_out:out std_logic_vector(7 downto 0)
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
            Q : out  STD_LOGIC;
            QN : out STD_LOGIC
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

signal first_stage_re_out, first_stage_im_out: std_logic_vector(63 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(63 downto 0);
signal shifter_re,shifter_im:std_logic_vector(63 downto 0);
signal not_first_stage_re_out: std_logic_vector(63 downto 0);
signal opp_first_stage_re_out: std_logic_vector(63 downto 0);
signal c: std_logic_vector(63 downto 0);
signal c_buff: std_logic_vector(63 downto 0);


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
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(0),
            data_re_in(1)=>data_re_in(8),
            data_re_in(2)=>data_re_in(16),
            data_re_in(3)=>data_re_in(24),
            data_re_in(4)=>data_re_in(32),
            data_re_in(5)=>data_re_in(40),
            data_re_in(6)=>data_re_in(48),
            data_re_in(7)=>data_re_in(56),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(8),
            data_im_in(2)=>data_im_in(16),
            data_im_in(3)=>data_im_in(24),
            data_im_in(4)=>data_im_in(32),
            data_im_in(5)=>data_im_in(40),
            data_im_in(6)=>data_im_in(48),
            data_im_in(7)=>data_im_in(56),
            data_re_out=>first_stage_re_out(7 downto 0),
            data_im_out=>first_stage_im_out(7 downto 0)
        );

    ULFFT_PT8_1 : fft_pt8
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
            data_re_in(4)=>data_re_in(33),
            data_re_in(5)=>data_re_in(41),
            data_re_in(6)=>data_re_in(49),
            data_re_in(7)=>data_re_in(57),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(9),
            data_im_in(2)=>data_im_in(17),
            data_im_in(3)=>data_im_in(25),
            data_im_in(4)=>data_im_in(33),
            data_im_in(5)=>data_im_in(41),
            data_im_in(6)=>data_im_in(49),
            data_im_in(7)=>data_im_in(57),
            data_re_out=>first_stage_re_out(15 downto 8),
            data_im_out=>first_stage_im_out(15 downto 8)
        );

    ULFFT_PT8_2 : fft_pt8
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
            data_re_in(4)=>data_re_in(34),
            data_re_in(5)=>data_re_in(42),
            data_re_in(6)=>data_re_in(50),
            data_re_in(7)=>data_re_in(58),
            data_im_in(0)=>data_im_in(2),
            data_im_in(1)=>data_im_in(10),
            data_im_in(2)=>data_im_in(18),
            data_im_in(3)=>data_im_in(26),
            data_im_in(4)=>data_im_in(34),
            data_im_in(5)=>data_im_in(42),
            data_im_in(6)=>data_im_in(50),
            data_im_in(7)=>data_im_in(58),
            data_re_out=>first_stage_re_out(23 downto 16),
            data_im_out=>first_stage_im_out(23 downto 16)
        );

    ULFFT_PT8_3 : fft_pt8
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
            data_re_in(4)=>data_re_in(35),
            data_re_in(5)=>data_re_in(43),
            data_re_in(6)=>data_re_in(51),
            data_re_in(7)=>data_re_in(59),
            data_im_in(0)=>data_im_in(3),
            data_im_in(1)=>data_im_in(11),
            data_im_in(2)=>data_im_in(19),
            data_im_in(3)=>data_im_in(27),
            data_im_in(4)=>data_im_in(35),
            data_im_in(5)=>data_im_in(43),
            data_im_in(6)=>data_im_in(51),
            data_im_in(7)=>data_im_in(59),
            data_re_out=>first_stage_re_out(31 downto 24),
            data_im_out=>first_stage_im_out(31 downto 24)
        );

    ULFFT_PT8_4 : fft_pt8
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
            data_re_in(4)=>data_re_in(36),
            data_re_in(5)=>data_re_in(44),
            data_re_in(6)=>data_re_in(52),
            data_re_in(7)=>data_re_in(60),
            data_im_in(0)=>data_im_in(4),
            data_im_in(1)=>data_im_in(12),
            data_im_in(2)=>data_im_in(20),
            data_im_in(3)=>data_im_in(28),
            data_im_in(4)=>data_im_in(36),
            data_im_in(5)=>data_im_in(44),
            data_im_in(6)=>data_im_in(52),
            data_im_in(7)=>data_im_in(60),
            data_re_out=>first_stage_re_out(39 downto 32),
            data_im_out=>first_stage_im_out(39 downto 32)
        );

    ULFFT_PT8_5 : fft_pt8
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
            data_re_in(4)=>data_re_in(37),
            data_re_in(5)=>data_re_in(45),
            data_re_in(6)=>data_re_in(53),
            data_re_in(7)=>data_re_in(61),
            data_im_in(0)=>data_im_in(5),
            data_im_in(1)=>data_im_in(13),
            data_im_in(2)=>data_im_in(21),
            data_im_in(3)=>data_im_in(29),
            data_im_in(4)=>data_im_in(37),
            data_im_in(5)=>data_im_in(45),
            data_im_in(6)=>data_im_in(53),
            data_im_in(7)=>data_im_in(61),
            data_re_out=>first_stage_re_out(47 downto 40),
            data_im_out=>first_stage_im_out(47 downto 40)
        );

    ULFFT_PT8_6 : fft_pt8
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
            data_re_in(4)=>data_re_in(38),
            data_re_in(5)=>data_re_in(46),
            data_re_in(6)=>data_re_in(54),
            data_re_in(7)=>data_re_in(62),
            data_im_in(0)=>data_im_in(6),
            data_im_in(1)=>data_im_in(14),
            data_im_in(2)=>data_im_in(22),
            data_im_in(3)=>data_im_in(30),
            data_im_in(4)=>data_im_in(38),
            data_im_in(5)=>data_im_in(46),
            data_im_in(6)=>data_im_in(54),
            data_im_in(7)=>data_im_in(62),
            data_re_out=>first_stage_re_out(55 downto 48),
            data_im_out=>first_stage_im_out(55 downto 48)
        );

    ULFFT_PT8_7 : fft_pt8
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
            data_re_in(4)=>data_re_in(39),
            data_re_in(5)=>data_re_in(47),
            data_re_in(6)=>data_re_in(55),
            data_re_in(7)=>data_re_in(63),
            data_im_in(0)=>data_im_in(7),
            data_im_in(1)=>data_im_in(15),
            data_im_in(2)=>data_im_in(23),
            data_im_in(3)=>data_im_in(31),
            data_im_in(4)=>data_im_in(39),
            data_im_in(5)=>data_im_in(47),
            data_im_in(6)=>data_im_in(55),
            data_im_in(7)=>data_im_in(63),
            data_re_out=>first_stage_re_out(63 downto 56),
            data_im_out=>first_stage_im_out(63 downto 56)
        );


    --- right-hand-side processors
    URFFT_PT8_0 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(0),
            data_re_in(1)=>mul_re_out(8),
            data_re_in(2)=>mul_re_out(16),
            data_re_in(3)=>mul_re_out(24),
            data_re_in(4)=>mul_re_out(32),
            data_re_in(5)=>mul_re_out(40),
            data_re_in(6)=>mul_re_out(48),
            data_re_in(7)=>mul_re_out(56),
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(8),
            data_im_in(2)=>mul_im_out(16),
            data_im_in(3)=>mul_im_out(24),
            data_im_in(4)=>mul_im_out(32),
            data_im_in(5)=>mul_im_out(40),
            data_im_in(6)=>mul_im_out(48),
            data_im_in(7)=>mul_im_out(56),
            data_re_out(0)=>data_re_out(0),
            data_re_out(1)=>data_re_out(8),
            data_re_out(2)=>data_re_out(16),
            data_re_out(3)=>data_re_out(24),
            data_re_out(4)=>data_re_out(32),
            data_re_out(5)=>data_re_out(40),
            data_re_out(6)=>data_re_out(48),
            data_re_out(7)=>data_re_out(56),
            data_im_out(0)=>data_im_out(0),
            data_im_out(1)=>data_im_out(8),
            data_im_out(2)=>data_im_out(16),
            data_im_out(3)=>data_im_out(24),
            data_im_out(4)=>data_im_out(32),
            data_im_out(5)=>data_im_out(40),
            data_im_out(6)=>data_im_out(48),
            data_im_out(7)=>data_im_out(56)
        );           

    URFFT_PT8_1 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(1),
            data_re_in(1)=>mul_re_out(9),
            data_re_in(2)=>mul_re_out(17),
            data_re_in(3)=>mul_re_out(25),
            data_re_in(4)=>mul_re_out(33),
            data_re_in(5)=>mul_re_out(41),
            data_re_in(6)=>mul_re_out(49),
            data_re_in(7)=>mul_re_out(57),
            data_im_in(0)=>mul_im_out(1),
            data_im_in(1)=>mul_im_out(9),
            data_im_in(2)=>mul_im_out(17),
            data_im_in(3)=>mul_im_out(25),
            data_im_in(4)=>mul_im_out(33),
            data_im_in(5)=>mul_im_out(41),
            data_im_in(6)=>mul_im_out(49),
            data_im_in(7)=>mul_im_out(57),
            data_re_out(0)=>data_re_out(1),
            data_re_out(1)=>data_re_out(9),
            data_re_out(2)=>data_re_out(17),
            data_re_out(3)=>data_re_out(25),
            data_re_out(4)=>data_re_out(33),
            data_re_out(5)=>data_re_out(41),
            data_re_out(6)=>data_re_out(49),
            data_re_out(7)=>data_re_out(57),
            data_im_out(0)=>data_im_out(1),
            data_im_out(1)=>data_im_out(9),
            data_im_out(2)=>data_im_out(17),
            data_im_out(3)=>data_im_out(25),
            data_im_out(4)=>data_im_out(33),
            data_im_out(5)=>data_im_out(41),
            data_im_out(6)=>data_im_out(49),
            data_im_out(7)=>data_im_out(57)
        );           

    URFFT_PT8_2 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(2),
            data_re_in(1)=>mul_re_out(10),
            data_re_in(2)=>mul_re_out(18),
            data_re_in(3)=>mul_re_out(26),
            data_re_in(4)=>mul_re_out(34),
            data_re_in(5)=>mul_re_out(42),
            data_re_in(6)=>mul_re_out(50),
            data_re_in(7)=>mul_re_out(58),
            data_im_in(0)=>mul_im_out(2),
            data_im_in(1)=>mul_im_out(10),
            data_im_in(2)=>mul_im_out(18),
            data_im_in(3)=>mul_im_out(26),
            data_im_in(4)=>mul_im_out(34),
            data_im_in(5)=>mul_im_out(42),
            data_im_in(6)=>mul_im_out(50),
            data_im_in(7)=>mul_im_out(58),
            data_re_out(0)=>data_re_out(2),
            data_re_out(1)=>data_re_out(10),
            data_re_out(2)=>data_re_out(18),
            data_re_out(3)=>data_re_out(26),
            data_re_out(4)=>data_re_out(34),
            data_re_out(5)=>data_re_out(42),
            data_re_out(6)=>data_re_out(50),
            data_re_out(7)=>data_re_out(58),
            data_im_out(0)=>data_im_out(2),
            data_im_out(1)=>data_im_out(10),
            data_im_out(2)=>data_im_out(18),
            data_im_out(3)=>data_im_out(26),
            data_im_out(4)=>data_im_out(34),
            data_im_out(5)=>data_im_out(42),
            data_im_out(6)=>data_im_out(50),
            data_im_out(7)=>data_im_out(58)
        );           

    URFFT_PT8_3 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(3),
            data_re_in(1)=>mul_re_out(11),
            data_re_in(2)=>mul_re_out(19),
            data_re_in(3)=>mul_re_out(27),
            data_re_in(4)=>mul_re_out(35),
            data_re_in(5)=>mul_re_out(43),
            data_re_in(6)=>mul_re_out(51),
            data_re_in(7)=>mul_re_out(59),
            data_im_in(0)=>mul_im_out(3),
            data_im_in(1)=>mul_im_out(11),
            data_im_in(2)=>mul_im_out(19),
            data_im_in(3)=>mul_im_out(27),
            data_im_in(4)=>mul_im_out(35),
            data_im_in(5)=>mul_im_out(43),
            data_im_in(6)=>mul_im_out(51),
            data_im_in(7)=>mul_im_out(59),
            data_re_out(0)=>data_re_out(3),
            data_re_out(1)=>data_re_out(11),
            data_re_out(2)=>data_re_out(19),
            data_re_out(3)=>data_re_out(27),
            data_re_out(4)=>data_re_out(35),
            data_re_out(5)=>data_re_out(43),
            data_re_out(6)=>data_re_out(51),
            data_re_out(7)=>data_re_out(59),
            data_im_out(0)=>data_im_out(3),
            data_im_out(1)=>data_im_out(11),
            data_im_out(2)=>data_im_out(19),
            data_im_out(3)=>data_im_out(27),
            data_im_out(4)=>data_im_out(35),
            data_im_out(5)=>data_im_out(43),
            data_im_out(6)=>data_im_out(51),
            data_im_out(7)=>data_im_out(59)
        );           

    URFFT_PT8_4 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(4),
            data_re_in(1)=>mul_re_out(12),
            data_re_in(2)=>mul_re_out(20),
            data_re_in(3)=>mul_re_out(28),
            data_re_in(4)=>mul_re_out(36),
            data_re_in(5)=>mul_re_out(44),
            data_re_in(6)=>mul_re_out(52),
            data_re_in(7)=>mul_re_out(60),
            data_im_in(0)=>mul_im_out(4),
            data_im_in(1)=>mul_im_out(12),
            data_im_in(2)=>mul_im_out(20),
            data_im_in(3)=>mul_im_out(28),
            data_im_in(4)=>mul_im_out(36),
            data_im_in(5)=>mul_im_out(44),
            data_im_in(6)=>mul_im_out(52),
            data_im_in(7)=>mul_im_out(60),
            data_re_out(0)=>data_re_out(4),
            data_re_out(1)=>data_re_out(12),
            data_re_out(2)=>data_re_out(20),
            data_re_out(3)=>data_re_out(28),
            data_re_out(4)=>data_re_out(36),
            data_re_out(5)=>data_re_out(44),
            data_re_out(6)=>data_re_out(52),
            data_re_out(7)=>data_re_out(60),
            data_im_out(0)=>data_im_out(4),
            data_im_out(1)=>data_im_out(12),
            data_im_out(2)=>data_im_out(20),
            data_im_out(3)=>data_im_out(28),
            data_im_out(4)=>data_im_out(36),
            data_im_out(5)=>data_im_out(44),
            data_im_out(6)=>data_im_out(52),
            data_im_out(7)=>data_im_out(60)
        );           

    URFFT_PT8_5 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(5),
            data_re_in(1)=>mul_re_out(13),
            data_re_in(2)=>mul_re_out(21),
            data_re_in(3)=>mul_re_out(29),
            data_re_in(4)=>mul_re_out(37),
            data_re_in(5)=>mul_re_out(45),
            data_re_in(6)=>mul_re_out(53),
            data_re_in(7)=>mul_re_out(61),
            data_im_in(0)=>mul_im_out(5),
            data_im_in(1)=>mul_im_out(13),
            data_im_in(2)=>mul_im_out(21),
            data_im_in(3)=>mul_im_out(29),
            data_im_in(4)=>mul_im_out(37),
            data_im_in(5)=>mul_im_out(45),
            data_im_in(6)=>mul_im_out(53),
            data_im_in(7)=>mul_im_out(61),
            data_re_out(0)=>data_re_out(5),
            data_re_out(1)=>data_re_out(13),
            data_re_out(2)=>data_re_out(21),
            data_re_out(3)=>data_re_out(29),
            data_re_out(4)=>data_re_out(37),
            data_re_out(5)=>data_re_out(45),
            data_re_out(6)=>data_re_out(53),
            data_re_out(7)=>data_re_out(61),
            data_im_out(0)=>data_im_out(5),
            data_im_out(1)=>data_im_out(13),
            data_im_out(2)=>data_im_out(21),
            data_im_out(3)=>data_im_out(29),
            data_im_out(4)=>data_im_out(37),
            data_im_out(5)=>data_im_out(45),
            data_im_out(6)=>data_im_out(53),
            data_im_out(7)=>data_im_out(61)
        );           

    URFFT_PT8_6 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(6),
            data_re_in(1)=>mul_re_out(14),
            data_re_in(2)=>mul_re_out(22),
            data_re_in(3)=>mul_re_out(30),
            data_re_in(4)=>mul_re_out(38),
            data_re_in(5)=>mul_re_out(46),
            data_re_in(6)=>mul_re_out(54),
            data_re_in(7)=>mul_re_out(62),
            data_im_in(0)=>mul_im_out(6),
            data_im_in(1)=>mul_im_out(14),
            data_im_in(2)=>mul_im_out(22),
            data_im_in(3)=>mul_im_out(30),
            data_im_in(4)=>mul_im_out(38),
            data_im_in(5)=>mul_im_out(46),
            data_im_in(6)=>mul_im_out(54),
            data_im_in(7)=>mul_im_out(62),
            data_re_out(0)=>data_re_out(6),
            data_re_out(1)=>data_re_out(14),
            data_re_out(2)=>data_re_out(22),
            data_re_out(3)=>data_re_out(30),
            data_re_out(4)=>data_re_out(38),
            data_re_out(5)=>data_re_out(46),
            data_re_out(6)=>data_re_out(54),
            data_re_out(7)=>data_re_out(62),
            data_im_out(0)=>data_im_out(6),
            data_im_out(1)=>data_im_out(14),
            data_im_out(2)=>data_im_out(22),
            data_im_out(3)=>data_im_out(30),
            data_im_out(4)=>data_im_out(38),
            data_im_out(5)=>data_im_out(46),
            data_im_out(6)=>data_im_out(54),
            data_im_out(7)=>data_im_out(62)
        );           

    URFFT_PT8_7 : fft_pt8
    generic map(
        ctrl_start => (ctrl_start+2) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(7),
            data_re_in(1)=>mul_re_out(15),
            data_re_in(2)=>mul_re_out(23),
            data_re_in(3)=>mul_re_out(31),
            data_re_in(4)=>mul_re_out(39),
            data_re_in(5)=>mul_re_out(47),
            data_re_in(6)=>mul_re_out(55),
            data_re_in(7)=>mul_re_out(63),
            data_im_in(0)=>mul_im_out(7),
            data_im_in(1)=>mul_im_out(15),
            data_im_in(2)=>mul_im_out(23),
            data_im_in(3)=>mul_im_out(31),
            data_im_in(4)=>mul_im_out(39),
            data_im_in(5)=>mul_im_out(47),
            data_im_in(6)=>mul_im_out(55),
            data_im_in(7)=>mul_im_out(63),
            data_re_out(0)=>data_re_out(7),
            data_re_out(1)=>data_re_out(15),
            data_re_out(2)=>data_re_out(23),
            data_re_out(3)=>data_re_out(31),
            data_re_out(4)=>data_re_out(39),
            data_re_out(5)=>data_re_out(47),
            data_re_out(6)=>data_re_out(55),
            data_re_out(7)=>data_re_out(63),
            data_im_out(0)=>data_im_out(7),
            data_im_out(1)=>data_im_out(15),
            data_im_out(2)=>data_im_out(23),
            data_im_out(3)=>data_im_out(31),
            data_im_out(4)=>data_im_out(39),
            data_im_out(5)=>data_im_out(47),
            data_im_out(6)=>data_im_out(55),
            data_im_out(7)=>data_im_out(63)
        );           


    --- multipliers
    UDELAY_0_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(0),
            clk=>clk,
            Q=>shifter_re(0)
        );
    UDELAY_0_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(0),
            clk=>clk,
            Q=>shifter_im(0)
        );
    USHIFTER_0_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(0),
            data_out=>mul_re_out(0)
        );
    USHIFTER_0_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(0),
            data_out=>mul_im_out(0)
        );

    UDELAY_1_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(1),
            clk=>clk,
            Q=>shifter_re(1)
        );
    UDELAY_1_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(1),
            clk=>clk,
            Q=>shifter_im(1)
        );
    USHIFTER_1_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(1),
            data_out=>mul_re_out(1)
        );
    USHIFTER_1_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(1),
            data_out=>mul_im_out(1)
        );

    UDELAY_2_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(2),
            clk=>clk,
            Q=>shifter_re(2)
        );
    UDELAY_2_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(2),
            clk=>clk,
            Q=>shifter_im(2)
        );
    USHIFTER_2_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(2),
            data_out=>mul_re_out(2)
        );
    USHIFTER_2_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(2),
            data_out=>mul_im_out(2)
        );

    UDELAY_3_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(3),
            clk=>clk,
            Q=>shifter_re(3)
        );
    UDELAY_3_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(3),
            clk=>clk,
            Q=>shifter_im(3)
        );
    USHIFTER_3_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(3),
            data_out=>mul_re_out(3)
        );
    USHIFTER_3_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(3),
            data_out=>mul_im_out(3)
        );

    UDELAY_4_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(4),
            clk=>clk,
            Q=>shifter_re(4)
        );
    UDELAY_4_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(4),
            clk=>clk,
            Q=>shifter_im(4)
        );
    USHIFTER_4_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(4),
            data_out=>mul_re_out(4)
        );
    USHIFTER_4_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(4),
            data_out=>mul_im_out(4)
        );

    UDELAY_5_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(5),
            clk=>clk,
            Q=>shifter_re(5)
        );
    UDELAY_5_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(5),
            clk=>clk,
            Q=>shifter_im(5)
        );
    USHIFTER_5_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(5),
            data_out=>mul_re_out(5)
        );
    USHIFTER_5_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(5),
            data_out=>mul_im_out(5)
        );

    UDELAY_6_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(6),
            clk=>clk,
            Q=>shifter_re(6)
        );
    UDELAY_6_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(6),
            clk=>clk,
            Q=>shifter_im(6)
        );
    USHIFTER_6_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(6),
            data_out=>mul_re_out(6)
        );
    USHIFTER_6_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(6),
            data_out=>mul_im_out(6)
        );

    UDELAY_7_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(7),
            clk=>clk,
            Q=>shifter_re(7)
        );
    UDELAY_7_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(7),
            clk=>clk,
            Q=>shifter_im(7)
        );
    USHIFTER_7_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(7),
            data_out=>mul_re_out(7)
        );
    USHIFTER_7_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(7),
            data_out=>mul_im_out(7)
        );

    UDELAY_8_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(8),
            clk=>clk,
            Q=>shifter_re(8)
        );
    UDELAY_8_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(8),
            clk=>clk,
            Q=>shifter_im(8)
        );
    USHIFTER_8_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(8),
            data_out=>mul_re_out(8)
        );
    USHIFTER_8_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(8),
            data_out=>mul_im_out(8)
        );

    UMUL_9 : complex_multiplier
    generic map(
            re_multiplicator=>16305, --- 0.995178222656 + j-0.0979614257812
            im_multiplicator=>-1605,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+2) mod 16
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

    UMUL_12 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(12),
            data_im_in=>first_stage_im_out(12),
            product_re_out=>mul_re_out(12),
            product_im_out=>mul_im_out(12)
        );

    UMUL_13 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+2) mod 16
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
            Q=>shifter_re(16)
        );
    UDELAY_16_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(16),
            clk=>clk,
            Q=>shifter_im(16)
        );
    USHIFTER_16_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(16),
            data_out=>mul_re_out(16)
        );
    USHIFTER_16_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(16),
            data_out=>mul_im_out(16)
        );

    UMUL_17 : complex_multiplier
    generic map(
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+2) mod 16
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

    UMUL_18 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(18),
            data_im_in=>first_stage_im_out(18),
            product_re_out=>mul_re_out(18),
            product_im_out=>mul_im_out(18)
        );

    UMUL_19 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+2) mod 16
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

    UMUL_20 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(20),
            data_im_in=>first_stage_im_out(20),
            product_re_out=>mul_re_out(20),
            product_im_out=>mul_im_out(20)
        );

    UMUL_21 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+2) mod 16
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
            Q=>shifter_re(24)
        );
    UDELAY_24_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(24),
            clk=>clk,
            Q=>shifter_im(24)
        );
    USHIFTER_24_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(24),
            data_out=>mul_re_out(24)
        );
    USHIFTER_24_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(24),
            data_out=>mul_im_out(24)
        );

    UMUL_25 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+2) mod 16
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

    UMUL_28 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(28),
            data_im_in=>first_stage_im_out(28),
            product_re_out=>mul_re_out(28),
            product_im_out=>mul_im_out(28)
        );

    UMUL_29 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+2) mod 16
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
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+2) mod 16
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

    UDELAY_32_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(32),
            clk=>clk,
            Q=>shifter_re(32)
        );
    UDELAY_32_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(32),
            clk=>clk,
            Q=>shifter_im(32)
        );
    USHIFTER_32_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(32),
            data_out=>mul_re_out(32)
        );
    USHIFTER_32_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(32),
            data_out=>mul_im_out(32)
        );

    UMUL_33 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(33),
            data_im_in=>first_stage_im_out(33),
            product_re_out=>mul_re_out(33),
            product_im_out=>mul_im_out(33)
        );

    UMUL_34 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(34),
            data_im_in=>first_stage_im_out(34),
            product_re_out=>mul_re_out(34),
            product_im_out=>mul_im_out(34)
        );

    UMUL_35 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(35),
            data_im_in=>first_stage_im_out(35),
            product_re_out=>mul_re_out(35),
            product_im_out=>mul_im_out(35)
        );

    not_first_stage_re_out(36) <= not first_stage_re_out(36);
    C_BUFF_36 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(36), 
        clk      => clk, 
        preload  => ctrl_delay((ctrl_start+2) mod 16), 
        Q        => c_buff(36)
    );
    ADDER_36 : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff(36), 
        data2_in  => not_first_stage_re_out(36), 
        sum_out   => opp_first_stage_re_out(36), 
        c_out     => c(36)
    );
    UDELAY_36_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(36),
            clk=>clk,
            Q=>shifter_re(36)
        );
    UDELAY_36_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>opp_first_stage_re_out(36),
            clk=>clk,
            Q=>shifter_im(36)
        );
    USHIFTER_36_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(36),
            data_out=>mul_re_out(36)
        );
    USHIFTER_36_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(36),
            data_out=>mul_im_out(36)
        );

    UMUL_37 : complex_multiplier
    generic map(
            re_multiplicator=>-6269, --- -0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(37),
            data_im_in=>first_stage_im_out(37),
            product_re_out=>mul_re_out(37),
            product_im_out=>mul_im_out(37)
        );

    UMUL_38 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(38),
            data_im_in=>first_stage_im_out(38),
            product_re_out=>mul_re_out(38),
            product_im_out=>mul_im_out(38)
        );

    UMUL_39 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(39),
            data_im_in=>first_stage_im_out(39),
            product_re_out=>mul_re_out(39),
            product_im_out=>mul_im_out(39)
        );

    UDELAY_40_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(40),
            clk=>clk,
            Q=>shifter_re(40)
        );
    UDELAY_40_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(40),
            clk=>clk,
            Q=>shifter_im(40)
        );
    USHIFTER_40_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(40),
            data_out=>mul_re_out(40)
        );
    USHIFTER_40_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(40),
            data_out=>mul_im_out(40)
        );

    UMUL_41 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(41),
            data_im_in=>first_stage_im_out(41),
            product_re_out=>mul_re_out(41),
            product_im_out=>mul_im_out(41)
        );

    UMUL_42 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(42),
            data_im_in=>first_stage_im_out(42),
            product_re_out=>mul_re_out(42),
            product_im_out=>mul_im_out(42)
        );

    UMUL_43 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(43),
            data_im_in=>first_stage_im_out(43),
            product_re_out=>mul_re_out(43),
            product_im_out=>mul_im_out(43)
        );

    UMUL_44 : complex_multiplier
    generic map(
            re_multiplicator=>-6269, --- -0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(44),
            data_im_in=>first_stage_im_out(44),
            product_re_out=>mul_re_out(44),
            product_im_out=>mul_im_out(44)
        );

    UMUL_45 : complex_multiplier
    generic map(
            re_multiplicator=>-12665, --- -0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(45),
            data_im_in=>first_stage_im_out(45),
            product_re_out=>mul_re_out(45),
            product_im_out=>mul_im_out(45)
        );

    UMUL_46 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(46),
            data_im_in=>first_stage_im_out(46),
            product_re_out=>mul_re_out(46),
            product_im_out=>mul_im_out(46)
        );

    UMUL_47 : complex_multiplier
    generic map(
            re_multiplicator=>-15678, --- -0.956909179688 + j0.290283203125
            im_multiplicator=>4756,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(47),
            data_im_in=>first_stage_im_out(47),
            product_re_out=>mul_re_out(47),
            product_im_out=>mul_im_out(47)
        );

    UDELAY_48_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(48),
            clk=>clk,
            Q=>shifter_re(48)
        );
    UDELAY_48_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(48),
            clk=>clk,
            Q=>shifter_im(48)
        );
    USHIFTER_48_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(48),
            data_out=>mul_re_out(48)
        );
    USHIFTER_48_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(48),
            data_out=>mul_im_out(48)
        );

    UMUL_49 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(49),
            data_im_in=>first_stage_im_out(49),
            product_re_out=>mul_re_out(49),
            product_im_out=>mul_im_out(49)
        );

    UMUL_50 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(50),
            data_im_in=>first_stage_im_out(50),
            product_re_out=>mul_re_out(50),
            product_im_out=>mul_im_out(50)
        );

    UMUL_51 : complex_multiplier
    generic map(
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(51),
            data_im_in=>first_stage_im_out(51),
            product_re_out=>mul_re_out(51),
            product_im_out=>mul_im_out(51)
        );

    UMUL_52 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(52),
            data_im_in=>first_stage_im_out(52),
            product_re_out=>mul_re_out(52),
            product_im_out=>mul_im_out(52)
        );

    UMUL_53 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(53),
            data_im_in=>first_stage_im_out(53),
            product_re_out=>mul_re_out(53),
            product_im_out=>mul_im_out(53)
        );

    UMUL_54 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j0.382629394531
            im_multiplicator=>6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(54),
            data_im_in=>first_stage_im_out(54),
            product_re_out=>mul_re_out(54),
            product_im_out=>mul_im_out(54)
        );

    UMUL_55 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j0.831420898438
            im_multiplicator=>13622,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(55),
            data_im_in=>first_stage_im_out(55),
            product_re_out=>mul_re_out(55),
            product_im_out=>mul_im_out(55)
        );

    UDELAY_56_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(56),
            clk=>clk,
            Q=>shifter_re(56)
        );
    UDELAY_56_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(56),
            clk=>clk,
            Q=>shifter_im(56)
        );
    USHIFTER_56_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_re(56),
            data_out=>mul_re_out(56)
        );
    USHIFTER_56_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+2) mod 16),
            data_in=>shifter_im(56),
            data_out=>mul_im_out(56)
        );

    UMUL_57 : complex_multiplier
    generic map(
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(57),
            data_im_in=>first_stage_im_out(57),
            product_re_out=>mul_re_out(57),
            product_im_out=>mul_im_out(57)
        );

    UMUL_58 : complex_multiplier
    generic map(
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(58),
            data_im_in=>first_stage_im_out(58),
            product_re_out=>mul_re_out(58),
            product_im_out=>mul_im_out(58)
        );

    UMUL_59 : complex_multiplier
    generic map(
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(59),
            data_im_in=>first_stage_im_out(59),
            product_re_out=>mul_re_out(59),
            product_im_out=>mul_im_out(59)
        );

    UMUL_60 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(60),
            data_im_in=>first_stage_im_out(60),
            product_re_out=>mul_re_out(60),
            product_im_out=>mul_im_out(60)
        );

    UMUL_61 : complex_multiplier
    generic map(
            re_multiplicator=>-15678, --- -0.956909179688 + j0.290283203125
            im_multiplicator=>4756,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(61),
            data_im_in=>first_stage_im_out(61),
            product_re_out=>mul_re_out(61),
            product_im_out=>mul_im_out(61)
        );

    UMUL_62 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j0.831420898438
            im_multiplicator=>13622,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(62),
            data_im_in=>first_stage_im_out(62),
            product_re_out=>mul_re_out(62),
            product_im_out=>mul_im_out(62)
        );

    UMUL_63 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j0.995178222656
            im_multiplicator=>16305,
            ctrl_start => (ctrl_start+2) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(63),
            data_im_in=>first_stage_im_out(63),
            product_re_out=>mul_re_out(63),
            product_im_out=>mul_im_out(63)
        );

end Behavioral;
