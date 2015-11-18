library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt512 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(511 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(511 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in:in std_logic_vector(511 downto 0);
        data_im_in:in std_logic_vector(511 downto 0);

        data_re_out:out std_logic_vector(511 downto 0);
        data_im_out:out std_logic_vector(511 downto 0)
    );
end fft_pt512;

architecture Behavioral of fft_pt512 is

component fft_pt32 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(31 downto 0);
        data_im_in:in std_logic_vector(31 downto 0);

        data_re_out:out std_logic_vector(31 downto 0);
        data_im_out:out std_logic_vector(31 downto 0)
    );
end component;

component fft_pt16 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in     : in std_logic_vector(15 downto 0);
        data_im_in     : in std_logic_vector(15 downto 0);

        data_re_out     : out std_logic_vector(15 downto 0);
        data_im_out     : out std_logic_vector(15 downto 0)
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

signal first_stage_re_out, first_stage_im_out: std_logic_vector(511 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(511 downto 0);
signal shifter_re,shifter_im:std_logic_vector(511 downto 0);
signal not_first_stage_re_out: std_logic_vector(511 downto 0);
signal opp_first_stage_re_out: std_logic_vector(511 downto 0);
signal c: std_logic_vector(511 downto 0);
signal c_buff: std_logic_vector(511 downto 0);

SIGNAL ctrl_delay : std_logic_vector(15 downto 0);

begin
    --- create ctrl_delay signal in top module
    ctrl_delay(0) <= ctrl;
    --- buffer for ctrl
    PROCESS (clk, rst, ce, ctrl)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                ctrl_delay(15 DOWNTO 1) <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                ctrl_delay(15 DOWNTO 1) <= ctrl_delay(14 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;
    tmp_mul_re_out <= mul_re_out;
    tmp_mul_im_out <= mul_im_out;

    --- left-hand-side processors
    ULFFT_PT32_0 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(0),
            data_re_in(1)=>data_re_in(16),
            data_re_in(2)=>data_re_in(32),
            data_re_in(3)=>data_re_in(48),
            data_re_in(4)=>data_re_in(64),
            data_re_in(5)=>data_re_in(80),
            data_re_in(6)=>data_re_in(96),
            data_re_in(7)=>data_re_in(112),
            data_re_in(8)=>data_re_in(128),
            data_re_in(9)=>data_re_in(144),
            data_re_in(10)=>data_re_in(160),
            data_re_in(11)=>data_re_in(176),
            data_re_in(12)=>data_re_in(192),
            data_re_in(13)=>data_re_in(208),
            data_re_in(14)=>data_re_in(224),
            data_re_in(15)=>data_re_in(240),
            data_re_in(16)=>data_re_in(256),
            data_re_in(17)=>data_re_in(272),
            data_re_in(18)=>data_re_in(288),
            data_re_in(19)=>data_re_in(304),
            data_re_in(20)=>data_re_in(320),
            data_re_in(21)=>data_re_in(336),
            data_re_in(22)=>data_re_in(352),
            data_re_in(23)=>data_re_in(368),
            data_re_in(24)=>data_re_in(384),
            data_re_in(25)=>data_re_in(400),
            data_re_in(26)=>data_re_in(416),
            data_re_in(27)=>data_re_in(432),
            data_re_in(28)=>data_re_in(448),
            data_re_in(29)=>data_re_in(464),
            data_re_in(30)=>data_re_in(480),
            data_re_in(31)=>data_re_in(496),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(16),
            data_im_in(2)=>data_im_in(32),
            data_im_in(3)=>data_im_in(48),
            data_im_in(4)=>data_im_in(64),
            data_im_in(5)=>data_im_in(80),
            data_im_in(6)=>data_im_in(96),
            data_im_in(7)=>data_im_in(112),
            data_im_in(8)=>data_im_in(128),
            data_im_in(9)=>data_im_in(144),
            data_im_in(10)=>data_im_in(160),
            data_im_in(11)=>data_im_in(176),
            data_im_in(12)=>data_im_in(192),
            data_im_in(13)=>data_im_in(208),
            data_im_in(14)=>data_im_in(224),
            data_im_in(15)=>data_im_in(240),
            data_im_in(16)=>data_im_in(256),
            data_im_in(17)=>data_im_in(272),
            data_im_in(18)=>data_im_in(288),
            data_im_in(19)=>data_im_in(304),
            data_im_in(20)=>data_im_in(320),
            data_im_in(21)=>data_im_in(336),
            data_im_in(22)=>data_im_in(352),
            data_im_in(23)=>data_im_in(368),
            data_im_in(24)=>data_im_in(384),
            data_im_in(25)=>data_im_in(400),
            data_im_in(26)=>data_im_in(416),
            data_im_in(27)=>data_im_in(432),
            data_im_in(28)=>data_im_in(448),
            data_im_in(29)=>data_im_in(464),
            data_im_in(30)=>data_im_in(480),
            data_im_in(31)=>data_im_in(496),
            data_re_out=>first_stage_re_out(31 downto 0),
            data_im_out=>first_stage_im_out(31 downto 0)
        );

    ULFFT_PT32_1 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(1),
            data_re_in(1)=>data_re_in(17),
            data_re_in(2)=>data_re_in(33),
            data_re_in(3)=>data_re_in(49),
            data_re_in(4)=>data_re_in(65),
            data_re_in(5)=>data_re_in(81),
            data_re_in(6)=>data_re_in(97),
            data_re_in(7)=>data_re_in(113),
            data_re_in(8)=>data_re_in(129),
            data_re_in(9)=>data_re_in(145),
            data_re_in(10)=>data_re_in(161),
            data_re_in(11)=>data_re_in(177),
            data_re_in(12)=>data_re_in(193),
            data_re_in(13)=>data_re_in(209),
            data_re_in(14)=>data_re_in(225),
            data_re_in(15)=>data_re_in(241),
            data_re_in(16)=>data_re_in(257),
            data_re_in(17)=>data_re_in(273),
            data_re_in(18)=>data_re_in(289),
            data_re_in(19)=>data_re_in(305),
            data_re_in(20)=>data_re_in(321),
            data_re_in(21)=>data_re_in(337),
            data_re_in(22)=>data_re_in(353),
            data_re_in(23)=>data_re_in(369),
            data_re_in(24)=>data_re_in(385),
            data_re_in(25)=>data_re_in(401),
            data_re_in(26)=>data_re_in(417),
            data_re_in(27)=>data_re_in(433),
            data_re_in(28)=>data_re_in(449),
            data_re_in(29)=>data_re_in(465),
            data_re_in(30)=>data_re_in(481),
            data_re_in(31)=>data_re_in(497),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(17),
            data_im_in(2)=>data_im_in(33),
            data_im_in(3)=>data_im_in(49),
            data_im_in(4)=>data_im_in(65),
            data_im_in(5)=>data_im_in(81),
            data_im_in(6)=>data_im_in(97),
            data_im_in(7)=>data_im_in(113),
            data_im_in(8)=>data_im_in(129),
            data_im_in(9)=>data_im_in(145),
            data_im_in(10)=>data_im_in(161),
            data_im_in(11)=>data_im_in(177),
            data_im_in(12)=>data_im_in(193),
            data_im_in(13)=>data_im_in(209),
            data_im_in(14)=>data_im_in(225),
            data_im_in(15)=>data_im_in(241),
            data_im_in(16)=>data_im_in(257),
            data_im_in(17)=>data_im_in(273),
            data_im_in(18)=>data_im_in(289),
            data_im_in(19)=>data_im_in(305),
            data_im_in(20)=>data_im_in(321),
            data_im_in(21)=>data_im_in(337),
            data_im_in(22)=>data_im_in(353),
            data_im_in(23)=>data_im_in(369),
            data_im_in(24)=>data_im_in(385),
            data_im_in(25)=>data_im_in(401),
            data_im_in(26)=>data_im_in(417),
            data_im_in(27)=>data_im_in(433),
            data_im_in(28)=>data_im_in(449),
            data_im_in(29)=>data_im_in(465),
            data_im_in(30)=>data_im_in(481),
            data_im_in(31)=>data_im_in(497),
            data_re_out=>first_stage_re_out(63 downto 32),
            data_im_out=>first_stage_im_out(63 downto 32)
        );

    ULFFT_PT32_2 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(2),
            data_re_in(1)=>data_re_in(18),
            data_re_in(2)=>data_re_in(34),
            data_re_in(3)=>data_re_in(50),
            data_re_in(4)=>data_re_in(66),
            data_re_in(5)=>data_re_in(82),
            data_re_in(6)=>data_re_in(98),
            data_re_in(7)=>data_re_in(114),
            data_re_in(8)=>data_re_in(130),
            data_re_in(9)=>data_re_in(146),
            data_re_in(10)=>data_re_in(162),
            data_re_in(11)=>data_re_in(178),
            data_re_in(12)=>data_re_in(194),
            data_re_in(13)=>data_re_in(210),
            data_re_in(14)=>data_re_in(226),
            data_re_in(15)=>data_re_in(242),
            data_re_in(16)=>data_re_in(258),
            data_re_in(17)=>data_re_in(274),
            data_re_in(18)=>data_re_in(290),
            data_re_in(19)=>data_re_in(306),
            data_re_in(20)=>data_re_in(322),
            data_re_in(21)=>data_re_in(338),
            data_re_in(22)=>data_re_in(354),
            data_re_in(23)=>data_re_in(370),
            data_re_in(24)=>data_re_in(386),
            data_re_in(25)=>data_re_in(402),
            data_re_in(26)=>data_re_in(418),
            data_re_in(27)=>data_re_in(434),
            data_re_in(28)=>data_re_in(450),
            data_re_in(29)=>data_re_in(466),
            data_re_in(30)=>data_re_in(482),
            data_re_in(31)=>data_re_in(498),
            data_im_in(0)=>data_im_in(2),
            data_im_in(1)=>data_im_in(18),
            data_im_in(2)=>data_im_in(34),
            data_im_in(3)=>data_im_in(50),
            data_im_in(4)=>data_im_in(66),
            data_im_in(5)=>data_im_in(82),
            data_im_in(6)=>data_im_in(98),
            data_im_in(7)=>data_im_in(114),
            data_im_in(8)=>data_im_in(130),
            data_im_in(9)=>data_im_in(146),
            data_im_in(10)=>data_im_in(162),
            data_im_in(11)=>data_im_in(178),
            data_im_in(12)=>data_im_in(194),
            data_im_in(13)=>data_im_in(210),
            data_im_in(14)=>data_im_in(226),
            data_im_in(15)=>data_im_in(242),
            data_im_in(16)=>data_im_in(258),
            data_im_in(17)=>data_im_in(274),
            data_im_in(18)=>data_im_in(290),
            data_im_in(19)=>data_im_in(306),
            data_im_in(20)=>data_im_in(322),
            data_im_in(21)=>data_im_in(338),
            data_im_in(22)=>data_im_in(354),
            data_im_in(23)=>data_im_in(370),
            data_im_in(24)=>data_im_in(386),
            data_im_in(25)=>data_im_in(402),
            data_im_in(26)=>data_im_in(418),
            data_im_in(27)=>data_im_in(434),
            data_im_in(28)=>data_im_in(450),
            data_im_in(29)=>data_im_in(466),
            data_im_in(30)=>data_im_in(482),
            data_im_in(31)=>data_im_in(498),
            data_re_out=>first_stage_re_out(95 downto 64),
            data_im_out=>first_stage_im_out(95 downto 64)
        );

    ULFFT_PT32_3 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(3),
            data_re_in(1)=>data_re_in(19),
            data_re_in(2)=>data_re_in(35),
            data_re_in(3)=>data_re_in(51),
            data_re_in(4)=>data_re_in(67),
            data_re_in(5)=>data_re_in(83),
            data_re_in(6)=>data_re_in(99),
            data_re_in(7)=>data_re_in(115),
            data_re_in(8)=>data_re_in(131),
            data_re_in(9)=>data_re_in(147),
            data_re_in(10)=>data_re_in(163),
            data_re_in(11)=>data_re_in(179),
            data_re_in(12)=>data_re_in(195),
            data_re_in(13)=>data_re_in(211),
            data_re_in(14)=>data_re_in(227),
            data_re_in(15)=>data_re_in(243),
            data_re_in(16)=>data_re_in(259),
            data_re_in(17)=>data_re_in(275),
            data_re_in(18)=>data_re_in(291),
            data_re_in(19)=>data_re_in(307),
            data_re_in(20)=>data_re_in(323),
            data_re_in(21)=>data_re_in(339),
            data_re_in(22)=>data_re_in(355),
            data_re_in(23)=>data_re_in(371),
            data_re_in(24)=>data_re_in(387),
            data_re_in(25)=>data_re_in(403),
            data_re_in(26)=>data_re_in(419),
            data_re_in(27)=>data_re_in(435),
            data_re_in(28)=>data_re_in(451),
            data_re_in(29)=>data_re_in(467),
            data_re_in(30)=>data_re_in(483),
            data_re_in(31)=>data_re_in(499),
            data_im_in(0)=>data_im_in(3),
            data_im_in(1)=>data_im_in(19),
            data_im_in(2)=>data_im_in(35),
            data_im_in(3)=>data_im_in(51),
            data_im_in(4)=>data_im_in(67),
            data_im_in(5)=>data_im_in(83),
            data_im_in(6)=>data_im_in(99),
            data_im_in(7)=>data_im_in(115),
            data_im_in(8)=>data_im_in(131),
            data_im_in(9)=>data_im_in(147),
            data_im_in(10)=>data_im_in(163),
            data_im_in(11)=>data_im_in(179),
            data_im_in(12)=>data_im_in(195),
            data_im_in(13)=>data_im_in(211),
            data_im_in(14)=>data_im_in(227),
            data_im_in(15)=>data_im_in(243),
            data_im_in(16)=>data_im_in(259),
            data_im_in(17)=>data_im_in(275),
            data_im_in(18)=>data_im_in(291),
            data_im_in(19)=>data_im_in(307),
            data_im_in(20)=>data_im_in(323),
            data_im_in(21)=>data_im_in(339),
            data_im_in(22)=>data_im_in(355),
            data_im_in(23)=>data_im_in(371),
            data_im_in(24)=>data_im_in(387),
            data_im_in(25)=>data_im_in(403),
            data_im_in(26)=>data_im_in(419),
            data_im_in(27)=>data_im_in(435),
            data_im_in(28)=>data_im_in(451),
            data_im_in(29)=>data_im_in(467),
            data_im_in(30)=>data_im_in(483),
            data_im_in(31)=>data_im_in(499),
            data_re_out=>first_stage_re_out(127 downto 96),
            data_im_out=>first_stage_im_out(127 downto 96)
        );

    ULFFT_PT32_4 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(4),
            data_re_in(1)=>data_re_in(20),
            data_re_in(2)=>data_re_in(36),
            data_re_in(3)=>data_re_in(52),
            data_re_in(4)=>data_re_in(68),
            data_re_in(5)=>data_re_in(84),
            data_re_in(6)=>data_re_in(100),
            data_re_in(7)=>data_re_in(116),
            data_re_in(8)=>data_re_in(132),
            data_re_in(9)=>data_re_in(148),
            data_re_in(10)=>data_re_in(164),
            data_re_in(11)=>data_re_in(180),
            data_re_in(12)=>data_re_in(196),
            data_re_in(13)=>data_re_in(212),
            data_re_in(14)=>data_re_in(228),
            data_re_in(15)=>data_re_in(244),
            data_re_in(16)=>data_re_in(260),
            data_re_in(17)=>data_re_in(276),
            data_re_in(18)=>data_re_in(292),
            data_re_in(19)=>data_re_in(308),
            data_re_in(20)=>data_re_in(324),
            data_re_in(21)=>data_re_in(340),
            data_re_in(22)=>data_re_in(356),
            data_re_in(23)=>data_re_in(372),
            data_re_in(24)=>data_re_in(388),
            data_re_in(25)=>data_re_in(404),
            data_re_in(26)=>data_re_in(420),
            data_re_in(27)=>data_re_in(436),
            data_re_in(28)=>data_re_in(452),
            data_re_in(29)=>data_re_in(468),
            data_re_in(30)=>data_re_in(484),
            data_re_in(31)=>data_re_in(500),
            data_im_in(0)=>data_im_in(4),
            data_im_in(1)=>data_im_in(20),
            data_im_in(2)=>data_im_in(36),
            data_im_in(3)=>data_im_in(52),
            data_im_in(4)=>data_im_in(68),
            data_im_in(5)=>data_im_in(84),
            data_im_in(6)=>data_im_in(100),
            data_im_in(7)=>data_im_in(116),
            data_im_in(8)=>data_im_in(132),
            data_im_in(9)=>data_im_in(148),
            data_im_in(10)=>data_im_in(164),
            data_im_in(11)=>data_im_in(180),
            data_im_in(12)=>data_im_in(196),
            data_im_in(13)=>data_im_in(212),
            data_im_in(14)=>data_im_in(228),
            data_im_in(15)=>data_im_in(244),
            data_im_in(16)=>data_im_in(260),
            data_im_in(17)=>data_im_in(276),
            data_im_in(18)=>data_im_in(292),
            data_im_in(19)=>data_im_in(308),
            data_im_in(20)=>data_im_in(324),
            data_im_in(21)=>data_im_in(340),
            data_im_in(22)=>data_im_in(356),
            data_im_in(23)=>data_im_in(372),
            data_im_in(24)=>data_im_in(388),
            data_im_in(25)=>data_im_in(404),
            data_im_in(26)=>data_im_in(420),
            data_im_in(27)=>data_im_in(436),
            data_im_in(28)=>data_im_in(452),
            data_im_in(29)=>data_im_in(468),
            data_im_in(30)=>data_im_in(484),
            data_im_in(31)=>data_im_in(500),
            data_re_out=>first_stage_re_out(159 downto 128),
            data_im_out=>first_stage_im_out(159 downto 128)
        );

    ULFFT_PT32_5 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(5),
            data_re_in(1)=>data_re_in(21),
            data_re_in(2)=>data_re_in(37),
            data_re_in(3)=>data_re_in(53),
            data_re_in(4)=>data_re_in(69),
            data_re_in(5)=>data_re_in(85),
            data_re_in(6)=>data_re_in(101),
            data_re_in(7)=>data_re_in(117),
            data_re_in(8)=>data_re_in(133),
            data_re_in(9)=>data_re_in(149),
            data_re_in(10)=>data_re_in(165),
            data_re_in(11)=>data_re_in(181),
            data_re_in(12)=>data_re_in(197),
            data_re_in(13)=>data_re_in(213),
            data_re_in(14)=>data_re_in(229),
            data_re_in(15)=>data_re_in(245),
            data_re_in(16)=>data_re_in(261),
            data_re_in(17)=>data_re_in(277),
            data_re_in(18)=>data_re_in(293),
            data_re_in(19)=>data_re_in(309),
            data_re_in(20)=>data_re_in(325),
            data_re_in(21)=>data_re_in(341),
            data_re_in(22)=>data_re_in(357),
            data_re_in(23)=>data_re_in(373),
            data_re_in(24)=>data_re_in(389),
            data_re_in(25)=>data_re_in(405),
            data_re_in(26)=>data_re_in(421),
            data_re_in(27)=>data_re_in(437),
            data_re_in(28)=>data_re_in(453),
            data_re_in(29)=>data_re_in(469),
            data_re_in(30)=>data_re_in(485),
            data_re_in(31)=>data_re_in(501),
            data_im_in(0)=>data_im_in(5),
            data_im_in(1)=>data_im_in(21),
            data_im_in(2)=>data_im_in(37),
            data_im_in(3)=>data_im_in(53),
            data_im_in(4)=>data_im_in(69),
            data_im_in(5)=>data_im_in(85),
            data_im_in(6)=>data_im_in(101),
            data_im_in(7)=>data_im_in(117),
            data_im_in(8)=>data_im_in(133),
            data_im_in(9)=>data_im_in(149),
            data_im_in(10)=>data_im_in(165),
            data_im_in(11)=>data_im_in(181),
            data_im_in(12)=>data_im_in(197),
            data_im_in(13)=>data_im_in(213),
            data_im_in(14)=>data_im_in(229),
            data_im_in(15)=>data_im_in(245),
            data_im_in(16)=>data_im_in(261),
            data_im_in(17)=>data_im_in(277),
            data_im_in(18)=>data_im_in(293),
            data_im_in(19)=>data_im_in(309),
            data_im_in(20)=>data_im_in(325),
            data_im_in(21)=>data_im_in(341),
            data_im_in(22)=>data_im_in(357),
            data_im_in(23)=>data_im_in(373),
            data_im_in(24)=>data_im_in(389),
            data_im_in(25)=>data_im_in(405),
            data_im_in(26)=>data_im_in(421),
            data_im_in(27)=>data_im_in(437),
            data_im_in(28)=>data_im_in(453),
            data_im_in(29)=>data_im_in(469),
            data_im_in(30)=>data_im_in(485),
            data_im_in(31)=>data_im_in(501),
            data_re_out=>first_stage_re_out(191 downto 160),
            data_im_out=>first_stage_im_out(191 downto 160)
        );

    ULFFT_PT32_6 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(6),
            data_re_in(1)=>data_re_in(22),
            data_re_in(2)=>data_re_in(38),
            data_re_in(3)=>data_re_in(54),
            data_re_in(4)=>data_re_in(70),
            data_re_in(5)=>data_re_in(86),
            data_re_in(6)=>data_re_in(102),
            data_re_in(7)=>data_re_in(118),
            data_re_in(8)=>data_re_in(134),
            data_re_in(9)=>data_re_in(150),
            data_re_in(10)=>data_re_in(166),
            data_re_in(11)=>data_re_in(182),
            data_re_in(12)=>data_re_in(198),
            data_re_in(13)=>data_re_in(214),
            data_re_in(14)=>data_re_in(230),
            data_re_in(15)=>data_re_in(246),
            data_re_in(16)=>data_re_in(262),
            data_re_in(17)=>data_re_in(278),
            data_re_in(18)=>data_re_in(294),
            data_re_in(19)=>data_re_in(310),
            data_re_in(20)=>data_re_in(326),
            data_re_in(21)=>data_re_in(342),
            data_re_in(22)=>data_re_in(358),
            data_re_in(23)=>data_re_in(374),
            data_re_in(24)=>data_re_in(390),
            data_re_in(25)=>data_re_in(406),
            data_re_in(26)=>data_re_in(422),
            data_re_in(27)=>data_re_in(438),
            data_re_in(28)=>data_re_in(454),
            data_re_in(29)=>data_re_in(470),
            data_re_in(30)=>data_re_in(486),
            data_re_in(31)=>data_re_in(502),
            data_im_in(0)=>data_im_in(6),
            data_im_in(1)=>data_im_in(22),
            data_im_in(2)=>data_im_in(38),
            data_im_in(3)=>data_im_in(54),
            data_im_in(4)=>data_im_in(70),
            data_im_in(5)=>data_im_in(86),
            data_im_in(6)=>data_im_in(102),
            data_im_in(7)=>data_im_in(118),
            data_im_in(8)=>data_im_in(134),
            data_im_in(9)=>data_im_in(150),
            data_im_in(10)=>data_im_in(166),
            data_im_in(11)=>data_im_in(182),
            data_im_in(12)=>data_im_in(198),
            data_im_in(13)=>data_im_in(214),
            data_im_in(14)=>data_im_in(230),
            data_im_in(15)=>data_im_in(246),
            data_im_in(16)=>data_im_in(262),
            data_im_in(17)=>data_im_in(278),
            data_im_in(18)=>data_im_in(294),
            data_im_in(19)=>data_im_in(310),
            data_im_in(20)=>data_im_in(326),
            data_im_in(21)=>data_im_in(342),
            data_im_in(22)=>data_im_in(358),
            data_im_in(23)=>data_im_in(374),
            data_im_in(24)=>data_im_in(390),
            data_im_in(25)=>data_im_in(406),
            data_im_in(26)=>data_im_in(422),
            data_im_in(27)=>data_im_in(438),
            data_im_in(28)=>data_im_in(454),
            data_im_in(29)=>data_im_in(470),
            data_im_in(30)=>data_im_in(486),
            data_im_in(31)=>data_im_in(502),
            data_re_out=>first_stage_re_out(223 downto 192),
            data_im_out=>first_stage_im_out(223 downto 192)
        );

    ULFFT_PT32_7 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(7),
            data_re_in(1)=>data_re_in(23),
            data_re_in(2)=>data_re_in(39),
            data_re_in(3)=>data_re_in(55),
            data_re_in(4)=>data_re_in(71),
            data_re_in(5)=>data_re_in(87),
            data_re_in(6)=>data_re_in(103),
            data_re_in(7)=>data_re_in(119),
            data_re_in(8)=>data_re_in(135),
            data_re_in(9)=>data_re_in(151),
            data_re_in(10)=>data_re_in(167),
            data_re_in(11)=>data_re_in(183),
            data_re_in(12)=>data_re_in(199),
            data_re_in(13)=>data_re_in(215),
            data_re_in(14)=>data_re_in(231),
            data_re_in(15)=>data_re_in(247),
            data_re_in(16)=>data_re_in(263),
            data_re_in(17)=>data_re_in(279),
            data_re_in(18)=>data_re_in(295),
            data_re_in(19)=>data_re_in(311),
            data_re_in(20)=>data_re_in(327),
            data_re_in(21)=>data_re_in(343),
            data_re_in(22)=>data_re_in(359),
            data_re_in(23)=>data_re_in(375),
            data_re_in(24)=>data_re_in(391),
            data_re_in(25)=>data_re_in(407),
            data_re_in(26)=>data_re_in(423),
            data_re_in(27)=>data_re_in(439),
            data_re_in(28)=>data_re_in(455),
            data_re_in(29)=>data_re_in(471),
            data_re_in(30)=>data_re_in(487),
            data_re_in(31)=>data_re_in(503),
            data_im_in(0)=>data_im_in(7),
            data_im_in(1)=>data_im_in(23),
            data_im_in(2)=>data_im_in(39),
            data_im_in(3)=>data_im_in(55),
            data_im_in(4)=>data_im_in(71),
            data_im_in(5)=>data_im_in(87),
            data_im_in(6)=>data_im_in(103),
            data_im_in(7)=>data_im_in(119),
            data_im_in(8)=>data_im_in(135),
            data_im_in(9)=>data_im_in(151),
            data_im_in(10)=>data_im_in(167),
            data_im_in(11)=>data_im_in(183),
            data_im_in(12)=>data_im_in(199),
            data_im_in(13)=>data_im_in(215),
            data_im_in(14)=>data_im_in(231),
            data_im_in(15)=>data_im_in(247),
            data_im_in(16)=>data_im_in(263),
            data_im_in(17)=>data_im_in(279),
            data_im_in(18)=>data_im_in(295),
            data_im_in(19)=>data_im_in(311),
            data_im_in(20)=>data_im_in(327),
            data_im_in(21)=>data_im_in(343),
            data_im_in(22)=>data_im_in(359),
            data_im_in(23)=>data_im_in(375),
            data_im_in(24)=>data_im_in(391),
            data_im_in(25)=>data_im_in(407),
            data_im_in(26)=>data_im_in(423),
            data_im_in(27)=>data_im_in(439),
            data_im_in(28)=>data_im_in(455),
            data_im_in(29)=>data_im_in(471),
            data_im_in(30)=>data_im_in(487),
            data_im_in(31)=>data_im_in(503),
            data_re_out=>first_stage_re_out(255 downto 224),
            data_im_out=>first_stage_im_out(255 downto 224)
        );

    ULFFT_PT32_8 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(8),
            data_re_in(1)=>data_re_in(24),
            data_re_in(2)=>data_re_in(40),
            data_re_in(3)=>data_re_in(56),
            data_re_in(4)=>data_re_in(72),
            data_re_in(5)=>data_re_in(88),
            data_re_in(6)=>data_re_in(104),
            data_re_in(7)=>data_re_in(120),
            data_re_in(8)=>data_re_in(136),
            data_re_in(9)=>data_re_in(152),
            data_re_in(10)=>data_re_in(168),
            data_re_in(11)=>data_re_in(184),
            data_re_in(12)=>data_re_in(200),
            data_re_in(13)=>data_re_in(216),
            data_re_in(14)=>data_re_in(232),
            data_re_in(15)=>data_re_in(248),
            data_re_in(16)=>data_re_in(264),
            data_re_in(17)=>data_re_in(280),
            data_re_in(18)=>data_re_in(296),
            data_re_in(19)=>data_re_in(312),
            data_re_in(20)=>data_re_in(328),
            data_re_in(21)=>data_re_in(344),
            data_re_in(22)=>data_re_in(360),
            data_re_in(23)=>data_re_in(376),
            data_re_in(24)=>data_re_in(392),
            data_re_in(25)=>data_re_in(408),
            data_re_in(26)=>data_re_in(424),
            data_re_in(27)=>data_re_in(440),
            data_re_in(28)=>data_re_in(456),
            data_re_in(29)=>data_re_in(472),
            data_re_in(30)=>data_re_in(488),
            data_re_in(31)=>data_re_in(504),
            data_im_in(0)=>data_im_in(8),
            data_im_in(1)=>data_im_in(24),
            data_im_in(2)=>data_im_in(40),
            data_im_in(3)=>data_im_in(56),
            data_im_in(4)=>data_im_in(72),
            data_im_in(5)=>data_im_in(88),
            data_im_in(6)=>data_im_in(104),
            data_im_in(7)=>data_im_in(120),
            data_im_in(8)=>data_im_in(136),
            data_im_in(9)=>data_im_in(152),
            data_im_in(10)=>data_im_in(168),
            data_im_in(11)=>data_im_in(184),
            data_im_in(12)=>data_im_in(200),
            data_im_in(13)=>data_im_in(216),
            data_im_in(14)=>data_im_in(232),
            data_im_in(15)=>data_im_in(248),
            data_im_in(16)=>data_im_in(264),
            data_im_in(17)=>data_im_in(280),
            data_im_in(18)=>data_im_in(296),
            data_im_in(19)=>data_im_in(312),
            data_im_in(20)=>data_im_in(328),
            data_im_in(21)=>data_im_in(344),
            data_im_in(22)=>data_im_in(360),
            data_im_in(23)=>data_im_in(376),
            data_im_in(24)=>data_im_in(392),
            data_im_in(25)=>data_im_in(408),
            data_im_in(26)=>data_im_in(424),
            data_im_in(27)=>data_im_in(440),
            data_im_in(28)=>data_im_in(456),
            data_im_in(29)=>data_im_in(472),
            data_im_in(30)=>data_im_in(488),
            data_im_in(31)=>data_im_in(504),
            data_re_out=>first_stage_re_out(287 downto 256),
            data_im_out=>first_stage_im_out(287 downto 256)
        );

    ULFFT_PT32_9 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(9),
            data_re_in(1)=>data_re_in(25),
            data_re_in(2)=>data_re_in(41),
            data_re_in(3)=>data_re_in(57),
            data_re_in(4)=>data_re_in(73),
            data_re_in(5)=>data_re_in(89),
            data_re_in(6)=>data_re_in(105),
            data_re_in(7)=>data_re_in(121),
            data_re_in(8)=>data_re_in(137),
            data_re_in(9)=>data_re_in(153),
            data_re_in(10)=>data_re_in(169),
            data_re_in(11)=>data_re_in(185),
            data_re_in(12)=>data_re_in(201),
            data_re_in(13)=>data_re_in(217),
            data_re_in(14)=>data_re_in(233),
            data_re_in(15)=>data_re_in(249),
            data_re_in(16)=>data_re_in(265),
            data_re_in(17)=>data_re_in(281),
            data_re_in(18)=>data_re_in(297),
            data_re_in(19)=>data_re_in(313),
            data_re_in(20)=>data_re_in(329),
            data_re_in(21)=>data_re_in(345),
            data_re_in(22)=>data_re_in(361),
            data_re_in(23)=>data_re_in(377),
            data_re_in(24)=>data_re_in(393),
            data_re_in(25)=>data_re_in(409),
            data_re_in(26)=>data_re_in(425),
            data_re_in(27)=>data_re_in(441),
            data_re_in(28)=>data_re_in(457),
            data_re_in(29)=>data_re_in(473),
            data_re_in(30)=>data_re_in(489),
            data_re_in(31)=>data_re_in(505),
            data_im_in(0)=>data_im_in(9),
            data_im_in(1)=>data_im_in(25),
            data_im_in(2)=>data_im_in(41),
            data_im_in(3)=>data_im_in(57),
            data_im_in(4)=>data_im_in(73),
            data_im_in(5)=>data_im_in(89),
            data_im_in(6)=>data_im_in(105),
            data_im_in(7)=>data_im_in(121),
            data_im_in(8)=>data_im_in(137),
            data_im_in(9)=>data_im_in(153),
            data_im_in(10)=>data_im_in(169),
            data_im_in(11)=>data_im_in(185),
            data_im_in(12)=>data_im_in(201),
            data_im_in(13)=>data_im_in(217),
            data_im_in(14)=>data_im_in(233),
            data_im_in(15)=>data_im_in(249),
            data_im_in(16)=>data_im_in(265),
            data_im_in(17)=>data_im_in(281),
            data_im_in(18)=>data_im_in(297),
            data_im_in(19)=>data_im_in(313),
            data_im_in(20)=>data_im_in(329),
            data_im_in(21)=>data_im_in(345),
            data_im_in(22)=>data_im_in(361),
            data_im_in(23)=>data_im_in(377),
            data_im_in(24)=>data_im_in(393),
            data_im_in(25)=>data_im_in(409),
            data_im_in(26)=>data_im_in(425),
            data_im_in(27)=>data_im_in(441),
            data_im_in(28)=>data_im_in(457),
            data_im_in(29)=>data_im_in(473),
            data_im_in(30)=>data_im_in(489),
            data_im_in(31)=>data_im_in(505),
            data_re_out=>first_stage_re_out(319 downto 288),
            data_im_out=>first_stage_im_out(319 downto 288)
        );

    ULFFT_PT32_10 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(10),
            data_re_in(1)=>data_re_in(26),
            data_re_in(2)=>data_re_in(42),
            data_re_in(3)=>data_re_in(58),
            data_re_in(4)=>data_re_in(74),
            data_re_in(5)=>data_re_in(90),
            data_re_in(6)=>data_re_in(106),
            data_re_in(7)=>data_re_in(122),
            data_re_in(8)=>data_re_in(138),
            data_re_in(9)=>data_re_in(154),
            data_re_in(10)=>data_re_in(170),
            data_re_in(11)=>data_re_in(186),
            data_re_in(12)=>data_re_in(202),
            data_re_in(13)=>data_re_in(218),
            data_re_in(14)=>data_re_in(234),
            data_re_in(15)=>data_re_in(250),
            data_re_in(16)=>data_re_in(266),
            data_re_in(17)=>data_re_in(282),
            data_re_in(18)=>data_re_in(298),
            data_re_in(19)=>data_re_in(314),
            data_re_in(20)=>data_re_in(330),
            data_re_in(21)=>data_re_in(346),
            data_re_in(22)=>data_re_in(362),
            data_re_in(23)=>data_re_in(378),
            data_re_in(24)=>data_re_in(394),
            data_re_in(25)=>data_re_in(410),
            data_re_in(26)=>data_re_in(426),
            data_re_in(27)=>data_re_in(442),
            data_re_in(28)=>data_re_in(458),
            data_re_in(29)=>data_re_in(474),
            data_re_in(30)=>data_re_in(490),
            data_re_in(31)=>data_re_in(506),
            data_im_in(0)=>data_im_in(10),
            data_im_in(1)=>data_im_in(26),
            data_im_in(2)=>data_im_in(42),
            data_im_in(3)=>data_im_in(58),
            data_im_in(4)=>data_im_in(74),
            data_im_in(5)=>data_im_in(90),
            data_im_in(6)=>data_im_in(106),
            data_im_in(7)=>data_im_in(122),
            data_im_in(8)=>data_im_in(138),
            data_im_in(9)=>data_im_in(154),
            data_im_in(10)=>data_im_in(170),
            data_im_in(11)=>data_im_in(186),
            data_im_in(12)=>data_im_in(202),
            data_im_in(13)=>data_im_in(218),
            data_im_in(14)=>data_im_in(234),
            data_im_in(15)=>data_im_in(250),
            data_im_in(16)=>data_im_in(266),
            data_im_in(17)=>data_im_in(282),
            data_im_in(18)=>data_im_in(298),
            data_im_in(19)=>data_im_in(314),
            data_im_in(20)=>data_im_in(330),
            data_im_in(21)=>data_im_in(346),
            data_im_in(22)=>data_im_in(362),
            data_im_in(23)=>data_im_in(378),
            data_im_in(24)=>data_im_in(394),
            data_im_in(25)=>data_im_in(410),
            data_im_in(26)=>data_im_in(426),
            data_im_in(27)=>data_im_in(442),
            data_im_in(28)=>data_im_in(458),
            data_im_in(29)=>data_im_in(474),
            data_im_in(30)=>data_im_in(490),
            data_im_in(31)=>data_im_in(506),
            data_re_out=>first_stage_re_out(351 downto 320),
            data_im_out=>first_stage_im_out(351 downto 320)
        );

    ULFFT_PT32_11 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(11),
            data_re_in(1)=>data_re_in(27),
            data_re_in(2)=>data_re_in(43),
            data_re_in(3)=>data_re_in(59),
            data_re_in(4)=>data_re_in(75),
            data_re_in(5)=>data_re_in(91),
            data_re_in(6)=>data_re_in(107),
            data_re_in(7)=>data_re_in(123),
            data_re_in(8)=>data_re_in(139),
            data_re_in(9)=>data_re_in(155),
            data_re_in(10)=>data_re_in(171),
            data_re_in(11)=>data_re_in(187),
            data_re_in(12)=>data_re_in(203),
            data_re_in(13)=>data_re_in(219),
            data_re_in(14)=>data_re_in(235),
            data_re_in(15)=>data_re_in(251),
            data_re_in(16)=>data_re_in(267),
            data_re_in(17)=>data_re_in(283),
            data_re_in(18)=>data_re_in(299),
            data_re_in(19)=>data_re_in(315),
            data_re_in(20)=>data_re_in(331),
            data_re_in(21)=>data_re_in(347),
            data_re_in(22)=>data_re_in(363),
            data_re_in(23)=>data_re_in(379),
            data_re_in(24)=>data_re_in(395),
            data_re_in(25)=>data_re_in(411),
            data_re_in(26)=>data_re_in(427),
            data_re_in(27)=>data_re_in(443),
            data_re_in(28)=>data_re_in(459),
            data_re_in(29)=>data_re_in(475),
            data_re_in(30)=>data_re_in(491),
            data_re_in(31)=>data_re_in(507),
            data_im_in(0)=>data_im_in(11),
            data_im_in(1)=>data_im_in(27),
            data_im_in(2)=>data_im_in(43),
            data_im_in(3)=>data_im_in(59),
            data_im_in(4)=>data_im_in(75),
            data_im_in(5)=>data_im_in(91),
            data_im_in(6)=>data_im_in(107),
            data_im_in(7)=>data_im_in(123),
            data_im_in(8)=>data_im_in(139),
            data_im_in(9)=>data_im_in(155),
            data_im_in(10)=>data_im_in(171),
            data_im_in(11)=>data_im_in(187),
            data_im_in(12)=>data_im_in(203),
            data_im_in(13)=>data_im_in(219),
            data_im_in(14)=>data_im_in(235),
            data_im_in(15)=>data_im_in(251),
            data_im_in(16)=>data_im_in(267),
            data_im_in(17)=>data_im_in(283),
            data_im_in(18)=>data_im_in(299),
            data_im_in(19)=>data_im_in(315),
            data_im_in(20)=>data_im_in(331),
            data_im_in(21)=>data_im_in(347),
            data_im_in(22)=>data_im_in(363),
            data_im_in(23)=>data_im_in(379),
            data_im_in(24)=>data_im_in(395),
            data_im_in(25)=>data_im_in(411),
            data_im_in(26)=>data_im_in(427),
            data_im_in(27)=>data_im_in(443),
            data_im_in(28)=>data_im_in(459),
            data_im_in(29)=>data_im_in(475),
            data_im_in(30)=>data_im_in(491),
            data_im_in(31)=>data_im_in(507),
            data_re_out=>first_stage_re_out(383 downto 352),
            data_im_out=>first_stage_im_out(383 downto 352)
        );

    ULFFT_PT32_12 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(12),
            data_re_in(1)=>data_re_in(28),
            data_re_in(2)=>data_re_in(44),
            data_re_in(3)=>data_re_in(60),
            data_re_in(4)=>data_re_in(76),
            data_re_in(5)=>data_re_in(92),
            data_re_in(6)=>data_re_in(108),
            data_re_in(7)=>data_re_in(124),
            data_re_in(8)=>data_re_in(140),
            data_re_in(9)=>data_re_in(156),
            data_re_in(10)=>data_re_in(172),
            data_re_in(11)=>data_re_in(188),
            data_re_in(12)=>data_re_in(204),
            data_re_in(13)=>data_re_in(220),
            data_re_in(14)=>data_re_in(236),
            data_re_in(15)=>data_re_in(252),
            data_re_in(16)=>data_re_in(268),
            data_re_in(17)=>data_re_in(284),
            data_re_in(18)=>data_re_in(300),
            data_re_in(19)=>data_re_in(316),
            data_re_in(20)=>data_re_in(332),
            data_re_in(21)=>data_re_in(348),
            data_re_in(22)=>data_re_in(364),
            data_re_in(23)=>data_re_in(380),
            data_re_in(24)=>data_re_in(396),
            data_re_in(25)=>data_re_in(412),
            data_re_in(26)=>data_re_in(428),
            data_re_in(27)=>data_re_in(444),
            data_re_in(28)=>data_re_in(460),
            data_re_in(29)=>data_re_in(476),
            data_re_in(30)=>data_re_in(492),
            data_re_in(31)=>data_re_in(508),
            data_im_in(0)=>data_im_in(12),
            data_im_in(1)=>data_im_in(28),
            data_im_in(2)=>data_im_in(44),
            data_im_in(3)=>data_im_in(60),
            data_im_in(4)=>data_im_in(76),
            data_im_in(5)=>data_im_in(92),
            data_im_in(6)=>data_im_in(108),
            data_im_in(7)=>data_im_in(124),
            data_im_in(8)=>data_im_in(140),
            data_im_in(9)=>data_im_in(156),
            data_im_in(10)=>data_im_in(172),
            data_im_in(11)=>data_im_in(188),
            data_im_in(12)=>data_im_in(204),
            data_im_in(13)=>data_im_in(220),
            data_im_in(14)=>data_im_in(236),
            data_im_in(15)=>data_im_in(252),
            data_im_in(16)=>data_im_in(268),
            data_im_in(17)=>data_im_in(284),
            data_im_in(18)=>data_im_in(300),
            data_im_in(19)=>data_im_in(316),
            data_im_in(20)=>data_im_in(332),
            data_im_in(21)=>data_im_in(348),
            data_im_in(22)=>data_im_in(364),
            data_im_in(23)=>data_im_in(380),
            data_im_in(24)=>data_im_in(396),
            data_im_in(25)=>data_im_in(412),
            data_im_in(26)=>data_im_in(428),
            data_im_in(27)=>data_im_in(444),
            data_im_in(28)=>data_im_in(460),
            data_im_in(29)=>data_im_in(476),
            data_im_in(30)=>data_im_in(492),
            data_im_in(31)=>data_im_in(508),
            data_re_out=>first_stage_re_out(415 downto 384),
            data_im_out=>first_stage_im_out(415 downto 384)
        );

    ULFFT_PT32_13 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(13),
            data_re_in(1)=>data_re_in(29),
            data_re_in(2)=>data_re_in(45),
            data_re_in(3)=>data_re_in(61),
            data_re_in(4)=>data_re_in(77),
            data_re_in(5)=>data_re_in(93),
            data_re_in(6)=>data_re_in(109),
            data_re_in(7)=>data_re_in(125),
            data_re_in(8)=>data_re_in(141),
            data_re_in(9)=>data_re_in(157),
            data_re_in(10)=>data_re_in(173),
            data_re_in(11)=>data_re_in(189),
            data_re_in(12)=>data_re_in(205),
            data_re_in(13)=>data_re_in(221),
            data_re_in(14)=>data_re_in(237),
            data_re_in(15)=>data_re_in(253),
            data_re_in(16)=>data_re_in(269),
            data_re_in(17)=>data_re_in(285),
            data_re_in(18)=>data_re_in(301),
            data_re_in(19)=>data_re_in(317),
            data_re_in(20)=>data_re_in(333),
            data_re_in(21)=>data_re_in(349),
            data_re_in(22)=>data_re_in(365),
            data_re_in(23)=>data_re_in(381),
            data_re_in(24)=>data_re_in(397),
            data_re_in(25)=>data_re_in(413),
            data_re_in(26)=>data_re_in(429),
            data_re_in(27)=>data_re_in(445),
            data_re_in(28)=>data_re_in(461),
            data_re_in(29)=>data_re_in(477),
            data_re_in(30)=>data_re_in(493),
            data_re_in(31)=>data_re_in(509),
            data_im_in(0)=>data_im_in(13),
            data_im_in(1)=>data_im_in(29),
            data_im_in(2)=>data_im_in(45),
            data_im_in(3)=>data_im_in(61),
            data_im_in(4)=>data_im_in(77),
            data_im_in(5)=>data_im_in(93),
            data_im_in(6)=>data_im_in(109),
            data_im_in(7)=>data_im_in(125),
            data_im_in(8)=>data_im_in(141),
            data_im_in(9)=>data_im_in(157),
            data_im_in(10)=>data_im_in(173),
            data_im_in(11)=>data_im_in(189),
            data_im_in(12)=>data_im_in(205),
            data_im_in(13)=>data_im_in(221),
            data_im_in(14)=>data_im_in(237),
            data_im_in(15)=>data_im_in(253),
            data_im_in(16)=>data_im_in(269),
            data_im_in(17)=>data_im_in(285),
            data_im_in(18)=>data_im_in(301),
            data_im_in(19)=>data_im_in(317),
            data_im_in(20)=>data_im_in(333),
            data_im_in(21)=>data_im_in(349),
            data_im_in(22)=>data_im_in(365),
            data_im_in(23)=>data_im_in(381),
            data_im_in(24)=>data_im_in(397),
            data_im_in(25)=>data_im_in(413),
            data_im_in(26)=>data_im_in(429),
            data_im_in(27)=>data_im_in(445),
            data_im_in(28)=>data_im_in(461),
            data_im_in(29)=>data_im_in(477),
            data_im_in(30)=>data_im_in(493),
            data_im_in(31)=>data_im_in(509),
            data_re_out=>first_stage_re_out(447 downto 416),
            data_im_out=>first_stage_im_out(447 downto 416)
        );

    ULFFT_PT32_14 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(14),
            data_re_in(1)=>data_re_in(30),
            data_re_in(2)=>data_re_in(46),
            data_re_in(3)=>data_re_in(62),
            data_re_in(4)=>data_re_in(78),
            data_re_in(5)=>data_re_in(94),
            data_re_in(6)=>data_re_in(110),
            data_re_in(7)=>data_re_in(126),
            data_re_in(8)=>data_re_in(142),
            data_re_in(9)=>data_re_in(158),
            data_re_in(10)=>data_re_in(174),
            data_re_in(11)=>data_re_in(190),
            data_re_in(12)=>data_re_in(206),
            data_re_in(13)=>data_re_in(222),
            data_re_in(14)=>data_re_in(238),
            data_re_in(15)=>data_re_in(254),
            data_re_in(16)=>data_re_in(270),
            data_re_in(17)=>data_re_in(286),
            data_re_in(18)=>data_re_in(302),
            data_re_in(19)=>data_re_in(318),
            data_re_in(20)=>data_re_in(334),
            data_re_in(21)=>data_re_in(350),
            data_re_in(22)=>data_re_in(366),
            data_re_in(23)=>data_re_in(382),
            data_re_in(24)=>data_re_in(398),
            data_re_in(25)=>data_re_in(414),
            data_re_in(26)=>data_re_in(430),
            data_re_in(27)=>data_re_in(446),
            data_re_in(28)=>data_re_in(462),
            data_re_in(29)=>data_re_in(478),
            data_re_in(30)=>data_re_in(494),
            data_re_in(31)=>data_re_in(510),
            data_im_in(0)=>data_im_in(14),
            data_im_in(1)=>data_im_in(30),
            data_im_in(2)=>data_im_in(46),
            data_im_in(3)=>data_im_in(62),
            data_im_in(4)=>data_im_in(78),
            data_im_in(5)=>data_im_in(94),
            data_im_in(6)=>data_im_in(110),
            data_im_in(7)=>data_im_in(126),
            data_im_in(8)=>data_im_in(142),
            data_im_in(9)=>data_im_in(158),
            data_im_in(10)=>data_im_in(174),
            data_im_in(11)=>data_im_in(190),
            data_im_in(12)=>data_im_in(206),
            data_im_in(13)=>data_im_in(222),
            data_im_in(14)=>data_im_in(238),
            data_im_in(15)=>data_im_in(254),
            data_im_in(16)=>data_im_in(270),
            data_im_in(17)=>data_im_in(286),
            data_im_in(18)=>data_im_in(302),
            data_im_in(19)=>data_im_in(318),
            data_im_in(20)=>data_im_in(334),
            data_im_in(21)=>data_im_in(350),
            data_im_in(22)=>data_im_in(366),
            data_im_in(23)=>data_im_in(382),
            data_im_in(24)=>data_im_in(398),
            data_im_in(25)=>data_im_in(414),
            data_im_in(26)=>data_im_in(430),
            data_im_in(27)=>data_im_in(446),
            data_im_in(28)=>data_im_in(462),
            data_im_in(29)=>data_im_in(478),
            data_im_in(30)=>data_im_in(494),
            data_im_in(31)=>data_im_in(510),
            data_re_out=>first_stage_re_out(479 downto 448),
            data_im_out=>first_stage_im_out(479 downto 448)
        );

    ULFFT_PT32_15 : fft_pt32
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(15),
            data_re_in(1)=>data_re_in(31),
            data_re_in(2)=>data_re_in(47),
            data_re_in(3)=>data_re_in(63),
            data_re_in(4)=>data_re_in(79),
            data_re_in(5)=>data_re_in(95),
            data_re_in(6)=>data_re_in(111),
            data_re_in(7)=>data_re_in(127),
            data_re_in(8)=>data_re_in(143),
            data_re_in(9)=>data_re_in(159),
            data_re_in(10)=>data_re_in(175),
            data_re_in(11)=>data_re_in(191),
            data_re_in(12)=>data_re_in(207),
            data_re_in(13)=>data_re_in(223),
            data_re_in(14)=>data_re_in(239),
            data_re_in(15)=>data_re_in(255),
            data_re_in(16)=>data_re_in(271),
            data_re_in(17)=>data_re_in(287),
            data_re_in(18)=>data_re_in(303),
            data_re_in(19)=>data_re_in(319),
            data_re_in(20)=>data_re_in(335),
            data_re_in(21)=>data_re_in(351),
            data_re_in(22)=>data_re_in(367),
            data_re_in(23)=>data_re_in(383),
            data_re_in(24)=>data_re_in(399),
            data_re_in(25)=>data_re_in(415),
            data_re_in(26)=>data_re_in(431),
            data_re_in(27)=>data_re_in(447),
            data_re_in(28)=>data_re_in(463),
            data_re_in(29)=>data_re_in(479),
            data_re_in(30)=>data_re_in(495),
            data_re_in(31)=>data_re_in(511),
            data_im_in(0)=>data_im_in(15),
            data_im_in(1)=>data_im_in(31),
            data_im_in(2)=>data_im_in(47),
            data_im_in(3)=>data_im_in(63),
            data_im_in(4)=>data_im_in(79),
            data_im_in(5)=>data_im_in(95),
            data_im_in(6)=>data_im_in(111),
            data_im_in(7)=>data_im_in(127),
            data_im_in(8)=>data_im_in(143),
            data_im_in(9)=>data_im_in(159),
            data_im_in(10)=>data_im_in(175),
            data_im_in(11)=>data_im_in(191),
            data_im_in(12)=>data_im_in(207),
            data_im_in(13)=>data_im_in(223),
            data_im_in(14)=>data_im_in(239),
            data_im_in(15)=>data_im_in(255),
            data_im_in(16)=>data_im_in(271),
            data_im_in(17)=>data_im_in(287),
            data_im_in(18)=>data_im_in(303),
            data_im_in(19)=>data_im_in(319),
            data_im_in(20)=>data_im_in(335),
            data_im_in(21)=>data_im_in(351),
            data_im_in(22)=>data_im_in(367),
            data_im_in(23)=>data_im_in(383),
            data_im_in(24)=>data_im_in(399),
            data_im_in(25)=>data_im_in(415),
            data_im_in(26)=>data_im_in(431),
            data_im_in(27)=>data_im_in(447),
            data_im_in(28)=>data_im_in(463),
            data_im_in(29)=>data_im_in(479),
            data_im_in(30)=>data_im_in(495),
            data_im_in(31)=>data_im_in(511),
            data_re_out=>first_stage_re_out(511 downto 480),
            data_im_out=>first_stage_im_out(511 downto 480)
        );


    --- right-hand-side processors
    URFFT_PT16_0 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(0),
            data_re_in(1)=>mul_re_out(32),
            data_re_in(2)=>mul_re_out(64),
            data_re_in(3)=>mul_re_out(96),
            data_re_in(4)=>mul_re_out(128),
            data_re_in(5)=>mul_re_out(160),
            data_re_in(6)=>mul_re_out(192),
            data_re_in(7)=>mul_re_out(224),
            data_re_in(8)=>mul_re_out(256),
            data_re_in(9)=>mul_re_out(288),
            data_re_in(10)=>mul_re_out(320),
            data_re_in(11)=>mul_re_out(352),
            data_re_in(12)=>mul_re_out(384),
            data_re_in(13)=>mul_re_out(416),
            data_re_in(14)=>mul_re_out(448),
            data_re_in(15)=>mul_re_out(480),
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(32),
            data_im_in(2)=>mul_im_out(64),
            data_im_in(3)=>mul_im_out(96),
            data_im_in(4)=>mul_im_out(128),
            data_im_in(5)=>mul_im_out(160),
            data_im_in(6)=>mul_im_out(192),
            data_im_in(7)=>mul_im_out(224),
            data_im_in(8)=>mul_im_out(256),
            data_im_in(9)=>mul_im_out(288),
            data_im_in(10)=>mul_im_out(320),
            data_im_in(11)=>mul_im_out(352),
            data_im_in(12)=>mul_im_out(384),
            data_im_in(13)=>mul_im_out(416),
            data_im_in(14)=>mul_im_out(448),
            data_im_in(15)=>mul_im_out(480),
            data_re_out(0)=>data_re_out(0),
            data_re_out(1)=>data_re_out(32),
            data_re_out(2)=>data_re_out(64),
            data_re_out(3)=>data_re_out(96),
            data_re_out(4)=>data_re_out(128),
            data_re_out(5)=>data_re_out(160),
            data_re_out(6)=>data_re_out(192),
            data_re_out(7)=>data_re_out(224),
            data_re_out(8)=>data_re_out(256),
            data_re_out(9)=>data_re_out(288),
            data_re_out(10)=>data_re_out(320),
            data_re_out(11)=>data_re_out(352),
            data_re_out(12)=>data_re_out(384),
            data_re_out(13)=>data_re_out(416),
            data_re_out(14)=>data_re_out(448),
            data_re_out(15)=>data_re_out(480),
            data_im_out(0)=>data_im_out(0),
            data_im_out(1)=>data_im_out(32),
            data_im_out(2)=>data_im_out(64),
            data_im_out(3)=>data_im_out(96),
            data_im_out(4)=>data_im_out(128),
            data_im_out(5)=>data_im_out(160),
            data_im_out(6)=>data_im_out(192),
            data_im_out(7)=>data_im_out(224),
            data_im_out(8)=>data_im_out(256),
            data_im_out(9)=>data_im_out(288),
            data_im_out(10)=>data_im_out(320),
            data_im_out(11)=>data_im_out(352),
            data_im_out(12)=>data_im_out(384),
            data_im_out(13)=>data_im_out(416),
            data_im_out(14)=>data_im_out(448),
            data_im_out(15)=>data_im_out(480)
        );           

    URFFT_PT16_1 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(1),
            data_re_in(1)=>mul_re_out(33),
            data_re_in(2)=>mul_re_out(65),
            data_re_in(3)=>mul_re_out(97),
            data_re_in(4)=>mul_re_out(129),
            data_re_in(5)=>mul_re_out(161),
            data_re_in(6)=>mul_re_out(193),
            data_re_in(7)=>mul_re_out(225),
            data_re_in(8)=>mul_re_out(257),
            data_re_in(9)=>mul_re_out(289),
            data_re_in(10)=>mul_re_out(321),
            data_re_in(11)=>mul_re_out(353),
            data_re_in(12)=>mul_re_out(385),
            data_re_in(13)=>mul_re_out(417),
            data_re_in(14)=>mul_re_out(449),
            data_re_in(15)=>mul_re_out(481),
            data_im_in(0)=>mul_im_out(1),
            data_im_in(1)=>mul_im_out(33),
            data_im_in(2)=>mul_im_out(65),
            data_im_in(3)=>mul_im_out(97),
            data_im_in(4)=>mul_im_out(129),
            data_im_in(5)=>mul_im_out(161),
            data_im_in(6)=>mul_im_out(193),
            data_im_in(7)=>mul_im_out(225),
            data_im_in(8)=>mul_im_out(257),
            data_im_in(9)=>mul_im_out(289),
            data_im_in(10)=>mul_im_out(321),
            data_im_in(11)=>mul_im_out(353),
            data_im_in(12)=>mul_im_out(385),
            data_im_in(13)=>mul_im_out(417),
            data_im_in(14)=>mul_im_out(449),
            data_im_in(15)=>mul_im_out(481),
            data_re_out(0)=>data_re_out(1),
            data_re_out(1)=>data_re_out(33),
            data_re_out(2)=>data_re_out(65),
            data_re_out(3)=>data_re_out(97),
            data_re_out(4)=>data_re_out(129),
            data_re_out(5)=>data_re_out(161),
            data_re_out(6)=>data_re_out(193),
            data_re_out(7)=>data_re_out(225),
            data_re_out(8)=>data_re_out(257),
            data_re_out(9)=>data_re_out(289),
            data_re_out(10)=>data_re_out(321),
            data_re_out(11)=>data_re_out(353),
            data_re_out(12)=>data_re_out(385),
            data_re_out(13)=>data_re_out(417),
            data_re_out(14)=>data_re_out(449),
            data_re_out(15)=>data_re_out(481),
            data_im_out(0)=>data_im_out(1),
            data_im_out(1)=>data_im_out(33),
            data_im_out(2)=>data_im_out(65),
            data_im_out(3)=>data_im_out(97),
            data_im_out(4)=>data_im_out(129),
            data_im_out(5)=>data_im_out(161),
            data_im_out(6)=>data_im_out(193),
            data_im_out(7)=>data_im_out(225),
            data_im_out(8)=>data_im_out(257),
            data_im_out(9)=>data_im_out(289),
            data_im_out(10)=>data_im_out(321),
            data_im_out(11)=>data_im_out(353),
            data_im_out(12)=>data_im_out(385),
            data_im_out(13)=>data_im_out(417),
            data_im_out(14)=>data_im_out(449),
            data_im_out(15)=>data_im_out(481)
        );           

    URFFT_PT16_2 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(2),
            data_re_in(1)=>mul_re_out(34),
            data_re_in(2)=>mul_re_out(66),
            data_re_in(3)=>mul_re_out(98),
            data_re_in(4)=>mul_re_out(130),
            data_re_in(5)=>mul_re_out(162),
            data_re_in(6)=>mul_re_out(194),
            data_re_in(7)=>mul_re_out(226),
            data_re_in(8)=>mul_re_out(258),
            data_re_in(9)=>mul_re_out(290),
            data_re_in(10)=>mul_re_out(322),
            data_re_in(11)=>mul_re_out(354),
            data_re_in(12)=>mul_re_out(386),
            data_re_in(13)=>mul_re_out(418),
            data_re_in(14)=>mul_re_out(450),
            data_re_in(15)=>mul_re_out(482),
            data_im_in(0)=>mul_im_out(2),
            data_im_in(1)=>mul_im_out(34),
            data_im_in(2)=>mul_im_out(66),
            data_im_in(3)=>mul_im_out(98),
            data_im_in(4)=>mul_im_out(130),
            data_im_in(5)=>mul_im_out(162),
            data_im_in(6)=>mul_im_out(194),
            data_im_in(7)=>mul_im_out(226),
            data_im_in(8)=>mul_im_out(258),
            data_im_in(9)=>mul_im_out(290),
            data_im_in(10)=>mul_im_out(322),
            data_im_in(11)=>mul_im_out(354),
            data_im_in(12)=>mul_im_out(386),
            data_im_in(13)=>mul_im_out(418),
            data_im_in(14)=>mul_im_out(450),
            data_im_in(15)=>mul_im_out(482),
            data_re_out(0)=>data_re_out(2),
            data_re_out(1)=>data_re_out(34),
            data_re_out(2)=>data_re_out(66),
            data_re_out(3)=>data_re_out(98),
            data_re_out(4)=>data_re_out(130),
            data_re_out(5)=>data_re_out(162),
            data_re_out(6)=>data_re_out(194),
            data_re_out(7)=>data_re_out(226),
            data_re_out(8)=>data_re_out(258),
            data_re_out(9)=>data_re_out(290),
            data_re_out(10)=>data_re_out(322),
            data_re_out(11)=>data_re_out(354),
            data_re_out(12)=>data_re_out(386),
            data_re_out(13)=>data_re_out(418),
            data_re_out(14)=>data_re_out(450),
            data_re_out(15)=>data_re_out(482),
            data_im_out(0)=>data_im_out(2),
            data_im_out(1)=>data_im_out(34),
            data_im_out(2)=>data_im_out(66),
            data_im_out(3)=>data_im_out(98),
            data_im_out(4)=>data_im_out(130),
            data_im_out(5)=>data_im_out(162),
            data_im_out(6)=>data_im_out(194),
            data_im_out(7)=>data_im_out(226),
            data_im_out(8)=>data_im_out(258),
            data_im_out(9)=>data_im_out(290),
            data_im_out(10)=>data_im_out(322),
            data_im_out(11)=>data_im_out(354),
            data_im_out(12)=>data_im_out(386),
            data_im_out(13)=>data_im_out(418),
            data_im_out(14)=>data_im_out(450),
            data_im_out(15)=>data_im_out(482)
        );           

    URFFT_PT16_3 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(3),
            data_re_in(1)=>mul_re_out(35),
            data_re_in(2)=>mul_re_out(67),
            data_re_in(3)=>mul_re_out(99),
            data_re_in(4)=>mul_re_out(131),
            data_re_in(5)=>mul_re_out(163),
            data_re_in(6)=>mul_re_out(195),
            data_re_in(7)=>mul_re_out(227),
            data_re_in(8)=>mul_re_out(259),
            data_re_in(9)=>mul_re_out(291),
            data_re_in(10)=>mul_re_out(323),
            data_re_in(11)=>mul_re_out(355),
            data_re_in(12)=>mul_re_out(387),
            data_re_in(13)=>mul_re_out(419),
            data_re_in(14)=>mul_re_out(451),
            data_re_in(15)=>mul_re_out(483),
            data_im_in(0)=>mul_im_out(3),
            data_im_in(1)=>mul_im_out(35),
            data_im_in(2)=>mul_im_out(67),
            data_im_in(3)=>mul_im_out(99),
            data_im_in(4)=>mul_im_out(131),
            data_im_in(5)=>mul_im_out(163),
            data_im_in(6)=>mul_im_out(195),
            data_im_in(7)=>mul_im_out(227),
            data_im_in(8)=>mul_im_out(259),
            data_im_in(9)=>mul_im_out(291),
            data_im_in(10)=>mul_im_out(323),
            data_im_in(11)=>mul_im_out(355),
            data_im_in(12)=>mul_im_out(387),
            data_im_in(13)=>mul_im_out(419),
            data_im_in(14)=>mul_im_out(451),
            data_im_in(15)=>mul_im_out(483),
            data_re_out(0)=>data_re_out(3),
            data_re_out(1)=>data_re_out(35),
            data_re_out(2)=>data_re_out(67),
            data_re_out(3)=>data_re_out(99),
            data_re_out(4)=>data_re_out(131),
            data_re_out(5)=>data_re_out(163),
            data_re_out(6)=>data_re_out(195),
            data_re_out(7)=>data_re_out(227),
            data_re_out(8)=>data_re_out(259),
            data_re_out(9)=>data_re_out(291),
            data_re_out(10)=>data_re_out(323),
            data_re_out(11)=>data_re_out(355),
            data_re_out(12)=>data_re_out(387),
            data_re_out(13)=>data_re_out(419),
            data_re_out(14)=>data_re_out(451),
            data_re_out(15)=>data_re_out(483),
            data_im_out(0)=>data_im_out(3),
            data_im_out(1)=>data_im_out(35),
            data_im_out(2)=>data_im_out(67),
            data_im_out(3)=>data_im_out(99),
            data_im_out(4)=>data_im_out(131),
            data_im_out(5)=>data_im_out(163),
            data_im_out(6)=>data_im_out(195),
            data_im_out(7)=>data_im_out(227),
            data_im_out(8)=>data_im_out(259),
            data_im_out(9)=>data_im_out(291),
            data_im_out(10)=>data_im_out(323),
            data_im_out(11)=>data_im_out(355),
            data_im_out(12)=>data_im_out(387),
            data_im_out(13)=>data_im_out(419),
            data_im_out(14)=>data_im_out(451),
            data_im_out(15)=>data_im_out(483)
        );           

    URFFT_PT16_4 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(4),
            data_re_in(1)=>mul_re_out(36),
            data_re_in(2)=>mul_re_out(68),
            data_re_in(3)=>mul_re_out(100),
            data_re_in(4)=>mul_re_out(132),
            data_re_in(5)=>mul_re_out(164),
            data_re_in(6)=>mul_re_out(196),
            data_re_in(7)=>mul_re_out(228),
            data_re_in(8)=>mul_re_out(260),
            data_re_in(9)=>mul_re_out(292),
            data_re_in(10)=>mul_re_out(324),
            data_re_in(11)=>mul_re_out(356),
            data_re_in(12)=>mul_re_out(388),
            data_re_in(13)=>mul_re_out(420),
            data_re_in(14)=>mul_re_out(452),
            data_re_in(15)=>mul_re_out(484),
            data_im_in(0)=>mul_im_out(4),
            data_im_in(1)=>mul_im_out(36),
            data_im_in(2)=>mul_im_out(68),
            data_im_in(3)=>mul_im_out(100),
            data_im_in(4)=>mul_im_out(132),
            data_im_in(5)=>mul_im_out(164),
            data_im_in(6)=>mul_im_out(196),
            data_im_in(7)=>mul_im_out(228),
            data_im_in(8)=>mul_im_out(260),
            data_im_in(9)=>mul_im_out(292),
            data_im_in(10)=>mul_im_out(324),
            data_im_in(11)=>mul_im_out(356),
            data_im_in(12)=>mul_im_out(388),
            data_im_in(13)=>mul_im_out(420),
            data_im_in(14)=>mul_im_out(452),
            data_im_in(15)=>mul_im_out(484),
            data_re_out(0)=>data_re_out(4),
            data_re_out(1)=>data_re_out(36),
            data_re_out(2)=>data_re_out(68),
            data_re_out(3)=>data_re_out(100),
            data_re_out(4)=>data_re_out(132),
            data_re_out(5)=>data_re_out(164),
            data_re_out(6)=>data_re_out(196),
            data_re_out(7)=>data_re_out(228),
            data_re_out(8)=>data_re_out(260),
            data_re_out(9)=>data_re_out(292),
            data_re_out(10)=>data_re_out(324),
            data_re_out(11)=>data_re_out(356),
            data_re_out(12)=>data_re_out(388),
            data_re_out(13)=>data_re_out(420),
            data_re_out(14)=>data_re_out(452),
            data_re_out(15)=>data_re_out(484),
            data_im_out(0)=>data_im_out(4),
            data_im_out(1)=>data_im_out(36),
            data_im_out(2)=>data_im_out(68),
            data_im_out(3)=>data_im_out(100),
            data_im_out(4)=>data_im_out(132),
            data_im_out(5)=>data_im_out(164),
            data_im_out(6)=>data_im_out(196),
            data_im_out(7)=>data_im_out(228),
            data_im_out(8)=>data_im_out(260),
            data_im_out(9)=>data_im_out(292),
            data_im_out(10)=>data_im_out(324),
            data_im_out(11)=>data_im_out(356),
            data_im_out(12)=>data_im_out(388),
            data_im_out(13)=>data_im_out(420),
            data_im_out(14)=>data_im_out(452),
            data_im_out(15)=>data_im_out(484)
        );           

    URFFT_PT16_5 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(5),
            data_re_in(1)=>mul_re_out(37),
            data_re_in(2)=>mul_re_out(69),
            data_re_in(3)=>mul_re_out(101),
            data_re_in(4)=>mul_re_out(133),
            data_re_in(5)=>mul_re_out(165),
            data_re_in(6)=>mul_re_out(197),
            data_re_in(7)=>mul_re_out(229),
            data_re_in(8)=>mul_re_out(261),
            data_re_in(9)=>mul_re_out(293),
            data_re_in(10)=>mul_re_out(325),
            data_re_in(11)=>mul_re_out(357),
            data_re_in(12)=>mul_re_out(389),
            data_re_in(13)=>mul_re_out(421),
            data_re_in(14)=>mul_re_out(453),
            data_re_in(15)=>mul_re_out(485),
            data_im_in(0)=>mul_im_out(5),
            data_im_in(1)=>mul_im_out(37),
            data_im_in(2)=>mul_im_out(69),
            data_im_in(3)=>mul_im_out(101),
            data_im_in(4)=>mul_im_out(133),
            data_im_in(5)=>mul_im_out(165),
            data_im_in(6)=>mul_im_out(197),
            data_im_in(7)=>mul_im_out(229),
            data_im_in(8)=>mul_im_out(261),
            data_im_in(9)=>mul_im_out(293),
            data_im_in(10)=>mul_im_out(325),
            data_im_in(11)=>mul_im_out(357),
            data_im_in(12)=>mul_im_out(389),
            data_im_in(13)=>mul_im_out(421),
            data_im_in(14)=>mul_im_out(453),
            data_im_in(15)=>mul_im_out(485),
            data_re_out(0)=>data_re_out(5),
            data_re_out(1)=>data_re_out(37),
            data_re_out(2)=>data_re_out(69),
            data_re_out(3)=>data_re_out(101),
            data_re_out(4)=>data_re_out(133),
            data_re_out(5)=>data_re_out(165),
            data_re_out(6)=>data_re_out(197),
            data_re_out(7)=>data_re_out(229),
            data_re_out(8)=>data_re_out(261),
            data_re_out(9)=>data_re_out(293),
            data_re_out(10)=>data_re_out(325),
            data_re_out(11)=>data_re_out(357),
            data_re_out(12)=>data_re_out(389),
            data_re_out(13)=>data_re_out(421),
            data_re_out(14)=>data_re_out(453),
            data_re_out(15)=>data_re_out(485),
            data_im_out(0)=>data_im_out(5),
            data_im_out(1)=>data_im_out(37),
            data_im_out(2)=>data_im_out(69),
            data_im_out(3)=>data_im_out(101),
            data_im_out(4)=>data_im_out(133),
            data_im_out(5)=>data_im_out(165),
            data_im_out(6)=>data_im_out(197),
            data_im_out(7)=>data_im_out(229),
            data_im_out(8)=>data_im_out(261),
            data_im_out(9)=>data_im_out(293),
            data_im_out(10)=>data_im_out(325),
            data_im_out(11)=>data_im_out(357),
            data_im_out(12)=>data_im_out(389),
            data_im_out(13)=>data_im_out(421),
            data_im_out(14)=>data_im_out(453),
            data_im_out(15)=>data_im_out(485)
        );           

    URFFT_PT16_6 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(6),
            data_re_in(1)=>mul_re_out(38),
            data_re_in(2)=>mul_re_out(70),
            data_re_in(3)=>mul_re_out(102),
            data_re_in(4)=>mul_re_out(134),
            data_re_in(5)=>mul_re_out(166),
            data_re_in(6)=>mul_re_out(198),
            data_re_in(7)=>mul_re_out(230),
            data_re_in(8)=>mul_re_out(262),
            data_re_in(9)=>mul_re_out(294),
            data_re_in(10)=>mul_re_out(326),
            data_re_in(11)=>mul_re_out(358),
            data_re_in(12)=>mul_re_out(390),
            data_re_in(13)=>mul_re_out(422),
            data_re_in(14)=>mul_re_out(454),
            data_re_in(15)=>mul_re_out(486),
            data_im_in(0)=>mul_im_out(6),
            data_im_in(1)=>mul_im_out(38),
            data_im_in(2)=>mul_im_out(70),
            data_im_in(3)=>mul_im_out(102),
            data_im_in(4)=>mul_im_out(134),
            data_im_in(5)=>mul_im_out(166),
            data_im_in(6)=>mul_im_out(198),
            data_im_in(7)=>mul_im_out(230),
            data_im_in(8)=>mul_im_out(262),
            data_im_in(9)=>mul_im_out(294),
            data_im_in(10)=>mul_im_out(326),
            data_im_in(11)=>mul_im_out(358),
            data_im_in(12)=>mul_im_out(390),
            data_im_in(13)=>mul_im_out(422),
            data_im_in(14)=>mul_im_out(454),
            data_im_in(15)=>mul_im_out(486),
            data_re_out(0)=>data_re_out(6),
            data_re_out(1)=>data_re_out(38),
            data_re_out(2)=>data_re_out(70),
            data_re_out(3)=>data_re_out(102),
            data_re_out(4)=>data_re_out(134),
            data_re_out(5)=>data_re_out(166),
            data_re_out(6)=>data_re_out(198),
            data_re_out(7)=>data_re_out(230),
            data_re_out(8)=>data_re_out(262),
            data_re_out(9)=>data_re_out(294),
            data_re_out(10)=>data_re_out(326),
            data_re_out(11)=>data_re_out(358),
            data_re_out(12)=>data_re_out(390),
            data_re_out(13)=>data_re_out(422),
            data_re_out(14)=>data_re_out(454),
            data_re_out(15)=>data_re_out(486),
            data_im_out(0)=>data_im_out(6),
            data_im_out(1)=>data_im_out(38),
            data_im_out(2)=>data_im_out(70),
            data_im_out(3)=>data_im_out(102),
            data_im_out(4)=>data_im_out(134),
            data_im_out(5)=>data_im_out(166),
            data_im_out(6)=>data_im_out(198),
            data_im_out(7)=>data_im_out(230),
            data_im_out(8)=>data_im_out(262),
            data_im_out(9)=>data_im_out(294),
            data_im_out(10)=>data_im_out(326),
            data_im_out(11)=>data_im_out(358),
            data_im_out(12)=>data_im_out(390),
            data_im_out(13)=>data_im_out(422),
            data_im_out(14)=>data_im_out(454),
            data_im_out(15)=>data_im_out(486)
        );           

    URFFT_PT16_7 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(7),
            data_re_in(1)=>mul_re_out(39),
            data_re_in(2)=>mul_re_out(71),
            data_re_in(3)=>mul_re_out(103),
            data_re_in(4)=>mul_re_out(135),
            data_re_in(5)=>mul_re_out(167),
            data_re_in(6)=>mul_re_out(199),
            data_re_in(7)=>mul_re_out(231),
            data_re_in(8)=>mul_re_out(263),
            data_re_in(9)=>mul_re_out(295),
            data_re_in(10)=>mul_re_out(327),
            data_re_in(11)=>mul_re_out(359),
            data_re_in(12)=>mul_re_out(391),
            data_re_in(13)=>mul_re_out(423),
            data_re_in(14)=>mul_re_out(455),
            data_re_in(15)=>mul_re_out(487),
            data_im_in(0)=>mul_im_out(7),
            data_im_in(1)=>mul_im_out(39),
            data_im_in(2)=>mul_im_out(71),
            data_im_in(3)=>mul_im_out(103),
            data_im_in(4)=>mul_im_out(135),
            data_im_in(5)=>mul_im_out(167),
            data_im_in(6)=>mul_im_out(199),
            data_im_in(7)=>mul_im_out(231),
            data_im_in(8)=>mul_im_out(263),
            data_im_in(9)=>mul_im_out(295),
            data_im_in(10)=>mul_im_out(327),
            data_im_in(11)=>mul_im_out(359),
            data_im_in(12)=>mul_im_out(391),
            data_im_in(13)=>mul_im_out(423),
            data_im_in(14)=>mul_im_out(455),
            data_im_in(15)=>mul_im_out(487),
            data_re_out(0)=>data_re_out(7),
            data_re_out(1)=>data_re_out(39),
            data_re_out(2)=>data_re_out(71),
            data_re_out(3)=>data_re_out(103),
            data_re_out(4)=>data_re_out(135),
            data_re_out(5)=>data_re_out(167),
            data_re_out(6)=>data_re_out(199),
            data_re_out(7)=>data_re_out(231),
            data_re_out(8)=>data_re_out(263),
            data_re_out(9)=>data_re_out(295),
            data_re_out(10)=>data_re_out(327),
            data_re_out(11)=>data_re_out(359),
            data_re_out(12)=>data_re_out(391),
            data_re_out(13)=>data_re_out(423),
            data_re_out(14)=>data_re_out(455),
            data_re_out(15)=>data_re_out(487),
            data_im_out(0)=>data_im_out(7),
            data_im_out(1)=>data_im_out(39),
            data_im_out(2)=>data_im_out(71),
            data_im_out(3)=>data_im_out(103),
            data_im_out(4)=>data_im_out(135),
            data_im_out(5)=>data_im_out(167),
            data_im_out(6)=>data_im_out(199),
            data_im_out(7)=>data_im_out(231),
            data_im_out(8)=>data_im_out(263),
            data_im_out(9)=>data_im_out(295),
            data_im_out(10)=>data_im_out(327),
            data_im_out(11)=>data_im_out(359),
            data_im_out(12)=>data_im_out(391),
            data_im_out(13)=>data_im_out(423),
            data_im_out(14)=>data_im_out(455),
            data_im_out(15)=>data_im_out(487)
        );           

    URFFT_PT16_8 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(8),
            data_re_in(1)=>mul_re_out(40),
            data_re_in(2)=>mul_re_out(72),
            data_re_in(3)=>mul_re_out(104),
            data_re_in(4)=>mul_re_out(136),
            data_re_in(5)=>mul_re_out(168),
            data_re_in(6)=>mul_re_out(200),
            data_re_in(7)=>mul_re_out(232),
            data_re_in(8)=>mul_re_out(264),
            data_re_in(9)=>mul_re_out(296),
            data_re_in(10)=>mul_re_out(328),
            data_re_in(11)=>mul_re_out(360),
            data_re_in(12)=>mul_re_out(392),
            data_re_in(13)=>mul_re_out(424),
            data_re_in(14)=>mul_re_out(456),
            data_re_in(15)=>mul_re_out(488),
            data_im_in(0)=>mul_im_out(8),
            data_im_in(1)=>mul_im_out(40),
            data_im_in(2)=>mul_im_out(72),
            data_im_in(3)=>mul_im_out(104),
            data_im_in(4)=>mul_im_out(136),
            data_im_in(5)=>mul_im_out(168),
            data_im_in(6)=>mul_im_out(200),
            data_im_in(7)=>mul_im_out(232),
            data_im_in(8)=>mul_im_out(264),
            data_im_in(9)=>mul_im_out(296),
            data_im_in(10)=>mul_im_out(328),
            data_im_in(11)=>mul_im_out(360),
            data_im_in(12)=>mul_im_out(392),
            data_im_in(13)=>mul_im_out(424),
            data_im_in(14)=>mul_im_out(456),
            data_im_in(15)=>mul_im_out(488),
            data_re_out(0)=>data_re_out(8),
            data_re_out(1)=>data_re_out(40),
            data_re_out(2)=>data_re_out(72),
            data_re_out(3)=>data_re_out(104),
            data_re_out(4)=>data_re_out(136),
            data_re_out(5)=>data_re_out(168),
            data_re_out(6)=>data_re_out(200),
            data_re_out(7)=>data_re_out(232),
            data_re_out(8)=>data_re_out(264),
            data_re_out(9)=>data_re_out(296),
            data_re_out(10)=>data_re_out(328),
            data_re_out(11)=>data_re_out(360),
            data_re_out(12)=>data_re_out(392),
            data_re_out(13)=>data_re_out(424),
            data_re_out(14)=>data_re_out(456),
            data_re_out(15)=>data_re_out(488),
            data_im_out(0)=>data_im_out(8),
            data_im_out(1)=>data_im_out(40),
            data_im_out(2)=>data_im_out(72),
            data_im_out(3)=>data_im_out(104),
            data_im_out(4)=>data_im_out(136),
            data_im_out(5)=>data_im_out(168),
            data_im_out(6)=>data_im_out(200),
            data_im_out(7)=>data_im_out(232),
            data_im_out(8)=>data_im_out(264),
            data_im_out(9)=>data_im_out(296),
            data_im_out(10)=>data_im_out(328),
            data_im_out(11)=>data_im_out(360),
            data_im_out(12)=>data_im_out(392),
            data_im_out(13)=>data_im_out(424),
            data_im_out(14)=>data_im_out(456),
            data_im_out(15)=>data_im_out(488)
        );           

    URFFT_PT16_9 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(9),
            data_re_in(1)=>mul_re_out(41),
            data_re_in(2)=>mul_re_out(73),
            data_re_in(3)=>mul_re_out(105),
            data_re_in(4)=>mul_re_out(137),
            data_re_in(5)=>mul_re_out(169),
            data_re_in(6)=>mul_re_out(201),
            data_re_in(7)=>mul_re_out(233),
            data_re_in(8)=>mul_re_out(265),
            data_re_in(9)=>mul_re_out(297),
            data_re_in(10)=>mul_re_out(329),
            data_re_in(11)=>mul_re_out(361),
            data_re_in(12)=>mul_re_out(393),
            data_re_in(13)=>mul_re_out(425),
            data_re_in(14)=>mul_re_out(457),
            data_re_in(15)=>mul_re_out(489),
            data_im_in(0)=>mul_im_out(9),
            data_im_in(1)=>mul_im_out(41),
            data_im_in(2)=>mul_im_out(73),
            data_im_in(3)=>mul_im_out(105),
            data_im_in(4)=>mul_im_out(137),
            data_im_in(5)=>mul_im_out(169),
            data_im_in(6)=>mul_im_out(201),
            data_im_in(7)=>mul_im_out(233),
            data_im_in(8)=>mul_im_out(265),
            data_im_in(9)=>mul_im_out(297),
            data_im_in(10)=>mul_im_out(329),
            data_im_in(11)=>mul_im_out(361),
            data_im_in(12)=>mul_im_out(393),
            data_im_in(13)=>mul_im_out(425),
            data_im_in(14)=>mul_im_out(457),
            data_im_in(15)=>mul_im_out(489),
            data_re_out(0)=>data_re_out(9),
            data_re_out(1)=>data_re_out(41),
            data_re_out(2)=>data_re_out(73),
            data_re_out(3)=>data_re_out(105),
            data_re_out(4)=>data_re_out(137),
            data_re_out(5)=>data_re_out(169),
            data_re_out(6)=>data_re_out(201),
            data_re_out(7)=>data_re_out(233),
            data_re_out(8)=>data_re_out(265),
            data_re_out(9)=>data_re_out(297),
            data_re_out(10)=>data_re_out(329),
            data_re_out(11)=>data_re_out(361),
            data_re_out(12)=>data_re_out(393),
            data_re_out(13)=>data_re_out(425),
            data_re_out(14)=>data_re_out(457),
            data_re_out(15)=>data_re_out(489),
            data_im_out(0)=>data_im_out(9),
            data_im_out(1)=>data_im_out(41),
            data_im_out(2)=>data_im_out(73),
            data_im_out(3)=>data_im_out(105),
            data_im_out(4)=>data_im_out(137),
            data_im_out(5)=>data_im_out(169),
            data_im_out(6)=>data_im_out(201),
            data_im_out(7)=>data_im_out(233),
            data_im_out(8)=>data_im_out(265),
            data_im_out(9)=>data_im_out(297),
            data_im_out(10)=>data_im_out(329),
            data_im_out(11)=>data_im_out(361),
            data_im_out(12)=>data_im_out(393),
            data_im_out(13)=>data_im_out(425),
            data_im_out(14)=>data_im_out(457),
            data_im_out(15)=>data_im_out(489)
        );           

    URFFT_PT16_10 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(10),
            data_re_in(1)=>mul_re_out(42),
            data_re_in(2)=>mul_re_out(74),
            data_re_in(3)=>mul_re_out(106),
            data_re_in(4)=>mul_re_out(138),
            data_re_in(5)=>mul_re_out(170),
            data_re_in(6)=>mul_re_out(202),
            data_re_in(7)=>mul_re_out(234),
            data_re_in(8)=>mul_re_out(266),
            data_re_in(9)=>mul_re_out(298),
            data_re_in(10)=>mul_re_out(330),
            data_re_in(11)=>mul_re_out(362),
            data_re_in(12)=>mul_re_out(394),
            data_re_in(13)=>mul_re_out(426),
            data_re_in(14)=>mul_re_out(458),
            data_re_in(15)=>mul_re_out(490),
            data_im_in(0)=>mul_im_out(10),
            data_im_in(1)=>mul_im_out(42),
            data_im_in(2)=>mul_im_out(74),
            data_im_in(3)=>mul_im_out(106),
            data_im_in(4)=>mul_im_out(138),
            data_im_in(5)=>mul_im_out(170),
            data_im_in(6)=>mul_im_out(202),
            data_im_in(7)=>mul_im_out(234),
            data_im_in(8)=>mul_im_out(266),
            data_im_in(9)=>mul_im_out(298),
            data_im_in(10)=>mul_im_out(330),
            data_im_in(11)=>mul_im_out(362),
            data_im_in(12)=>mul_im_out(394),
            data_im_in(13)=>mul_im_out(426),
            data_im_in(14)=>mul_im_out(458),
            data_im_in(15)=>mul_im_out(490),
            data_re_out(0)=>data_re_out(10),
            data_re_out(1)=>data_re_out(42),
            data_re_out(2)=>data_re_out(74),
            data_re_out(3)=>data_re_out(106),
            data_re_out(4)=>data_re_out(138),
            data_re_out(5)=>data_re_out(170),
            data_re_out(6)=>data_re_out(202),
            data_re_out(7)=>data_re_out(234),
            data_re_out(8)=>data_re_out(266),
            data_re_out(9)=>data_re_out(298),
            data_re_out(10)=>data_re_out(330),
            data_re_out(11)=>data_re_out(362),
            data_re_out(12)=>data_re_out(394),
            data_re_out(13)=>data_re_out(426),
            data_re_out(14)=>data_re_out(458),
            data_re_out(15)=>data_re_out(490),
            data_im_out(0)=>data_im_out(10),
            data_im_out(1)=>data_im_out(42),
            data_im_out(2)=>data_im_out(74),
            data_im_out(3)=>data_im_out(106),
            data_im_out(4)=>data_im_out(138),
            data_im_out(5)=>data_im_out(170),
            data_im_out(6)=>data_im_out(202),
            data_im_out(7)=>data_im_out(234),
            data_im_out(8)=>data_im_out(266),
            data_im_out(9)=>data_im_out(298),
            data_im_out(10)=>data_im_out(330),
            data_im_out(11)=>data_im_out(362),
            data_im_out(12)=>data_im_out(394),
            data_im_out(13)=>data_im_out(426),
            data_im_out(14)=>data_im_out(458),
            data_im_out(15)=>data_im_out(490)
        );           

    URFFT_PT16_11 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(11),
            data_re_in(1)=>mul_re_out(43),
            data_re_in(2)=>mul_re_out(75),
            data_re_in(3)=>mul_re_out(107),
            data_re_in(4)=>mul_re_out(139),
            data_re_in(5)=>mul_re_out(171),
            data_re_in(6)=>mul_re_out(203),
            data_re_in(7)=>mul_re_out(235),
            data_re_in(8)=>mul_re_out(267),
            data_re_in(9)=>mul_re_out(299),
            data_re_in(10)=>mul_re_out(331),
            data_re_in(11)=>mul_re_out(363),
            data_re_in(12)=>mul_re_out(395),
            data_re_in(13)=>mul_re_out(427),
            data_re_in(14)=>mul_re_out(459),
            data_re_in(15)=>mul_re_out(491),
            data_im_in(0)=>mul_im_out(11),
            data_im_in(1)=>mul_im_out(43),
            data_im_in(2)=>mul_im_out(75),
            data_im_in(3)=>mul_im_out(107),
            data_im_in(4)=>mul_im_out(139),
            data_im_in(5)=>mul_im_out(171),
            data_im_in(6)=>mul_im_out(203),
            data_im_in(7)=>mul_im_out(235),
            data_im_in(8)=>mul_im_out(267),
            data_im_in(9)=>mul_im_out(299),
            data_im_in(10)=>mul_im_out(331),
            data_im_in(11)=>mul_im_out(363),
            data_im_in(12)=>mul_im_out(395),
            data_im_in(13)=>mul_im_out(427),
            data_im_in(14)=>mul_im_out(459),
            data_im_in(15)=>mul_im_out(491),
            data_re_out(0)=>data_re_out(11),
            data_re_out(1)=>data_re_out(43),
            data_re_out(2)=>data_re_out(75),
            data_re_out(3)=>data_re_out(107),
            data_re_out(4)=>data_re_out(139),
            data_re_out(5)=>data_re_out(171),
            data_re_out(6)=>data_re_out(203),
            data_re_out(7)=>data_re_out(235),
            data_re_out(8)=>data_re_out(267),
            data_re_out(9)=>data_re_out(299),
            data_re_out(10)=>data_re_out(331),
            data_re_out(11)=>data_re_out(363),
            data_re_out(12)=>data_re_out(395),
            data_re_out(13)=>data_re_out(427),
            data_re_out(14)=>data_re_out(459),
            data_re_out(15)=>data_re_out(491),
            data_im_out(0)=>data_im_out(11),
            data_im_out(1)=>data_im_out(43),
            data_im_out(2)=>data_im_out(75),
            data_im_out(3)=>data_im_out(107),
            data_im_out(4)=>data_im_out(139),
            data_im_out(5)=>data_im_out(171),
            data_im_out(6)=>data_im_out(203),
            data_im_out(7)=>data_im_out(235),
            data_im_out(8)=>data_im_out(267),
            data_im_out(9)=>data_im_out(299),
            data_im_out(10)=>data_im_out(331),
            data_im_out(11)=>data_im_out(363),
            data_im_out(12)=>data_im_out(395),
            data_im_out(13)=>data_im_out(427),
            data_im_out(14)=>data_im_out(459),
            data_im_out(15)=>data_im_out(491)
        );           

    URFFT_PT16_12 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(12),
            data_re_in(1)=>mul_re_out(44),
            data_re_in(2)=>mul_re_out(76),
            data_re_in(3)=>mul_re_out(108),
            data_re_in(4)=>mul_re_out(140),
            data_re_in(5)=>mul_re_out(172),
            data_re_in(6)=>mul_re_out(204),
            data_re_in(7)=>mul_re_out(236),
            data_re_in(8)=>mul_re_out(268),
            data_re_in(9)=>mul_re_out(300),
            data_re_in(10)=>mul_re_out(332),
            data_re_in(11)=>mul_re_out(364),
            data_re_in(12)=>mul_re_out(396),
            data_re_in(13)=>mul_re_out(428),
            data_re_in(14)=>mul_re_out(460),
            data_re_in(15)=>mul_re_out(492),
            data_im_in(0)=>mul_im_out(12),
            data_im_in(1)=>mul_im_out(44),
            data_im_in(2)=>mul_im_out(76),
            data_im_in(3)=>mul_im_out(108),
            data_im_in(4)=>mul_im_out(140),
            data_im_in(5)=>mul_im_out(172),
            data_im_in(6)=>mul_im_out(204),
            data_im_in(7)=>mul_im_out(236),
            data_im_in(8)=>mul_im_out(268),
            data_im_in(9)=>mul_im_out(300),
            data_im_in(10)=>mul_im_out(332),
            data_im_in(11)=>mul_im_out(364),
            data_im_in(12)=>mul_im_out(396),
            data_im_in(13)=>mul_im_out(428),
            data_im_in(14)=>mul_im_out(460),
            data_im_in(15)=>mul_im_out(492),
            data_re_out(0)=>data_re_out(12),
            data_re_out(1)=>data_re_out(44),
            data_re_out(2)=>data_re_out(76),
            data_re_out(3)=>data_re_out(108),
            data_re_out(4)=>data_re_out(140),
            data_re_out(5)=>data_re_out(172),
            data_re_out(6)=>data_re_out(204),
            data_re_out(7)=>data_re_out(236),
            data_re_out(8)=>data_re_out(268),
            data_re_out(9)=>data_re_out(300),
            data_re_out(10)=>data_re_out(332),
            data_re_out(11)=>data_re_out(364),
            data_re_out(12)=>data_re_out(396),
            data_re_out(13)=>data_re_out(428),
            data_re_out(14)=>data_re_out(460),
            data_re_out(15)=>data_re_out(492),
            data_im_out(0)=>data_im_out(12),
            data_im_out(1)=>data_im_out(44),
            data_im_out(2)=>data_im_out(76),
            data_im_out(3)=>data_im_out(108),
            data_im_out(4)=>data_im_out(140),
            data_im_out(5)=>data_im_out(172),
            data_im_out(6)=>data_im_out(204),
            data_im_out(7)=>data_im_out(236),
            data_im_out(8)=>data_im_out(268),
            data_im_out(9)=>data_im_out(300),
            data_im_out(10)=>data_im_out(332),
            data_im_out(11)=>data_im_out(364),
            data_im_out(12)=>data_im_out(396),
            data_im_out(13)=>data_im_out(428),
            data_im_out(14)=>data_im_out(460),
            data_im_out(15)=>data_im_out(492)
        );           

    URFFT_PT16_13 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(13),
            data_re_in(1)=>mul_re_out(45),
            data_re_in(2)=>mul_re_out(77),
            data_re_in(3)=>mul_re_out(109),
            data_re_in(4)=>mul_re_out(141),
            data_re_in(5)=>mul_re_out(173),
            data_re_in(6)=>mul_re_out(205),
            data_re_in(7)=>mul_re_out(237),
            data_re_in(8)=>mul_re_out(269),
            data_re_in(9)=>mul_re_out(301),
            data_re_in(10)=>mul_re_out(333),
            data_re_in(11)=>mul_re_out(365),
            data_re_in(12)=>mul_re_out(397),
            data_re_in(13)=>mul_re_out(429),
            data_re_in(14)=>mul_re_out(461),
            data_re_in(15)=>mul_re_out(493),
            data_im_in(0)=>mul_im_out(13),
            data_im_in(1)=>mul_im_out(45),
            data_im_in(2)=>mul_im_out(77),
            data_im_in(3)=>mul_im_out(109),
            data_im_in(4)=>mul_im_out(141),
            data_im_in(5)=>mul_im_out(173),
            data_im_in(6)=>mul_im_out(205),
            data_im_in(7)=>mul_im_out(237),
            data_im_in(8)=>mul_im_out(269),
            data_im_in(9)=>mul_im_out(301),
            data_im_in(10)=>mul_im_out(333),
            data_im_in(11)=>mul_im_out(365),
            data_im_in(12)=>mul_im_out(397),
            data_im_in(13)=>mul_im_out(429),
            data_im_in(14)=>mul_im_out(461),
            data_im_in(15)=>mul_im_out(493),
            data_re_out(0)=>data_re_out(13),
            data_re_out(1)=>data_re_out(45),
            data_re_out(2)=>data_re_out(77),
            data_re_out(3)=>data_re_out(109),
            data_re_out(4)=>data_re_out(141),
            data_re_out(5)=>data_re_out(173),
            data_re_out(6)=>data_re_out(205),
            data_re_out(7)=>data_re_out(237),
            data_re_out(8)=>data_re_out(269),
            data_re_out(9)=>data_re_out(301),
            data_re_out(10)=>data_re_out(333),
            data_re_out(11)=>data_re_out(365),
            data_re_out(12)=>data_re_out(397),
            data_re_out(13)=>data_re_out(429),
            data_re_out(14)=>data_re_out(461),
            data_re_out(15)=>data_re_out(493),
            data_im_out(0)=>data_im_out(13),
            data_im_out(1)=>data_im_out(45),
            data_im_out(2)=>data_im_out(77),
            data_im_out(3)=>data_im_out(109),
            data_im_out(4)=>data_im_out(141),
            data_im_out(5)=>data_im_out(173),
            data_im_out(6)=>data_im_out(205),
            data_im_out(7)=>data_im_out(237),
            data_im_out(8)=>data_im_out(269),
            data_im_out(9)=>data_im_out(301),
            data_im_out(10)=>data_im_out(333),
            data_im_out(11)=>data_im_out(365),
            data_im_out(12)=>data_im_out(397),
            data_im_out(13)=>data_im_out(429),
            data_im_out(14)=>data_im_out(461),
            data_im_out(15)=>data_im_out(493)
        );           

    URFFT_PT16_14 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(14),
            data_re_in(1)=>mul_re_out(46),
            data_re_in(2)=>mul_re_out(78),
            data_re_in(3)=>mul_re_out(110),
            data_re_in(4)=>mul_re_out(142),
            data_re_in(5)=>mul_re_out(174),
            data_re_in(6)=>mul_re_out(206),
            data_re_in(7)=>mul_re_out(238),
            data_re_in(8)=>mul_re_out(270),
            data_re_in(9)=>mul_re_out(302),
            data_re_in(10)=>mul_re_out(334),
            data_re_in(11)=>mul_re_out(366),
            data_re_in(12)=>mul_re_out(398),
            data_re_in(13)=>mul_re_out(430),
            data_re_in(14)=>mul_re_out(462),
            data_re_in(15)=>mul_re_out(494),
            data_im_in(0)=>mul_im_out(14),
            data_im_in(1)=>mul_im_out(46),
            data_im_in(2)=>mul_im_out(78),
            data_im_in(3)=>mul_im_out(110),
            data_im_in(4)=>mul_im_out(142),
            data_im_in(5)=>mul_im_out(174),
            data_im_in(6)=>mul_im_out(206),
            data_im_in(7)=>mul_im_out(238),
            data_im_in(8)=>mul_im_out(270),
            data_im_in(9)=>mul_im_out(302),
            data_im_in(10)=>mul_im_out(334),
            data_im_in(11)=>mul_im_out(366),
            data_im_in(12)=>mul_im_out(398),
            data_im_in(13)=>mul_im_out(430),
            data_im_in(14)=>mul_im_out(462),
            data_im_in(15)=>mul_im_out(494),
            data_re_out(0)=>data_re_out(14),
            data_re_out(1)=>data_re_out(46),
            data_re_out(2)=>data_re_out(78),
            data_re_out(3)=>data_re_out(110),
            data_re_out(4)=>data_re_out(142),
            data_re_out(5)=>data_re_out(174),
            data_re_out(6)=>data_re_out(206),
            data_re_out(7)=>data_re_out(238),
            data_re_out(8)=>data_re_out(270),
            data_re_out(9)=>data_re_out(302),
            data_re_out(10)=>data_re_out(334),
            data_re_out(11)=>data_re_out(366),
            data_re_out(12)=>data_re_out(398),
            data_re_out(13)=>data_re_out(430),
            data_re_out(14)=>data_re_out(462),
            data_re_out(15)=>data_re_out(494),
            data_im_out(0)=>data_im_out(14),
            data_im_out(1)=>data_im_out(46),
            data_im_out(2)=>data_im_out(78),
            data_im_out(3)=>data_im_out(110),
            data_im_out(4)=>data_im_out(142),
            data_im_out(5)=>data_im_out(174),
            data_im_out(6)=>data_im_out(206),
            data_im_out(7)=>data_im_out(238),
            data_im_out(8)=>data_im_out(270),
            data_im_out(9)=>data_im_out(302),
            data_im_out(10)=>data_im_out(334),
            data_im_out(11)=>data_im_out(366),
            data_im_out(12)=>data_im_out(398),
            data_im_out(13)=>data_im_out(430),
            data_im_out(14)=>data_im_out(462),
            data_im_out(15)=>data_im_out(494)
        );           

    URFFT_PT16_15 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(15),
            data_re_in(1)=>mul_re_out(47),
            data_re_in(2)=>mul_re_out(79),
            data_re_in(3)=>mul_re_out(111),
            data_re_in(4)=>mul_re_out(143),
            data_re_in(5)=>mul_re_out(175),
            data_re_in(6)=>mul_re_out(207),
            data_re_in(7)=>mul_re_out(239),
            data_re_in(8)=>mul_re_out(271),
            data_re_in(9)=>mul_re_out(303),
            data_re_in(10)=>mul_re_out(335),
            data_re_in(11)=>mul_re_out(367),
            data_re_in(12)=>mul_re_out(399),
            data_re_in(13)=>mul_re_out(431),
            data_re_in(14)=>mul_re_out(463),
            data_re_in(15)=>mul_re_out(495),
            data_im_in(0)=>mul_im_out(15),
            data_im_in(1)=>mul_im_out(47),
            data_im_in(2)=>mul_im_out(79),
            data_im_in(3)=>mul_im_out(111),
            data_im_in(4)=>mul_im_out(143),
            data_im_in(5)=>mul_im_out(175),
            data_im_in(6)=>mul_im_out(207),
            data_im_in(7)=>mul_im_out(239),
            data_im_in(8)=>mul_im_out(271),
            data_im_in(9)=>mul_im_out(303),
            data_im_in(10)=>mul_im_out(335),
            data_im_in(11)=>mul_im_out(367),
            data_im_in(12)=>mul_im_out(399),
            data_im_in(13)=>mul_im_out(431),
            data_im_in(14)=>mul_im_out(463),
            data_im_in(15)=>mul_im_out(495),
            data_re_out(0)=>data_re_out(15),
            data_re_out(1)=>data_re_out(47),
            data_re_out(2)=>data_re_out(79),
            data_re_out(3)=>data_re_out(111),
            data_re_out(4)=>data_re_out(143),
            data_re_out(5)=>data_re_out(175),
            data_re_out(6)=>data_re_out(207),
            data_re_out(7)=>data_re_out(239),
            data_re_out(8)=>data_re_out(271),
            data_re_out(9)=>data_re_out(303),
            data_re_out(10)=>data_re_out(335),
            data_re_out(11)=>data_re_out(367),
            data_re_out(12)=>data_re_out(399),
            data_re_out(13)=>data_re_out(431),
            data_re_out(14)=>data_re_out(463),
            data_re_out(15)=>data_re_out(495),
            data_im_out(0)=>data_im_out(15),
            data_im_out(1)=>data_im_out(47),
            data_im_out(2)=>data_im_out(79),
            data_im_out(3)=>data_im_out(111),
            data_im_out(4)=>data_im_out(143),
            data_im_out(5)=>data_im_out(175),
            data_im_out(6)=>data_im_out(207),
            data_im_out(7)=>data_im_out(239),
            data_im_out(8)=>data_im_out(271),
            data_im_out(9)=>data_im_out(303),
            data_im_out(10)=>data_im_out(335),
            data_im_out(11)=>data_im_out(367),
            data_im_out(12)=>data_im_out(399),
            data_im_out(13)=>data_im_out(431),
            data_im_out(14)=>data_im_out(463),
            data_im_out(15)=>data_im_out(495)
        );           

    URFFT_PT16_16 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(16),
            data_re_in(1)=>mul_re_out(48),
            data_re_in(2)=>mul_re_out(80),
            data_re_in(3)=>mul_re_out(112),
            data_re_in(4)=>mul_re_out(144),
            data_re_in(5)=>mul_re_out(176),
            data_re_in(6)=>mul_re_out(208),
            data_re_in(7)=>mul_re_out(240),
            data_re_in(8)=>mul_re_out(272),
            data_re_in(9)=>mul_re_out(304),
            data_re_in(10)=>mul_re_out(336),
            data_re_in(11)=>mul_re_out(368),
            data_re_in(12)=>mul_re_out(400),
            data_re_in(13)=>mul_re_out(432),
            data_re_in(14)=>mul_re_out(464),
            data_re_in(15)=>mul_re_out(496),
            data_im_in(0)=>mul_im_out(16),
            data_im_in(1)=>mul_im_out(48),
            data_im_in(2)=>mul_im_out(80),
            data_im_in(3)=>mul_im_out(112),
            data_im_in(4)=>mul_im_out(144),
            data_im_in(5)=>mul_im_out(176),
            data_im_in(6)=>mul_im_out(208),
            data_im_in(7)=>mul_im_out(240),
            data_im_in(8)=>mul_im_out(272),
            data_im_in(9)=>mul_im_out(304),
            data_im_in(10)=>mul_im_out(336),
            data_im_in(11)=>mul_im_out(368),
            data_im_in(12)=>mul_im_out(400),
            data_im_in(13)=>mul_im_out(432),
            data_im_in(14)=>mul_im_out(464),
            data_im_in(15)=>mul_im_out(496),
            data_re_out(0)=>data_re_out(16),
            data_re_out(1)=>data_re_out(48),
            data_re_out(2)=>data_re_out(80),
            data_re_out(3)=>data_re_out(112),
            data_re_out(4)=>data_re_out(144),
            data_re_out(5)=>data_re_out(176),
            data_re_out(6)=>data_re_out(208),
            data_re_out(7)=>data_re_out(240),
            data_re_out(8)=>data_re_out(272),
            data_re_out(9)=>data_re_out(304),
            data_re_out(10)=>data_re_out(336),
            data_re_out(11)=>data_re_out(368),
            data_re_out(12)=>data_re_out(400),
            data_re_out(13)=>data_re_out(432),
            data_re_out(14)=>data_re_out(464),
            data_re_out(15)=>data_re_out(496),
            data_im_out(0)=>data_im_out(16),
            data_im_out(1)=>data_im_out(48),
            data_im_out(2)=>data_im_out(80),
            data_im_out(3)=>data_im_out(112),
            data_im_out(4)=>data_im_out(144),
            data_im_out(5)=>data_im_out(176),
            data_im_out(6)=>data_im_out(208),
            data_im_out(7)=>data_im_out(240),
            data_im_out(8)=>data_im_out(272),
            data_im_out(9)=>data_im_out(304),
            data_im_out(10)=>data_im_out(336),
            data_im_out(11)=>data_im_out(368),
            data_im_out(12)=>data_im_out(400),
            data_im_out(13)=>data_im_out(432),
            data_im_out(14)=>data_im_out(464),
            data_im_out(15)=>data_im_out(496)
        );           

    URFFT_PT16_17 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(17),
            data_re_in(1)=>mul_re_out(49),
            data_re_in(2)=>mul_re_out(81),
            data_re_in(3)=>mul_re_out(113),
            data_re_in(4)=>mul_re_out(145),
            data_re_in(5)=>mul_re_out(177),
            data_re_in(6)=>mul_re_out(209),
            data_re_in(7)=>mul_re_out(241),
            data_re_in(8)=>mul_re_out(273),
            data_re_in(9)=>mul_re_out(305),
            data_re_in(10)=>mul_re_out(337),
            data_re_in(11)=>mul_re_out(369),
            data_re_in(12)=>mul_re_out(401),
            data_re_in(13)=>mul_re_out(433),
            data_re_in(14)=>mul_re_out(465),
            data_re_in(15)=>mul_re_out(497),
            data_im_in(0)=>mul_im_out(17),
            data_im_in(1)=>mul_im_out(49),
            data_im_in(2)=>mul_im_out(81),
            data_im_in(3)=>mul_im_out(113),
            data_im_in(4)=>mul_im_out(145),
            data_im_in(5)=>mul_im_out(177),
            data_im_in(6)=>mul_im_out(209),
            data_im_in(7)=>mul_im_out(241),
            data_im_in(8)=>mul_im_out(273),
            data_im_in(9)=>mul_im_out(305),
            data_im_in(10)=>mul_im_out(337),
            data_im_in(11)=>mul_im_out(369),
            data_im_in(12)=>mul_im_out(401),
            data_im_in(13)=>mul_im_out(433),
            data_im_in(14)=>mul_im_out(465),
            data_im_in(15)=>mul_im_out(497),
            data_re_out(0)=>data_re_out(17),
            data_re_out(1)=>data_re_out(49),
            data_re_out(2)=>data_re_out(81),
            data_re_out(3)=>data_re_out(113),
            data_re_out(4)=>data_re_out(145),
            data_re_out(5)=>data_re_out(177),
            data_re_out(6)=>data_re_out(209),
            data_re_out(7)=>data_re_out(241),
            data_re_out(8)=>data_re_out(273),
            data_re_out(9)=>data_re_out(305),
            data_re_out(10)=>data_re_out(337),
            data_re_out(11)=>data_re_out(369),
            data_re_out(12)=>data_re_out(401),
            data_re_out(13)=>data_re_out(433),
            data_re_out(14)=>data_re_out(465),
            data_re_out(15)=>data_re_out(497),
            data_im_out(0)=>data_im_out(17),
            data_im_out(1)=>data_im_out(49),
            data_im_out(2)=>data_im_out(81),
            data_im_out(3)=>data_im_out(113),
            data_im_out(4)=>data_im_out(145),
            data_im_out(5)=>data_im_out(177),
            data_im_out(6)=>data_im_out(209),
            data_im_out(7)=>data_im_out(241),
            data_im_out(8)=>data_im_out(273),
            data_im_out(9)=>data_im_out(305),
            data_im_out(10)=>data_im_out(337),
            data_im_out(11)=>data_im_out(369),
            data_im_out(12)=>data_im_out(401),
            data_im_out(13)=>data_im_out(433),
            data_im_out(14)=>data_im_out(465),
            data_im_out(15)=>data_im_out(497)
        );           

    URFFT_PT16_18 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(18),
            data_re_in(1)=>mul_re_out(50),
            data_re_in(2)=>mul_re_out(82),
            data_re_in(3)=>mul_re_out(114),
            data_re_in(4)=>mul_re_out(146),
            data_re_in(5)=>mul_re_out(178),
            data_re_in(6)=>mul_re_out(210),
            data_re_in(7)=>mul_re_out(242),
            data_re_in(8)=>mul_re_out(274),
            data_re_in(9)=>mul_re_out(306),
            data_re_in(10)=>mul_re_out(338),
            data_re_in(11)=>mul_re_out(370),
            data_re_in(12)=>mul_re_out(402),
            data_re_in(13)=>mul_re_out(434),
            data_re_in(14)=>mul_re_out(466),
            data_re_in(15)=>mul_re_out(498),
            data_im_in(0)=>mul_im_out(18),
            data_im_in(1)=>mul_im_out(50),
            data_im_in(2)=>mul_im_out(82),
            data_im_in(3)=>mul_im_out(114),
            data_im_in(4)=>mul_im_out(146),
            data_im_in(5)=>mul_im_out(178),
            data_im_in(6)=>mul_im_out(210),
            data_im_in(7)=>mul_im_out(242),
            data_im_in(8)=>mul_im_out(274),
            data_im_in(9)=>mul_im_out(306),
            data_im_in(10)=>mul_im_out(338),
            data_im_in(11)=>mul_im_out(370),
            data_im_in(12)=>mul_im_out(402),
            data_im_in(13)=>mul_im_out(434),
            data_im_in(14)=>mul_im_out(466),
            data_im_in(15)=>mul_im_out(498),
            data_re_out(0)=>data_re_out(18),
            data_re_out(1)=>data_re_out(50),
            data_re_out(2)=>data_re_out(82),
            data_re_out(3)=>data_re_out(114),
            data_re_out(4)=>data_re_out(146),
            data_re_out(5)=>data_re_out(178),
            data_re_out(6)=>data_re_out(210),
            data_re_out(7)=>data_re_out(242),
            data_re_out(8)=>data_re_out(274),
            data_re_out(9)=>data_re_out(306),
            data_re_out(10)=>data_re_out(338),
            data_re_out(11)=>data_re_out(370),
            data_re_out(12)=>data_re_out(402),
            data_re_out(13)=>data_re_out(434),
            data_re_out(14)=>data_re_out(466),
            data_re_out(15)=>data_re_out(498),
            data_im_out(0)=>data_im_out(18),
            data_im_out(1)=>data_im_out(50),
            data_im_out(2)=>data_im_out(82),
            data_im_out(3)=>data_im_out(114),
            data_im_out(4)=>data_im_out(146),
            data_im_out(5)=>data_im_out(178),
            data_im_out(6)=>data_im_out(210),
            data_im_out(7)=>data_im_out(242),
            data_im_out(8)=>data_im_out(274),
            data_im_out(9)=>data_im_out(306),
            data_im_out(10)=>data_im_out(338),
            data_im_out(11)=>data_im_out(370),
            data_im_out(12)=>data_im_out(402),
            data_im_out(13)=>data_im_out(434),
            data_im_out(14)=>data_im_out(466),
            data_im_out(15)=>data_im_out(498)
        );           

    URFFT_PT16_19 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(19),
            data_re_in(1)=>mul_re_out(51),
            data_re_in(2)=>mul_re_out(83),
            data_re_in(3)=>mul_re_out(115),
            data_re_in(4)=>mul_re_out(147),
            data_re_in(5)=>mul_re_out(179),
            data_re_in(6)=>mul_re_out(211),
            data_re_in(7)=>mul_re_out(243),
            data_re_in(8)=>mul_re_out(275),
            data_re_in(9)=>mul_re_out(307),
            data_re_in(10)=>mul_re_out(339),
            data_re_in(11)=>mul_re_out(371),
            data_re_in(12)=>mul_re_out(403),
            data_re_in(13)=>mul_re_out(435),
            data_re_in(14)=>mul_re_out(467),
            data_re_in(15)=>mul_re_out(499),
            data_im_in(0)=>mul_im_out(19),
            data_im_in(1)=>mul_im_out(51),
            data_im_in(2)=>mul_im_out(83),
            data_im_in(3)=>mul_im_out(115),
            data_im_in(4)=>mul_im_out(147),
            data_im_in(5)=>mul_im_out(179),
            data_im_in(6)=>mul_im_out(211),
            data_im_in(7)=>mul_im_out(243),
            data_im_in(8)=>mul_im_out(275),
            data_im_in(9)=>mul_im_out(307),
            data_im_in(10)=>mul_im_out(339),
            data_im_in(11)=>mul_im_out(371),
            data_im_in(12)=>mul_im_out(403),
            data_im_in(13)=>mul_im_out(435),
            data_im_in(14)=>mul_im_out(467),
            data_im_in(15)=>mul_im_out(499),
            data_re_out(0)=>data_re_out(19),
            data_re_out(1)=>data_re_out(51),
            data_re_out(2)=>data_re_out(83),
            data_re_out(3)=>data_re_out(115),
            data_re_out(4)=>data_re_out(147),
            data_re_out(5)=>data_re_out(179),
            data_re_out(6)=>data_re_out(211),
            data_re_out(7)=>data_re_out(243),
            data_re_out(8)=>data_re_out(275),
            data_re_out(9)=>data_re_out(307),
            data_re_out(10)=>data_re_out(339),
            data_re_out(11)=>data_re_out(371),
            data_re_out(12)=>data_re_out(403),
            data_re_out(13)=>data_re_out(435),
            data_re_out(14)=>data_re_out(467),
            data_re_out(15)=>data_re_out(499),
            data_im_out(0)=>data_im_out(19),
            data_im_out(1)=>data_im_out(51),
            data_im_out(2)=>data_im_out(83),
            data_im_out(3)=>data_im_out(115),
            data_im_out(4)=>data_im_out(147),
            data_im_out(5)=>data_im_out(179),
            data_im_out(6)=>data_im_out(211),
            data_im_out(7)=>data_im_out(243),
            data_im_out(8)=>data_im_out(275),
            data_im_out(9)=>data_im_out(307),
            data_im_out(10)=>data_im_out(339),
            data_im_out(11)=>data_im_out(371),
            data_im_out(12)=>data_im_out(403),
            data_im_out(13)=>data_im_out(435),
            data_im_out(14)=>data_im_out(467),
            data_im_out(15)=>data_im_out(499)
        );           

    URFFT_PT16_20 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(20),
            data_re_in(1)=>mul_re_out(52),
            data_re_in(2)=>mul_re_out(84),
            data_re_in(3)=>mul_re_out(116),
            data_re_in(4)=>mul_re_out(148),
            data_re_in(5)=>mul_re_out(180),
            data_re_in(6)=>mul_re_out(212),
            data_re_in(7)=>mul_re_out(244),
            data_re_in(8)=>mul_re_out(276),
            data_re_in(9)=>mul_re_out(308),
            data_re_in(10)=>mul_re_out(340),
            data_re_in(11)=>mul_re_out(372),
            data_re_in(12)=>mul_re_out(404),
            data_re_in(13)=>mul_re_out(436),
            data_re_in(14)=>mul_re_out(468),
            data_re_in(15)=>mul_re_out(500),
            data_im_in(0)=>mul_im_out(20),
            data_im_in(1)=>mul_im_out(52),
            data_im_in(2)=>mul_im_out(84),
            data_im_in(3)=>mul_im_out(116),
            data_im_in(4)=>mul_im_out(148),
            data_im_in(5)=>mul_im_out(180),
            data_im_in(6)=>mul_im_out(212),
            data_im_in(7)=>mul_im_out(244),
            data_im_in(8)=>mul_im_out(276),
            data_im_in(9)=>mul_im_out(308),
            data_im_in(10)=>mul_im_out(340),
            data_im_in(11)=>mul_im_out(372),
            data_im_in(12)=>mul_im_out(404),
            data_im_in(13)=>mul_im_out(436),
            data_im_in(14)=>mul_im_out(468),
            data_im_in(15)=>mul_im_out(500),
            data_re_out(0)=>data_re_out(20),
            data_re_out(1)=>data_re_out(52),
            data_re_out(2)=>data_re_out(84),
            data_re_out(3)=>data_re_out(116),
            data_re_out(4)=>data_re_out(148),
            data_re_out(5)=>data_re_out(180),
            data_re_out(6)=>data_re_out(212),
            data_re_out(7)=>data_re_out(244),
            data_re_out(8)=>data_re_out(276),
            data_re_out(9)=>data_re_out(308),
            data_re_out(10)=>data_re_out(340),
            data_re_out(11)=>data_re_out(372),
            data_re_out(12)=>data_re_out(404),
            data_re_out(13)=>data_re_out(436),
            data_re_out(14)=>data_re_out(468),
            data_re_out(15)=>data_re_out(500),
            data_im_out(0)=>data_im_out(20),
            data_im_out(1)=>data_im_out(52),
            data_im_out(2)=>data_im_out(84),
            data_im_out(3)=>data_im_out(116),
            data_im_out(4)=>data_im_out(148),
            data_im_out(5)=>data_im_out(180),
            data_im_out(6)=>data_im_out(212),
            data_im_out(7)=>data_im_out(244),
            data_im_out(8)=>data_im_out(276),
            data_im_out(9)=>data_im_out(308),
            data_im_out(10)=>data_im_out(340),
            data_im_out(11)=>data_im_out(372),
            data_im_out(12)=>data_im_out(404),
            data_im_out(13)=>data_im_out(436),
            data_im_out(14)=>data_im_out(468),
            data_im_out(15)=>data_im_out(500)
        );           

    URFFT_PT16_21 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(21),
            data_re_in(1)=>mul_re_out(53),
            data_re_in(2)=>mul_re_out(85),
            data_re_in(3)=>mul_re_out(117),
            data_re_in(4)=>mul_re_out(149),
            data_re_in(5)=>mul_re_out(181),
            data_re_in(6)=>mul_re_out(213),
            data_re_in(7)=>mul_re_out(245),
            data_re_in(8)=>mul_re_out(277),
            data_re_in(9)=>mul_re_out(309),
            data_re_in(10)=>mul_re_out(341),
            data_re_in(11)=>mul_re_out(373),
            data_re_in(12)=>mul_re_out(405),
            data_re_in(13)=>mul_re_out(437),
            data_re_in(14)=>mul_re_out(469),
            data_re_in(15)=>mul_re_out(501),
            data_im_in(0)=>mul_im_out(21),
            data_im_in(1)=>mul_im_out(53),
            data_im_in(2)=>mul_im_out(85),
            data_im_in(3)=>mul_im_out(117),
            data_im_in(4)=>mul_im_out(149),
            data_im_in(5)=>mul_im_out(181),
            data_im_in(6)=>mul_im_out(213),
            data_im_in(7)=>mul_im_out(245),
            data_im_in(8)=>mul_im_out(277),
            data_im_in(9)=>mul_im_out(309),
            data_im_in(10)=>mul_im_out(341),
            data_im_in(11)=>mul_im_out(373),
            data_im_in(12)=>mul_im_out(405),
            data_im_in(13)=>mul_im_out(437),
            data_im_in(14)=>mul_im_out(469),
            data_im_in(15)=>mul_im_out(501),
            data_re_out(0)=>data_re_out(21),
            data_re_out(1)=>data_re_out(53),
            data_re_out(2)=>data_re_out(85),
            data_re_out(3)=>data_re_out(117),
            data_re_out(4)=>data_re_out(149),
            data_re_out(5)=>data_re_out(181),
            data_re_out(6)=>data_re_out(213),
            data_re_out(7)=>data_re_out(245),
            data_re_out(8)=>data_re_out(277),
            data_re_out(9)=>data_re_out(309),
            data_re_out(10)=>data_re_out(341),
            data_re_out(11)=>data_re_out(373),
            data_re_out(12)=>data_re_out(405),
            data_re_out(13)=>data_re_out(437),
            data_re_out(14)=>data_re_out(469),
            data_re_out(15)=>data_re_out(501),
            data_im_out(0)=>data_im_out(21),
            data_im_out(1)=>data_im_out(53),
            data_im_out(2)=>data_im_out(85),
            data_im_out(3)=>data_im_out(117),
            data_im_out(4)=>data_im_out(149),
            data_im_out(5)=>data_im_out(181),
            data_im_out(6)=>data_im_out(213),
            data_im_out(7)=>data_im_out(245),
            data_im_out(8)=>data_im_out(277),
            data_im_out(9)=>data_im_out(309),
            data_im_out(10)=>data_im_out(341),
            data_im_out(11)=>data_im_out(373),
            data_im_out(12)=>data_im_out(405),
            data_im_out(13)=>data_im_out(437),
            data_im_out(14)=>data_im_out(469),
            data_im_out(15)=>data_im_out(501)
        );           

    URFFT_PT16_22 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(22),
            data_re_in(1)=>mul_re_out(54),
            data_re_in(2)=>mul_re_out(86),
            data_re_in(3)=>mul_re_out(118),
            data_re_in(4)=>mul_re_out(150),
            data_re_in(5)=>mul_re_out(182),
            data_re_in(6)=>mul_re_out(214),
            data_re_in(7)=>mul_re_out(246),
            data_re_in(8)=>mul_re_out(278),
            data_re_in(9)=>mul_re_out(310),
            data_re_in(10)=>mul_re_out(342),
            data_re_in(11)=>mul_re_out(374),
            data_re_in(12)=>mul_re_out(406),
            data_re_in(13)=>mul_re_out(438),
            data_re_in(14)=>mul_re_out(470),
            data_re_in(15)=>mul_re_out(502),
            data_im_in(0)=>mul_im_out(22),
            data_im_in(1)=>mul_im_out(54),
            data_im_in(2)=>mul_im_out(86),
            data_im_in(3)=>mul_im_out(118),
            data_im_in(4)=>mul_im_out(150),
            data_im_in(5)=>mul_im_out(182),
            data_im_in(6)=>mul_im_out(214),
            data_im_in(7)=>mul_im_out(246),
            data_im_in(8)=>mul_im_out(278),
            data_im_in(9)=>mul_im_out(310),
            data_im_in(10)=>mul_im_out(342),
            data_im_in(11)=>mul_im_out(374),
            data_im_in(12)=>mul_im_out(406),
            data_im_in(13)=>mul_im_out(438),
            data_im_in(14)=>mul_im_out(470),
            data_im_in(15)=>mul_im_out(502),
            data_re_out(0)=>data_re_out(22),
            data_re_out(1)=>data_re_out(54),
            data_re_out(2)=>data_re_out(86),
            data_re_out(3)=>data_re_out(118),
            data_re_out(4)=>data_re_out(150),
            data_re_out(5)=>data_re_out(182),
            data_re_out(6)=>data_re_out(214),
            data_re_out(7)=>data_re_out(246),
            data_re_out(8)=>data_re_out(278),
            data_re_out(9)=>data_re_out(310),
            data_re_out(10)=>data_re_out(342),
            data_re_out(11)=>data_re_out(374),
            data_re_out(12)=>data_re_out(406),
            data_re_out(13)=>data_re_out(438),
            data_re_out(14)=>data_re_out(470),
            data_re_out(15)=>data_re_out(502),
            data_im_out(0)=>data_im_out(22),
            data_im_out(1)=>data_im_out(54),
            data_im_out(2)=>data_im_out(86),
            data_im_out(3)=>data_im_out(118),
            data_im_out(4)=>data_im_out(150),
            data_im_out(5)=>data_im_out(182),
            data_im_out(6)=>data_im_out(214),
            data_im_out(7)=>data_im_out(246),
            data_im_out(8)=>data_im_out(278),
            data_im_out(9)=>data_im_out(310),
            data_im_out(10)=>data_im_out(342),
            data_im_out(11)=>data_im_out(374),
            data_im_out(12)=>data_im_out(406),
            data_im_out(13)=>data_im_out(438),
            data_im_out(14)=>data_im_out(470),
            data_im_out(15)=>data_im_out(502)
        );           

    URFFT_PT16_23 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(23),
            data_re_in(1)=>mul_re_out(55),
            data_re_in(2)=>mul_re_out(87),
            data_re_in(3)=>mul_re_out(119),
            data_re_in(4)=>mul_re_out(151),
            data_re_in(5)=>mul_re_out(183),
            data_re_in(6)=>mul_re_out(215),
            data_re_in(7)=>mul_re_out(247),
            data_re_in(8)=>mul_re_out(279),
            data_re_in(9)=>mul_re_out(311),
            data_re_in(10)=>mul_re_out(343),
            data_re_in(11)=>mul_re_out(375),
            data_re_in(12)=>mul_re_out(407),
            data_re_in(13)=>mul_re_out(439),
            data_re_in(14)=>mul_re_out(471),
            data_re_in(15)=>mul_re_out(503),
            data_im_in(0)=>mul_im_out(23),
            data_im_in(1)=>mul_im_out(55),
            data_im_in(2)=>mul_im_out(87),
            data_im_in(3)=>mul_im_out(119),
            data_im_in(4)=>mul_im_out(151),
            data_im_in(5)=>mul_im_out(183),
            data_im_in(6)=>mul_im_out(215),
            data_im_in(7)=>mul_im_out(247),
            data_im_in(8)=>mul_im_out(279),
            data_im_in(9)=>mul_im_out(311),
            data_im_in(10)=>mul_im_out(343),
            data_im_in(11)=>mul_im_out(375),
            data_im_in(12)=>mul_im_out(407),
            data_im_in(13)=>mul_im_out(439),
            data_im_in(14)=>mul_im_out(471),
            data_im_in(15)=>mul_im_out(503),
            data_re_out(0)=>data_re_out(23),
            data_re_out(1)=>data_re_out(55),
            data_re_out(2)=>data_re_out(87),
            data_re_out(3)=>data_re_out(119),
            data_re_out(4)=>data_re_out(151),
            data_re_out(5)=>data_re_out(183),
            data_re_out(6)=>data_re_out(215),
            data_re_out(7)=>data_re_out(247),
            data_re_out(8)=>data_re_out(279),
            data_re_out(9)=>data_re_out(311),
            data_re_out(10)=>data_re_out(343),
            data_re_out(11)=>data_re_out(375),
            data_re_out(12)=>data_re_out(407),
            data_re_out(13)=>data_re_out(439),
            data_re_out(14)=>data_re_out(471),
            data_re_out(15)=>data_re_out(503),
            data_im_out(0)=>data_im_out(23),
            data_im_out(1)=>data_im_out(55),
            data_im_out(2)=>data_im_out(87),
            data_im_out(3)=>data_im_out(119),
            data_im_out(4)=>data_im_out(151),
            data_im_out(5)=>data_im_out(183),
            data_im_out(6)=>data_im_out(215),
            data_im_out(7)=>data_im_out(247),
            data_im_out(8)=>data_im_out(279),
            data_im_out(9)=>data_im_out(311),
            data_im_out(10)=>data_im_out(343),
            data_im_out(11)=>data_im_out(375),
            data_im_out(12)=>data_im_out(407),
            data_im_out(13)=>data_im_out(439),
            data_im_out(14)=>data_im_out(471),
            data_im_out(15)=>data_im_out(503)
        );           

    URFFT_PT16_24 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(24),
            data_re_in(1)=>mul_re_out(56),
            data_re_in(2)=>mul_re_out(88),
            data_re_in(3)=>mul_re_out(120),
            data_re_in(4)=>mul_re_out(152),
            data_re_in(5)=>mul_re_out(184),
            data_re_in(6)=>mul_re_out(216),
            data_re_in(7)=>mul_re_out(248),
            data_re_in(8)=>mul_re_out(280),
            data_re_in(9)=>mul_re_out(312),
            data_re_in(10)=>mul_re_out(344),
            data_re_in(11)=>mul_re_out(376),
            data_re_in(12)=>mul_re_out(408),
            data_re_in(13)=>mul_re_out(440),
            data_re_in(14)=>mul_re_out(472),
            data_re_in(15)=>mul_re_out(504),
            data_im_in(0)=>mul_im_out(24),
            data_im_in(1)=>mul_im_out(56),
            data_im_in(2)=>mul_im_out(88),
            data_im_in(3)=>mul_im_out(120),
            data_im_in(4)=>mul_im_out(152),
            data_im_in(5)=>mul_im_out(184),
            data_im_in(6)=>mul_im_out(216),
            data_im_in(7)=>mul_im_out(248),
            data_im_in(8)=>mul_im_out(280),
            data_im_in(9)=>mul_im_out(312),
            data_im_in(10)=>mul_im_out(344),
            data_im_in(11)=>mul_im_out(376),
            data_im_in(12)=>mul_im_out(408),
            data_im_in(13)=>mul_im_out(440),
            data_im_in(14)=>mul_im_out(472),
            data_im_in(15)=>mul_im_out(504),
            data_re_out(0)=>data_re_out(24),
            data_re_out(1)=>data_re_out(56),
            data_re_out(2)=>data_re_out(88),
            data_re_out(3)=>data_re_out(120),
            data_re_out(4)=>data_re_out(152),
            data_re_out(5)=>data_re_out(184),
            data_re_out(6)=>data_re_out(216),
            data_re_out(7)=>data_re_out(248),
            data_re_out(8)=>data_re_out(280),
            data_re_out(9)=>data_re_out(312),
            data_re_out(10)=>data_re_out(344),
            data_re_out(11)=>data_re_out(376),
            data_re_out(12)=>data_re_out(408),
            data_re_out(13)=>data_re_out(440),
            data_re_out(14)=>data_re_out(472),
            data_re_out(15)=>data_re_out(504),
            data_im_out(0)=>data_im_out(24),
            data_im_out(1)=>data_im_out(56),
            data_im_out(2)=>data_im_out(88),
            data_im_out(3)=>data_im_out(120),
            data_im_out(4)=>data_im_out(152),
            data_im_out(5)=>data_im_out(184),
            data_im_out(6)=>data_im_out(216),
            data_im_out(7)=>data_im_out(248),
            data_im_out(8)=>data_im_out(280),
            data_im_out(9)=>data_im_out(312),
            data_im_out(10)=>data_im_out(344),
            data_im_out(11)=>data_im_out(376),
            data_im_out(12)=>data_im_out(408),
            data_im_out(13)=>data_im_out(440),
            data_im_out(14)=>data_im_out(472),
            data_im_out(15)=>data_im_out(504)
        );           

    URFFT_PT16_25 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(25),
            data_re_in(1)=>mul_re_out(57),
            data_re_in(2)=>mul_re_out(89),
            data_re_in(3)=>mul_re_out(121),
            data_re_in(4)=>mul_re_out(153),
            data_re_in(5)=>mul_re_out(185),
            data_re_in(6)=>mul_re_out(217),
            data_re_in(7)=>mul_re_out(249),
            data_re_in(8)=>mul_re_out(281),
            data_re_in(9)=>mul_re_out(313),
            data_re_in(10)=>mul_re_out(345),
            data_re_in(11)=>mul_re_out(377),
            data_re_in(12)=>mul_re_out(409),
            data_re_in(13)=>mul_re_out(441),
            data_re_in(14)=>mul_re_out(473),
            data_re_in(15)=>mul_re_out(505),
            data_im_in(0)=>mul_im_out(25),
            data_im_in(1)=>mul_im_out(57),
            data_im_in(2)=>mul_im_out(89),
            data_im_in(3)=>mul_im_out(121),
            data_im_in(4)=>mul_im_out(153),
            data_im_in(5)=>mul_im_out(185),
            data_im_in(6)=>mul_im_out(217),
            data_im_in(7)=>mul_im_out(249),
            data_im_in(8)=>mul_im_out(281),
            data_im_in(9)=>mul_im_out(313),
            data_im_in(10)=>mul_im_out(345),
            data_im_in(11)=>mul_im_out(377),
            data_im_in(12)=>mul_im_out(409),
            data_im_in(13)=>mul_im_out(441),
            data_im_in(14)=>mul_im_out(473),
            data_im_in(15)=>mul_im_out(505),
            data_re_out(0)=>data_re_out(25),
            data_re_out(1)=>data_re_out(57),
            data_re_out(2)=>data_re_out(89),
            data_re_out(3)=>data_re_out(121),
            data_re_out(4)=>data_re_out(153),
            data_re_out(5)=>data_re_out(185),
            data_re_out(6)=>data_re_out(217),
            data_re_out(7)=>data_re_out(249),
            data_re_out(8)=>data_re_out(281),
            data_re_out(9)=>data_re_out(313),
            data_re_out(10)=>data_re_out(345),
            data_re_out(11)=>data_re_out(377),
            data_re_out(12)=>data_re_out(409),
            data_re_out(13)=>data_re_out(441),
            data_re_out(14)=>data_re_out(473),
            data_re_out(15)=>data_re_out(505),
            data_im_out(0)=>data_im_out(25),
            data_im_out(1)=>data_im_out(57),
            data_im_out(2)=>data_im_out(89),
            data_im_out(3)=>data_im_out(121),
            data_im_out(4)=>data_im_out(153),
            data_im_out(5)=>data_im_out(185),
            data_im_out(6)=>data_im_out(217),
            data_im_out(7)=>data_im_out(249),
            data_im_out(8)=>data_im_out(281),
            data_im_out(9)=>data_im_out(313),
            data_im_out(10)=>data_im_out(345),
            data_im_out(11)=>data_im_out(377),
            data_im_out(12)=>data_im_out(409),
            data_im_out(13)=>data_im_out(441),
            data_im_out(14)=>data_im_out(473),
            data_im_out(15)=>data_im_out(505)
        );           

    URFFT_PT16_26 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(26),
            data_re_in(1)=>mul_re_out(58),
            data_re_in(2)=>mul_re_out(90),
            data_re_in(3)=>mul_re_out(122),
            data_re_in(4)=>mul_re_out(154),
            data_re_in(5)=>mul_re_out(186),
            data_re_in(6)=>mul_re_out(218),
            data_re_in(7)=>mul_re_out(250),
            data_re_in(8)=>mul_re_out(282),
            data_re_in(9)=>mul_re_out(314),
            data_re_in(10)=>mul_re_out(346),
            data_re_in(11)=>mul_re_out(378),
            data_re_in(12)=>mul_re_out(410),
            data_re_in(13)=>mul_re_out(442),
            data_re_in(14)=>mul_re_out(474),
            data_re_in(15)=>mul_re_out(506),
            data_im_in(0)=>mul_im_out(26),
            data_im_in(1)=>mul_im_out(58),
            data_im_in(2)=>mul_im_out(90),
            data_im_in(3)=>mul_im_out(122),
            data_im_in(4)=>mul_im_out(154),
            data_im_in(5)=>mul_im_out(186),
            data_im_in(6)=>mul_im_out(218),
            data_im_in(7)=>mul_im_out(250),
            data_im_in(8)=>mul_im_out(282),
            data_im_in(9)=>mul_im_out(314),
            data_im_in(10)=>mul_im_out(346),
            data_im_in(11)=>mul_im_out(378),
            data_im_in(12)=>mul_im_out(410),
            data_im_in(13)=>mul_im_out(442),
            data_im_in(14)=>mul_im_out(474),
            data_im_in(15)=>mul_im_out(506),
            data_re_out(0)=>data_re_out(26),
            data_re_out(1)=>data_re_out(58),
            data_re_out(2)=>data_re_out(90),
            data_re_out(3)=>data_re_out(122),
            data_re_out(4)=>data_re_out(154),
            data_re_out(5)=>data_re_out(186),
            data_re_out(6)=>data_re_out(218),
            data_re_out(7)=>data_re_out(250),
            data_re_out(8)=>data_re_out(282),
            data_re_out(9)=>data_re_out(314),
            data_re_out(10)=>data_re_out(346),
            data_re_out(11)=>data_re_out(378),
            data_re_out(12)=>data_re_out(410),
            data_re_out(13)=>data_re_out(442),
            data_re_out(14)=>data_re_out(474),
            data_re_out(15)=>data_re_out(506),
            data_im_out(0)=>data_im_out(26),
            data_im_out(1)=>data_im_out(58),
            data_im_out(2)=>data_im_out(90),
            data_im_out(3)=>data_im_out(122),
            data_im_out(4)=>data_im_out(154),
            data_im_out(5)=>data_im_out(186),
            data_im_out(6)=>data_im_out(218),
            data_im_out(7)=>data_im_out(250),
            data_im_out(8)=>data_im_out(282),
            data_im_out(9)=>data_im_out(314),
            data_im_out(10)=>data_im_out(346),
            data_im_out(11)=>data_im_out(378),
            data_im_out(12)=>data_im_out(410),
            data_im_out(13)=>data_im_out(442),
            data_im_out(14)=>data_im_out(474),
            data_im_out(15)=>data_im_out(506)
        );           

    URFFT_PT16_27 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(27),
            data_re_in(1)=>mul_re_out(59),
            data_re_in(2)=>mul_re_out(91),
            data_re_in(3)=>mul_re_out(123),
            data_re_in(4)=>mul_re_out(155),
            data_re_in(5)=>mul_re_out(187),
            data_re_in(6)=>mul_re_out(219),
            data_re_in(7)=>mul_re_out(251),
            data_re_in(8)=>mul_re_out(283),
            data_re_in(9)=>mul_re_out(315),
            data_re_in(10)=>mul_re_out(347),
            data_re_in(11)=>mul_re_out(379),
            data_re_in(12)=>mul_re_out(411),
            data_re_in(13)=>mul_re_out(443),
            data_re_in(14)=>mul_re_out(475),
            data_re_in(15)=>mul_re_out(507),
            data_im_in(0)=>mul_im_out(27),
            data_im_in(1)=>mul_im_out(59),
            data_im_in(2)=>mul_im_out(91),
            data_im_in(3)=>mul_im_out(123),
            data_im_in(4)=>mul_im_out(155),
            data_im_in(5)=>mul_im_out(187),
            data_im_in(6)=>mul_im_out(219),
            data_im_in(7)=>mul_im_out(251),
            data_im_in(8)=>mul_im_out(283),
            data_im_in(9)=>mul_im_out(315),
            data_im_in(10)=>mul_im_out(347),
            data_im_in(11)=>mul_im_out(379),
            data_im_in(12)=>mul_im_out(411),
            data_im_in(13)=>mul_im_out(443),
            data_im_in(14)=>mul_im_out(475),
            data_im_in(15)=>mul_im_out(507),
            data_re_out(0)=>data_re_out(27),
            data_re_out(1)=>data_re_out(59),
            data_re_out(2)=>data_re_out(91),
            data_re_out(3)=>data_re_out(123),
            data_re_out(4)=>data_re_out(155),
            data_re_out(5)=>data_re_out(187),
            data_re_out(6)=>data_re_out(219),
            data_re_out(7)=>data_re_out(251),
            data_re_out(8)=>data_re_out(283),
            data_re_out(9)=>data_re_out(315),
            data_re_out(10)=>data_re_out(347),
            data_re_out(11)=>data_re_out(379),
            data_re_out(12)=>data_re_out(411),
            data_re_out(13)=>data_re_out(443),
            data_re_out(14)=>data_re_out(475),
            data_re_out(15)=>data_re_out(507),
            data_im_out(0)=>data_im_out(27),
            data_im_out(1)=>data_im_out(59),
            data_im_out(2)=>data_im_out(91),
            data_im_out(3)=>data_im_out(123),
            data_im_out(4)=>data_im_out(155),
            data_im_out(5)=>data_im_out(187),
            data_im_out(6)=>data_im_out(219),
            data_im_out(7)=>data_im_out(251),
            data_im_out(8)=>data_im_out(283),
            data_im_out(9)=>data_im_out(315),
            data_im_out(10)=>data_im_out(347),
            data_im_out(11)=>data_im_out(379),
            data_im_out(12)=>data_im_out(411),
            data_im_out(13)=>data_im_out(443),
            data_im_out(14)=>data_im_out(475),
            data_im_out(15)=>data_im_out(507)
        );           

    URFFT_PT16_28 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(28),
            data_re_in(1)=>mul_re_out(60),
            data_re_in(2)=>mul_re_out(92),
            data_re_in(3)=>mul_re_out(124),
            data_re_in(4)=>mul_re_out(156),
            data_re_in(5)=>mul_re_out(188),
            data_re_in(6)=>mul_re_out(220),
            data_re_in(7)=>mul_re_out(252),
            data_re_in(8)=>mul_re_out(284),
            data_re_in(9)=>mul_re_out(316),
            data_re_in(10)=>mul_re_out(348),
            data_re_in(11)=>mul_re_out(380),
            data_re_in(12)=>mul_re_out(412),
            data_re_in(13)=>mul_re_out(444),
            data_re_in(14)=>mul_re_out(476),
            data_re_in(15)=>mul_re_out(508),
            data_im_in(0)=>mul_im_out(28),
            data_im_in(1)=>mul_im_out(60),
            data_im_in(2)=>mul_im_out(92),
            data_im_in(3)=>mul_im_out(124),
            data_im_in(4)=>mul_im_out(156),
            data_im_in(5)=>mul_im_out(188),
            data_im_in(6)=>mul_im_out(220),
            data_im_in(7)=>mul_im_out(252),
            data_im_in(8)=>mul_im_out(284),
            data_im_in(9)=>mul_im_out(316),
            data_im_in(10)=>mul_im_out(348),
            data_im_in(11)=>mul_im_out(380),
            data_im_in(12)=>mul_im_out(412),
            data_im_in(13)=>mul_im_out(444),
            data_im_in(14)=>mul_im_out(476),
            data_im_in(15)=>mul_im_out(508),
            data_re_out(0)=>data_re_out(28),
            data_re_out(1)=>data_re_out(60),
            data_re_out(2)=>data_re_out(92),
            data_re_out(3)=>data_re_out(124),
            data_re_out(4)=>data_re_out(156),
            data_re_out(5)=>data_re_out(188),
            data_re_out(6)=>data_re_out(220),
            data_re_out(7)=>data_re_out(252),
            data_re_out(8)=>data_re_out(284),
            data_re_out(9)=>data_re_out(316),
            data_re_out(10)=>data_re_out(348),
            data_re_out(11)=>data_re_out(380),
            data_re_out(12)=>data_re_out(412),
            data_re_out(13)=>data_re_out(444),
            data_re_out(14)=>data_re_out(476),
            data_re_out(15)=>data_re_out(508),
            data_im_out(0)=>data_im_out(28),
            data_im_out(1)=>data_im_out(60),
            data_im_out(2)=>data_im_out(92),
            data_im_out(3)=>data_im_out(124),
            data_im_out(4)=>data_im_out(156),
            data_im_out(5)=>data_im_out(188),
            data_im_out(6)=>data_im_out(220),
            data_im_out(7)=>data_im_out(252),
            data_im_out(8)=>data_im_out(284),
            data_im_out(9)=>data_im_out(316),
            data_im_out(10)=>data_im_out(348),
            data_im_out(11)=>data_im_out(380),
            data_im_out(12)=>data_im_out(412),
            data_im_out(13)=>data_im_out(444),
            data_im_out(14)=>data_im_out(476),
            data_im_out(15)=>data_im_out(508)
        );           

    URFFT_PT16_29 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(29),
            data_re_in(1)=>mul_re_out(61),
            data_re_in(2)=>mul_re_out(93),
            data_re_in(3)=>mul_re_out(125),
            data_re_in(4)=>mul_re_out(157),
            data_re_in(5)=>mul_re_out(189),
            data_re_in(6)=>mul_re_out(221),
            data_re_in(7)=>mul_re_out(253),
            data_re_in(8)=>mul_re_out(285),
            data_re_in(9)=>mul_re_out(317),
            data_re_in(10)=>mul_re_out(349),
            data_re_in(11)=>mul_re_out(381),
            data_re_in(12)=>mul_re_out(413),
            data_re_in(13)=>mul_re_out(445),
            data_re_in(14)=>mul_re_out(477),
            data_re_in(15)=>mul_re_out(509),
            data_im_in(0)=>mul_im_out(29),
            data_im_in(1)=>mul_im_out(61),
            data_im_in(2)=>mul_im_out(93),
            data_im_in(3)=>mul_im_out(125),
            data_im_in(4)=>mul_im_out(157),
            data_im_in(5)=>mul_im_out(189),
            data_im_in(6)=>mul_im_out(221),
            data_im_in(7)=>mul_im_out(253),
            data_im_in(8)=>mul_im_out(285),
            data_im_in(9)=>mul_im_out(317),
            data_im_in(10)=>mul_im_out(349),
            data_im_in(11)=>mul_im_out(381),
            data_im_in(12)=>mul_im_out(413),
            data_im_in(13)=>mul_im_out(445),
            data_im_in(14)=>mul_im_out(477),
            data_im_in(15)=>mul_im_out(509),
            data_re_out(0)=>data_re_out(29),
            data_re_out(1)=>data_re_out(61),
            data_re_out(2)=>data_re_out(93),
            data_re_out(3)=>data_re_out(125),
            data_re_out(4)=>data_re_out(157),
            data_re_out(5)=>data_re_out(189),
            data_re_out(6)=>data_re_out(221),
            data_re_out(7)=>data_re_out(253),
            data_re_out(8)=>data_re_out(285),
            data_re_out(9)=>data_re_out(317),
            data_re_out(10)=>data_re_out(349),
            data_re_out(11)=>data_re_out(381),
            data_re_out(12)=>data_re_out(413),
            data_re_out(13)=>data_re_out(445),
            data_re_out(14)=>data_re_out(477),
            data_re_out(15)=>data_re_out(509),
            data_im_out(0)=>data_im_out(29),
            data_im_out(1)=>data_im_out(61),
            data_im_out(2)=>data_im_out(93),
            data_im_out(3)=>data_im_out(125),
            data_im_out(4)=>data_im_out(157),
            data_im_out(5)=>data_im_out(189),
            data_im_out(6)=>data_im_out(221),
            data_im_out(7)=>data_im_out(253),
            data_im_out(8)=>data_im_out(285),
            data_im_out(9)=>data_im_out(317),
            data_im_out(10)=>data_im_out(349),
            data_im_out(11)=>data_im_out(381),
            data_im_out(12)=>data_im_out(413),
            data_im_out(13)=>data_im_out(445),
            data_im_out(14)=>data_im_out(477),
            data_im_out(15)=>data_im_out(509)
        );           

    URFFT_PT16_30 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(30),
            data_re_in(1)=>mul_re_out(62),
            data_re_in(2)=>mul_re_out(94),
            data_re_in(3)=>mul_re_out(126),
            data_re_in(4)=>mul_re_out(158),
            data_re_in(5)=>mul_re_out(190),
            data_re_in(6)=>mul_re_out(222),
            data_re_in(7)=>mul_re_out(254),
            data_re_in(8)=>mul_re_out(286),
            data_re_in(9)=>mul_re_out(318),
            data_re_in(10)=>mul_re_out(350),
            data_re_in(11)=>mul_re_out(382),
            data_re_in(12)=>mul_re_out(414),
            data_re_in(13)=>mul_re_out(446),
            data_re_in(14)=>mul_re_out(478),
            data_re_in(15)=>mul_re_out(510),
            data_im_in(0)=>mul_im_out(30),
            data_im_in(1)=>mul_im_out(62),
            data_im_in(2)=>mul_im_out(94),
            data_im_in(3)=>mul_im_out(126),
            data_im_in(4)=>mul_im_out(158),
            data_im_in(5)=>mul_im_out(190),
            data_im_in(6)=>mul_im_out(222),
            data_im_in(7)=>mul_im_out(254),
            data_im_in(8)=>mul_im_out(286),
            data_im_in(9)=>mul_im_out(318),
            data_im_in(10)=>mul_im_out(350),
            data_im_in(11)=>mul_im_out(382),
            data_im_in(12)=>mul_im_out(414),
            data_im_in(13)=>mul_im_out(446),
            data_im_in(14)=>mul_im_out(478),
            data_im_in(15)=>mul_im_out(510),
            data_re_out(0)=>data_re_out(30),
            data_re_out(1)=>data_re_out(62),
            data_re_out(2)=>data_re_out(94),
            data_re_out(3)=>data_re_out(126),
            data_re_out(4)=>data_re_out(158),
            data_re_out(5)=>data_re_out(190),
            data_re_out(6)=>data_re_out(222),
            data_re_out(7)=>data_re_out(254),
            data_re_out(8)=>data_re_out(286),
            data_re_out(9)=>data_re_out(318),
            data_re_out(10)=>data_re_out(350),
            data_re_out(11)=>data_re_out(382),
            data_re_out(12)=>data_re_out(414),
            data_re_out(13)=>data_re_out(446),
            data_re_out(14)=>data_re_out(478),
            data_re_out(15)=>data_re_out(510),
            data_im_out(0)=>data_im_out(30),
            data_im_out(1)=>data_im_out(62),
            data_im_out(2)=>data_im_out(94),
            data_im_out(3)=>data_im_out(126),
            data_im_out(4)=>data_im_out(158),
            data_im_out(5)=>data_im_out(190),
            data_im_out(6)=>data_im_out(222),
            data_im_out(7)=>data_im_out(254),
            data_im_out(8)=>data_im_out(286),
            data_im_out(9)=>data_im_out(318),
            data_im_out(10)=>data_im_out(350),
            data_im_out(11)=>data_im_out(382),
            data_im_out(12)=>data_im_out(414),
            data_im_out(13)=>data_im_out(446),
            data_im_out(14)=>data_im_out(478),
            data_im_out(15)=>data_im_out(510)
        );           

    URFFT_PT16_31 : fft_pt16
    generic map(
        ctrl_start => (ctrl_start+3) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(31),
            data_re_in(1)=>mul_re_out(63),
            data_re_in(2)=>mul_re_out(95),
            data_re_in(3)=>mul_re_out(127),
            data_re_in(4)=>mul_re_out(159),
            data_re_in(5)=>mul_re_out(191),
            data_re_in(6)=>mul_re_out(223),
            data_re_in(7)=>mul_re_out(255),
            data_re_in(8)=>mul_re_out(287),
            data_re_in(9)=>mul_re_out(319),
            data_re_in(10)=>mul_re_out(351),
            data_re_in(11)=>mul_re_out(383),
            data_re_in(12)=>mul_re_out(415),
            data_re_in(13)=>mul_re_out(447),
            data_re_in(14)=>mul_re_out(479),
            data_re_in(15)=>mul_re_out(511),
            data_im_in(0)=>mul_im_out(31),
            data_im_in(1)=>mul_im_out(63),
            data_im_in(2)=>mul_im_out(95),
            data_im_in(3)=>mul_im_out(127),
            data_im_in(4)=>mul_im_out(159),
            data_im_in(5)=>mul_im_out(191),
            data_im_in(6)=>mul_im_out(223),
            data_im_in(7)=>mul_im_out(255),
            data_im_in(8)=>mul_im_out(287),
            data_im_in(9)=>mul_im_out(319),
            data_im_in(10)=>mul_im_out(351),
            data_im_in(11)=>mul_im_out(383),
            data_im_in(12)=>mul_im_out(415),
            data_im_in(13)=>mul_im_out(447),
            data_im_in(14)=>mul_im_out(479),
            data_im_in(15)=>mul_im_out(511),
            data_re_out(0)=>data_re_out(31),
            data_re_out(1)=>data_re_out(63),
            data_re_out(2)=>data_re_out(95),
            data_re_out(3)=>data_re_out(127),
            data_re_out(4)=>data_re_out(159),
            data_re_out(5)=>data_re_out(191),
            data_re_out(6)=>data_re_out(223),
            data_re_out(7)=>data_re_out(255),
            data_re_out(8)=>data_re_out(287),
            data_re_out(9)=>data_re_out(319),
            data_re_out(10)=>data_re_out(351),
            data_re_out(11)=>data_re_out(383),
            data_re_out(12)=>data_re_out(415),
            data_re_out(13)=>data_re_out(447),
            data_re_out(14)=>data_re_out(479),
            data_re_out(15)=>data_re_out(511),
            data_im_out(0)=>data_im_out(31),
            data_im_out(1)=>data_im_out(63),
            data_im_out(2)=>data_im_out(95),
            data_im_out(3)=>data_im_out(127),
            data_im_out(4)=>data_im_out(159),
            data_im_out(5)=>data_im_out(191),
            data_im_out(6)=>data_im_out(223),
            data_im_out(7)=>data_im_out(255),
            data_im_out(8)=>data_im_out(287),
            data_im_out(9)=>data_im_out(319),
            data_im_out(10)=>data_im_out(351),
            data_im_out(11)=>data_im_out(383),
            data_im_out(12)=>data_im_out(415),
            data_im_out(13)=>data_im_out(447),
            data_im_out(14)=>data_im_out(479),
            data_im_out(15)=>data_im_out(511)
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(0),
            data_out=>mul_re_out(0)
        );
    USHIFTER_0_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(1),
            data_out=>mul_re_out(1)
        );
    USHIFTER_1_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(2),
            data_out=>mul_re_out(2)
        );
    USHIFTER_2_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(3),
            data_out=>mul_re_out(3)
        );
    USHIFTER_3_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(4),
            data_out=>mul_re_out(4)
        );
    USHIFTER_4_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(5),
            data_out=>mul_re_out(5)
        );
    USHIFTER_5_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(6),
            data_out=>mul_re_out(6)
        );
    USHIFTER_6_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(7),
            data_out=>mul_re_out(7)
        );
    USHIFTER_7_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(8),
            data_out=>mul_re_out(8)
        );
    USHIFTER_8_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(8),
            data_out=>mul_im_out(8)
        );

    UDELAY_9_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(9),
            clk=>clk,
            Q=>shifter_re(9)
        );
    UDELAY_9_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(9),
            clk=>clk,
            Q=>shifter_im(9)
        );
    USHIFTER_9_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(9),
            data_out=>mul_re_out(9)
        );
    USHIFTER_9_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(9),
            data_out=>mul_im_out(9)
        );

    UDELAY_10_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(10),
            clk=>clk,
            Q=>shifter_re(10)
        );
    UDELAY_10_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(10),
            clk=>clk,
            Q=>shifter_im(10)
        );
    USHIFTER_10_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(10),
            data_out=>mul_re_out(10)
        );
    USHIFTER_10_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(10),
            data_out=>mul_im_out(10)
        );

    UDELAY_11_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(11),
            clk=>clk,
            Q=>shifter_re(11)
        );
    UDELAY_11_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(11),
            clk=>clk,
            Q=>shifter_im(11)
        );
    USHIFTER_11_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(11),
            data_out=>mul_re_out(11)
        );
    USHIFTER_11_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(11),
            data_out=>mul_im_out(11)
        );

    UDELAY_12_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(12),
            clk=>clk,
            Q=>shifter_re(12)
        );
    UDELAY_12_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(12),
            clk=>clk,
            Q=>shifter_im(12)
        );
    USHIFTER_12_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(12),
            data_out=>mul_re_out(12)
        );
    USHIFTER_12_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(12),
            data_out=>mul_im_out(12)
        );

    UDELAY_13_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(13),
            clk=>clk,
            Q=>shifter_re(13)
        );
    UDELAY_13_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(13),
            clk=>clk,
            Q=>shifter_im(13)
        );
    USHIFTER_13_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(13),
            data_out=>mul_re_out(13)
        );
    USHIFTER_13_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(13),
            data_out=>mul_im_out(13)
        );

    UDELAY_14_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(14),
            clk=>clk,
            Q=>shifter_re(14)
        );
    UDELAY_14_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(14),
            clk=>clk,
            Q=>shifter_im(14)
        );
    USHIFTER_14_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(14),
            data_out=>mul_re_out(14)
        );
    USHIFTER_14_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(14),
            data_out=>mul_im_out(14)
        );

    UDELAY_15_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(15),
            clk=>clk,
            Q=>shifter_re(15)
        );
    UDELAY_15_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(15),
            clk=>clk,
            Q=>shifter_im(15)
        );
    USHIFTER_15_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(15),
            data_out=>mul_re_out(15)
        );
    USHIFTER_15_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(15),
            data_out=>mul_im_out(15)
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(16),
            data_out=>mul_re_out(16)
        );
    USHIFTER_16_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(16),
            data_out=>mul_im_out(16)
        );

    UDELAY_17_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(17),
            clk=>clk,
            Q=>shifter_re(17)
        );
    UDELAY_17_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(17),
            clk=>clk,
            Q=>shifter_im(17)
        );
    USHIFTER_17_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(17),
            data_out=>mul_re_out(17)
        );
    USHIFTER_17_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(17),
            data_out=>mul_im_out(17)
        );

    UDELAY_18_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(18),
            clk=>clk,
            Q=>shifter_re(18)
        );
    UDELAY_18_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(18),
            clk=>clk,
            Q=>shifter_im(18)
        );
    USHIFTER_18_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(18),
            data_out=>mul_re_out(18)
        );
    USHIFTER_18_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(18),
            data_out=>mul_im_out(18)
        );

    UDELAY_19_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(19),
            clk=>clk,
            Q=>shifter_re(19)
        );
    UDELAY_19_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(19),
            clk=>clk,
            Q=>shifter_im(19)
        );
    USHIFTER_19_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(19),
            data_out=>mul_re_out(19)
        );
    USHIFTER_19_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(19),
            data_out=>mul_im_out(19)
        );

    UDELAY_20_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(20),
            clk=>clk,
            Q=>shifter_re(20)
        );
    UDELAY_20_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(20),
            clk=>clk,
            Q=>shifter_im(20)
        );
    USHIFTER_20_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(20),
            data_out=>mul_re_out(20)
        );
    USHIFTER_20_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(20),
            data_out=>mul_im_out(20)
        );

    UDELAY_21_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(21),
            clk=>clk,
            Q=>shifter_re(21)
        );
    UDELAY_21_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(21),
            clk=>clk,
            Q=>shifter_im(21)
        );
    USHIFTER_21_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(21),
            data_out=>mul_re_out(21)
        );
    USHIFTER_21_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(21),
            data_out=>mul_im_out(21)
        );

    UDELAY_22_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(22),
            clk=>clk,
            Q=>shifter_re(22)
        );
    UDELAY_22_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(22),
            clk=>clk,
            Q=>shifter_im(22)
        );
    USHIFTER_22_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(22),
            data_out=>mul_re_out(22)
        );
    USHIFTER_22_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(22),
            data_out=>mul_im_out(22)
        );

    UDELAY_23_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(23),
            clk=>clk,
            Q=>shifter_re(23)
        );
    UDELAY_23_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(23),
            clk=>clk,
            Q=>shifter_im(23)
        );
    USHIFTER_23_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(23),
            data_out=>mul_re_out(23)
        );
    USHIFTER_23_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(23),
            data_out=>mul_im_out(23)
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(24),
            data_out=>mul_re_out(24)
        );
    USHIFTER_24_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(24),
            data_out=>mul_im_out(24)
        );

    UDELAY_25_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(25),
            clk=>clk,
            Q=>shifter_re(25)
        );
    UDELAY_25_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(25),
            clk=>clk,
            Q=>shifter_im(25)
        );
    USHIFTER_25_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(25),
            data_out=>mul_re_out(25)
        );
    USHIFTER_25_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(25),
            data_out=>mul_im_out(25)
        );

    UDELAY_26_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(26),
            clk=>clk,
            Q=>shifter_re(26)
        );
    UDELAY_26_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(26),
            clk=>clk,
            Q=>shifter_im(26)
        );
    USHIFTER_26_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(26),
            data_out=>mul_re_out(26)
        );
    USHIFTER_26_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(26),
            data_out=>mul_im_out(26)
        );

    UDELAY_27_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(27),
            clk=>clk,
            Q=>shifter_re(27)
        );
    UDELAY_27_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(27),
            clk=>clk,
            Q=>shifter_im(27)
        );
    USHIFTER_27_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(27),
            data_out=>mul_re_out(27)
        );
    USHIFTER_27_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(27),
            data_out=>mul_im_out(27)
        );

    UDELAY_28_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(28),
            clk=>clk,
            Q=>shifter_re(28)
        );
    UDELAY_28_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(28),
            clk=>clk,
            Q=>shifter_im(28)
        );
    USHIFTER_28_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(28),
            data_out=>mul_re_out(28)
        );
    USHIFTER_28_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(28),
            data_out=>mul_im_out(28)
        );

    UDELAY_29_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(29),
            clk=>clk,
            Q=>shifter_re(29)
        );
    UDELAY_29_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(29),
            clk=>clk,
            Q=>shifter_im(29)
        );
    USHIFTER_29_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(29),
            data_out=>mul_re_out(29)
        );
    USHIFTER_29_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(29),
            data_out=>mul_im_out(29)
        );

    UDELAY_30_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(30),
            clk=>clk,
            Q=>shifter_re(30)
        );
    UDELAY_30_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(30),
            clk=>clk,
            Q=>shifter_im(30)
        );
    USHIFTER_30_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(30),
            data_out=>mul_re_out(30)
        );
    USHIFTER_30_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(30),
            data_out=>mul_im_out(30)
        );

    UDELAY_31_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(31),
            clk=>clk,
            Q=>shifter_re(31)
        );
    UDELAY_31_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(31),
            clk=>clk,
            Q=>shifter_im(31)
        );
    USHIFTER_31_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(31),
            data_out=>mul_re_out(31)
        );
    USHIFTER_31_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(31),
            data_out=>mul_im_out(31)
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
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(32),
            data_out=>mul_re_out(32)
        );
    USHIFTER_32_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(32),
            data_out=>mul_im_out(32)
        );

    UMUL_33 : complex_multiplier
    generic map(
            re_multiplicator=>16382, --- 0.999877929688 + j-0.0122680664062
            im_multiplicator=>-201,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16379, --- 0.999694824219 + j-0.0245361328125
            im_multiplicator=>-402,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16372, --- 0.999267578125 + j-0.0368041992188
            im_multiplicator=>-603,
            ctrl_start => (ctrl_start+3) mod 16
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

    UMUL_36 : complex_multiplier
    generic map(
            re_multiplicator=>16364, --- 0.998779296875 + j-0.0490112304688
            im_multiplicator=>-803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(36),
            data_im_in=>first_stage_im_out(36),
            product_re_out=>mul_re_out(36),
            product_im_out=>mul_im_out(36)
        );

    UMUL_37 : complex_multiplier
    generic map(
            re_multiplicator=>16353, --- 0.998107910156 + j-0.061279296875
            im_multiplicator=>-1004,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16339, --- 0.997253417969 + j-0.0735473632812
            im_multiplicator=>-1205,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16323, --- 0.996276855469 + j-0.0857543945312
            im_multiplicator=>-1405,
            ctrl_start => (ctrl_start+3) mod 16
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

    UMUL_40 : complex_multiplier
    generic map(
            re_multiplicator=>16305, --- 0.995178222656 + j-0.0979614257812
            im_multiplicator=>-1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(40),
            data_im_in=>first_stage_im_out(40),
            product_re_out=>mul_re_out(40),
            product_im_out=>mul_im_out(40)
        );

    UMUL_41 : complex_multiplier
    generic map(
            re_multiplicator=>16284, --- 0.993896484375 + j-0.110168457031
            im_multiplicator=>-1805,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16260, --- 0.992431640625 + j-0.122375488281
            im_multiplicator=>-2005,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16234, --- 0.990844726562 + j-0.134521484375
            im_multiplicator=>-2204,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16206, --- 0.989135742188 + j-0.146728515625
            im_multiplicator=>-2404,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16175, --- 0.987243652344 + j-0.158813476562
            im_multiplicator=>-2602,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16142, --- 0.985229492188 + j-0.170959472656
            im_multiplicator=>-2801,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>16107, --- 0.983093261719 + j-0.182983398438
            im_multiplicator=>-2998,
            ctrl_start => (ctrl_start+3) mod 16
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

    UMUL_48 : complex_multiplier
    generic map(
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(48),
            data_im_in=>first_stage_im_out(48),
            product_re_out=>mul_re_out(48),
            product_im_out=>mul_im_out(48)
        );

    UMUL_49 : complex_multiplier
    generic map(
            re_multiplicator=>16028, --- 0.978271484375 + j-0.207092285156
            im_multiplicator=>-3393,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15985, --- 0.975646972656 + j-0.219055175781
            im_multiplicator=>-3589,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15940, --- 0.972900390625 + j-0.231018066406
            im_multiplicator=>-3785,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15892, --- 0.969970703125 + j-0.242919921875
            im_multiplicator=>-3980,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15842, --- 0.966918945312 + j-0.254821777344
            im_multiplicator=>-4175,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15790, --- 0.963745117188 + j-0.266662597656
            im_multiplicator=>-4369,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15735, --- 0.960388183594 + j-0.278503417969
            im_multiplicator=>-4563,
            ctrl_start => (ctrl_start+3) mod 16
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

    UMUL_56 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(56),
            data_im_in=>first_stage_im_out(56),
            product_re_out=>mul_re_out(56),
            product_im_out=>mul_im_out(56)
        );

    UMUL_57 : complex_multiplier
    generic map(
            re_multiplicator=>15618, --- 0.953247070312 + j-0.302001953125
            im_multiplicator=>-4948,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15557, --- 0.949523925781 + j-0.313659667969
            im_multiplicator=>-5139,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15492, --- 0.945556640625 + j-0.325256347656
            im_multiplicator=>-5329,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15426, --- 0.941528320312 + j-0.336853027344
            im_multiplicator=>-5519,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15357, --- 0.937316894531 + j-0.348388671875
            im_multiplicator=>-5708,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
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
            re_multiplicator=>15212, --- 0.928466796875 + j-0.371276855469
            im_multiplicator=>-6083,
            ctrl_start => (ctrl_start+3) mod 16
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

    UDELAY_64_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(64),
            clk=>clk,
            Q=>shifter_re(64)
        );
    UDELAY_64_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(64),
            clk=>clk,
            Q=>shifter_im(64)
        );
    USHIFTER_64_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(64),
            data_out=>mul_re_out(64)
        );
    USHIFTER_64_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(64),
            data_out=>mul_im_out(64)
        );

    UMUL_65 : complex_multiplier
    generic map(
            re_multiplicator=>16379, --- 0.999694824219 + j-0.0245361328125
            im_multiplicator=>-402,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(65),
            data_im_in=>first_stage_im_out(65),
            product_re_out=>mul_re_out(65),
            product_im_out=>mul_im_out(65)
        );

    UMUL_66 : complex_multiplier
    generic map(
            re_multiplicator=>16364, --- 0.998779296875 + j-0.0490112304688
            im_multiplicator=>-803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(66),
            data_im_in=>first_stage_im_out(66),
            product_re_out=>mul_re_out(66),
            product_im_out=>mul_im_out(66)
        );

    UMUL_67 : complex_multiplier
    generic map(
            re_multiplicator=>16339, --- 0.997253417969 + j-0.0735473632812
            im_multiplicator=>-1205,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(67),
            data_im_in=>first_stage_im_out(67),
            product_re_out=>mul_re_out(67),
            product_im_out=>mul_im_out(67)
        );

    UMUL_68 : complex_multiplier
    generic map(
            re_multiplicator=>16305, --- 0.995178222656 + j-0.0979614257812
            im_multiplicator=>-1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(68),
            data_im_in=>first_stage_im_out(68),
            product_re_out=>mul_re_out(68),
            product_im_out=>mul_im_out(68)
        );

    UMUL_69 : complex_multiplier
    generic map(
            re_multiplicator=>16260, --- 0.992431640625 + j-0.122375488281
            im_multiplicator=>-2005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(69),
            data_im_in=>first_stage_im_out(69),
            product_re_out=>mul_re_out(69),
            product_im_out=>mul_im_out(69)
        );

    UMUL_70 : complex_multiplier
    generic map(
            re_multiplicator=>16206, --- 0.989135742188 + j-0.146728515625
            im_multiplicator=>-2404,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(70),
            data_im_in=>first_stage_im_out(70),
            product_re_out=>mul_re_out(70),
            product_im_out=>mul_im_out(70)
        );

    UMUL_71 : complex_multiplier
    generic map(
            re_multiplicator=>16142, --- 0.985229492188 + j-0.170959472656
            im_multiplicator=>-2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(71),
            data_im_in=>first_stage_im_out(71),
            product_re_out=>mul_re_out(71),
            product_im_out=>mul_im_out(71)
        );

    UMUL_72 : complex_multiplier
    generic map(
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(72),
            data_im_in=>first_stage_im_out(72),
            product_re_out=>mul_re_out(72),
            product_im_out=>mul_im_out(72)
        );

    UMUL_73 : complex_multiplier
    generic map(
            re_multiplicator=>15985, --- 0.975646972656 + j-0.219055175781
            im_multiplicator=>-3589,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(73),
            data_im_in=>first_stage_im_out(73),
            product_re_out=>mul_re_out(73),
            product_im_out=>mul_im_out(73)
        );

    UMUL_74 : complex_multiplier
    generic map(
            re_multiplicator=>15892, --- 0.969970703125 + j-0.242919921875
            im_multiplicator=>-3980,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(74),
            data_im_in=>first_stage_im_out(74),
            product_re_out=>mul_re_out(74),
            product_im_out=>mul_im_out(74)
        );

    UMUL_75 : complex_multiplier
    generic map(
            re_multiplicator=>15790, --- 0.963745117188 + j-0.266662597656
            im_multiplicator=>-4369,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(75),
            data_im_in=>first_stage_im_out(75),
            product_re_out=>mul_re_out(75),
            product_im_out=>mul_im_out(75)
        );

    UMUL_76 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(76),
            data_im_in=>first_stage_im_out(76),
            product_re_out=>mul_re_out(76),
            product_im_out=>mul_im_out(76)
        );

    UMUL_77 : complex_multiplier
    generic map(
            re_multiplicator=>15557, --- 0.949523925781 + j-0.313659667969
            im_multiplicator=>-5139,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(77),
            data_im_in=>first_stage_im_out(77),
            product_re_out=>mul_re_out(77),
            product_im_out=>mul_im_out(77)
        );

    UMUL_78 : complex_multiplier
    generic map(
            re_multiplicator=>15426, --- 0.941528320312 + j-0.336853027344
            im_multiplicator=>-5519,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(78),
            data_im_in=>first_stage_im_out(78),
            product_re_out=>mul_re_out(78),
            product_im_out=>mul_im_out(78)
        );

    UMUL_79 : complex_multiplier
    generic map(
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(79),
            data_im_in=>first_stage_im_out(79),
            product_re_out=>mul_re_out(79),
            product_im_out=>mul_im_out(79)
        );

    UMUL_80 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(80),
            data_im_in=>first_stage_im_out(80),
            product_re_out=>mul_re_out(80),
            product_im_out=>mul_im_out(80)
        );

    UMUL_81 : complex_multiplier
    generic map(
            re_multiplicator=>14978, --- 0.914184570312 + j-0.405212402344
            im_multiplicator=>-6639,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(81),
            data_im_in=>first_stage_im_out(81),
            product_re_out=>mul_re_out(81),
            product_im_out=>mul_im_out(81)
        );

    UMUL_82 : complex_multiplier
    generic map(
            re_multiplicator=>14810, --- 0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(82),
            data_im_in=>first_stage_im_out(82),
            product_re_out=>mul_re_out(82),
            product_im_out=>mul_im_out(82)
        );

    UMUL_83 : complex_multiplier
    generic map(
            re_multiplicator=>14634, --- 0.893188476562 + j-0.449584960938
            im_multiplicator=>-7366,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(83),
            data_im_in=>first_stage_im_out(83),
            product_re_out=>mul_re_out(83),
            product_im_out=>mul_im_out(83)
        );

    UMUL_84 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(84),
            data_im_in=>first_stage_im_out(84),
            product_re_out=>mul_re_out(84),
            product_im_out=>mul_im_out(84)
        );

    UMUL_85 : complex_multiplier
    generic map(
            re_multiplicator=>14255, --- 0.870056152344 + j-0.492858886719
            im_multiplicator=>-8075,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(85),
            data_im_in=>first_stage_im_out(85),
            product_re_out=>mul_re_out(85),
            product_im_out=>mul_im_out(85)
        );

    UMUL_86 : complex_multiplier
    generic map(
            re_multiplicator=>14053, --- 0.857727050781 + j-0.514099121094
            im_multiplicator=>-8423,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(86),
            data_im_in=>first_stage_im_out(86),
            product_re_out=>mul_re_out(86),
            product_im_out=>mul_im_out(86)
        );

    UMUL_87 : complex_multiplier
    generic map(
            re_multiplicator=>13842, --- 0.844848632812 + j-0.534973144531
            im_multiplicator=>-8765,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(87),
            data_im_in=>first_stage_im_out(87),
            product_re_out=>mul_re_out(87),
            product_im_out=>mul_im_out(87)
        );

    UMUL_88 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(88),
            data_im_in=>first_stage_im_out(88),
            product_re_out=>mul_re_out(88),
            product_im_out=>mul_im_out(88)
        );

    UMUL_89 : complex_multiplier
    generic map(
            re_multiplicator=>13395, --- 0.817565917969 + j-0.575805664062
            im_multiplicator=>-9434,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(89),
            data_im_in=>first_stage_im_out(89),
            product_re_out=>mul_re_out(89),
            product_im_out=>mul_im_out(89)
        );

    UMUL_90 : complex_multiplier
    generic map(
            re_multiplicator=>13159, --- 0.803161621094 + j-0.595642089844
            im_multiplicator=>-9759,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(90),
            data_im_in=>first_stage_im_out(90),
            product_re_out=>mul_re_out(90),
            product_im_out=>mul_im_out(90)
        );

    UMUL_91 : complex_multiplier
    generic map(
            re_multiplicator=>12916, --- 0.788330078125 + j-0.615173339844
            im_multiplicator=>-10079,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(91),
            data_im_in=>first_stage_im_out(91),
            product_re_out=>mul_re_out(91),
            product_im_out=>mul_im_out(91)
        );

    UMUL_92 : complex_multiplier
    generic map(
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(92),
            data_im_in=>first_stage_im_out(92),
            product_re_out=>mul_re_out(92),
            product_im_out=>mul_im_out(92)
        );

    UMUL_93 : complex_multiplier
    generic map(
            re_multiplicator=>12406, --- 0.757202148438 + j-0.653137207031
            im_multiplicator=>-10701,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(93),
            data_im_in=>first_stage_im_out(93),
            product_re_out=>mul_re_out(93),
            product_im_out=>mul_im_out(93)
        );

    UMUL_94 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(94),
            data_im_in=>first_stage_im_out(94),
            product_re_out=>mul_re_out(94),
            product_im_out=>mul_im_out(94)
        );

    UMUL_95 : complex_multiplier
    generic map(
            re_multiplicator=>11866, --- 0.724243164062 + j-0.689514160156
            im_multiplicator=>-11297,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(95),
            data_im_in=>first_stage_im_out(95),
            product_re_out=>mul_re_out(95),
            product_im_out=>mul_im_out(95)
        );

    UDELAY_96_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(96),
            clk=>clk,
            Q=>shifter_re(96)
        );
    UDELAY_96_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(96),
            clk=>clk,
            Q=>shifter_im(96)
        );
    USHIFTER_96_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(96),
            data_out=>mul_re_out(96)
        );
    USHIFTER_96_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(96),
            data_out=>mul_im_out(96)
        );

    UMUL_97 : complex_multiplier
    generic map(
            re_multiplicator=>16372, --- 0.999267578125 + j-0.0368041992188
            im_multiplicator=>-603,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(97),
            data_im_in=>first_stage_im_out(97),
            product_re_out=>mul_re_out(97),
            product_im_out=>mul_im_out(97)
        );

    UMUL_98 : complex_multiplier
    generic map(
            re_multiplicator=>16339, --- 0.997253417969 + j-0.0735473632812
            im_multiplicator=>-1205,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(98),
            data_im_in=>first_stage_im_out(98),
            product_re_out=>mul_re_out(98),
            product_im_out=>mul_im_out(98)
        );

    UMUL_99 : complex_multiplier
    generic map(
            re_multiplicator=>16284, --- 0.993896484375 + j-0.110168457031
            im_multiplicator=>-1805,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(99),
            data_im_in=>first_stage_im_out(99),
            product_re_out=>mul_re_out(99),
            product_im_out=>mul_im_out(99)
        );

    UMUL_100 : complex_multiplier
    generic map(
            re_multiplicator=>16206, --- 0.989135742188 + j-0.146728515625
            im_multiplicator=>-2404,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(100),
            data_im_in=>first_stage_im_out(100),
            product_re_out=>mul_re_out(100),
            product_im_out=>mul_im_out(100)
        );

    UMUL_101 : complex_multiplier
    generic map(
            re_multiplicator=>16107, --- 0.983093261719 + j-0.182983398438
            im_multiplicator=>-2998,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(101),
            data_im_in=>first_stage_im_out(101),
            product_re_out=>mul_re_out(101),
            product_im_out=>mul_im_out(101)
        );

    UMUL_102 : complex_multiplier
    generic map(
            re_multiplicator=>15985, --- 0.975646972656 + j-0.219055175781
            im_multiplicator=>-3589,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(102),
            data_im_in=>first_stage_im_out(102),
            product_re_out=>mul_re_out(102),
            product_im_out=>mul_im_out(102)
        );

    UMUL_103 : complex_multiplier
    generic map(
            re_multiplicator=>15842, --- 0.966918945312 + j-0.254821777344
            im_multiplicator=>-4175,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(103),
            data_im_in=>first_stage_im_out(103),
            product_re_out=>mul_re_out(103),
            product_im_out=>mul_im_out(103)
        );

    UMUL_104 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(104),
            data_im_in=>first_stage_im_out(104),
            product_re_out=>mul_re_out(104),
            product_im_out=>mul_im_out(104)
        );

    UMUL_105 : complex_multiplier
    generic map(
            re_multiplicator=>15492, --- 0.945556640625 + j-0.325256347656
            im_multiplicator=>-5329,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(105),
            data_im_in=>first_stage_im_out(105),
            product_re_out=>mul_re_out(105),
            product_im_out=>mul_im_out(105)
        );

    UMUL_106 : complex_multiplier
    generic map(
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(106),
            data_im_in=>first_stage_im_out(106),
            product_re_out=>mul_re_out(106),
            product_im_out=>mul_im_out(106)
        );

    UMUL_107 : complex_multiplier
    generic map(
            re_multiplicator=>15058, --- 0.919067382812 + j-0.393981933594
            im_multiplicator=>-6455,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(107),
            data_im_in=>first_stage_im_out(107),
            product_re_out=>mul_re_out(107),
            product_im_out=>mul_im_out(107)
        );

    UMUL_108 : complex_multiplier
    generic map(
            re_multiplicator=>14810, --- 0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(108),
            data_im_in=>first_stage_im_out(108),
            product_re_out=>mul_re_out(108),
            product_im_out=>mul_im_out(108)
        );

    UMUL_109 : complex_multiplier
    generic map(
            re_multiplicator=>14543, --- 0.887634277344 + j-0.460510253906
            im_multiplicator=>-7545,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(109),
            data_im_in=>first_stage_im_out(109),
            product_re_out=>mul_re_out(109),
            product_im_out=>mul_im_out(109)
        );

    UMUL_110 : complex_multiplier
    generic map(
            re_multiplicator=>14255, --- 0.870056152344 + j-0.492858886719
            im_multiplicator=>-8075,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(110),
            data_im_in=>first_stage_im_out(110),
            product_re_out=>mul_re_out(110),
            product_im_out=>mul_im_out(110)
        );

    UMUL_111 : complex_multiplier
    generic map(
            re_multiplicator=>13948, --- 0.851318359375 + j-0.524536132812
            im_multiplicator=>-8594,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(111),
            data_im_in=>first_stage_im_out(111),
            product_re_out=>mul_re_out(111),
            product_im_out=>mul_im_out(111)
        );

    UMUL_112 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(112),
            data_im_in=>first_stage_im_out(112),
            product_re_out=>mul_re_out(112),
            product_im_out=>mul_im_out(112)
        );

    UMUL_113 : complex_multiplier
    generic map(
            re_multiplicator=>13278, --- 0.810424804688 + j-0.585754394531
            im_multiplicator=>-9597,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(113),
            data_im_in=>first_stage_im_out(113),
            product_re_out=>mul_re_out(113),
            product_im_out=>mul_im_out(113)
        );

    UMUL_114 : complex_multiplier
    generic map(
            re_multiplicator=>12916, --- 0.788330078125 + j-0.615173339844
            im_multiplicator=>-10079,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(114),
            data_im_in=>first_stage_im_out(114),
            product_re_out=>mul_re_out(114),
            product_im_out=>mul_im_out(114)
        );

    UMUL_115 : complex_multiplier
    generic map(
            re_multiplicator=>12536, --- 0.76513671875 + j-0.643798828125
            im_multiplicator=>-10548,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(115),
            data_im_in=>first_stage_im_out(115),
            product_re_out=>mul_re_out(115),
            product_im_out=>mul_im_out(115)
        );

    UMUL_116 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(116),
            data_im_in=>first_stage_im_out(116),
            product_re_out=>mul_re_out(116),
            product_im_out=>mul_im_out(116)
        );

    UMUL_117 : complex_multiplier
    generic map(
            re_multiplicator=>11726, --- 0.715698242188 + j-0.698364257812
            im_multiplicator=>-11442,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(117),
            data_im_in=>first_stage_im_out(117),
            product_re_out=>mul_re_out(117),
            product_im_out=>mul_im_out(117)
        );

    UMUL_118 : complex_multiplier
    generic map(
            re_multiplicator=>11297, --- 0.689514160156 + j-0.724243164062
            im_multiplicator=>-11866,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(118),
            data_im_in=>first_stage_im_out(118),
            product_re_out=>mul_re_out(118),
            product_im_out=>mul_im_out(118)
        );

    UMUL_119 : complex_multiplier
    generic map(
            re_multiplicator=>10853, --- 0.662414550781 + j-0.749084472656
            im_multiplicator=>-12273,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(119),
            data_im_in=>first_stage_im_out(119),
            product_re_out=>mul_re_out(119),
            product_im_out=>mul_im_out(119)
        );

    UMUL_120 : complex_multiplier
    generic map(
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(120),
            data_im_in=>first_stage_im_out(120),
            product_re_out=>mul_re_out(120),
            product_im_out=>mul_im_out(120)
        );

    UMUL_121 : complex_multiplier
    generic map(
            re_multiplicator=>9920, --- 0.60546875 + j-0.795776367188
            im_multiplicator=>-13038,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(121),
            data_im_in=>first_stage_im_out(121),
            product_re_out=>mul_re_out(121),
            product_im_out=>mul_im_out(121)
        );

    UMUL_122 : complex_multiplier
    generic map(
            re_multiplicator=>9434, --- 0.575805664062 + j-0.817565917969
            im_multiplicator=>-13395,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(122),
            data_im_in=>first_stage_im_out(122),
            product_re_out=>mul_re_out(122),
            product_im_out=>mul_im_out(122)
        );

    UMUL_123 : complex_multiplier
    generic map(
            re_multiplicator=>8934, --- 0.545288085938 + j-0.838195800781
            im_multiplicator=>-13733,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(123),
            data_im_in=>first_stage_im_out(123),
            product_re_out=>mul_re_out(123),
            product_im_out=>mul_im_out(123)
        );

    UMUL_124 : complex_multiplier
    generic map(
            re_multiplicator=>8423, --- 0.514099121094 + j-0.857727050781
            im_multiplicator=>-14053,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(124),
            data_im_in=>first_stage_im_out(124),
            product_re_out=>mul_re_out(124),
            product_im_out=>mul_im_out(124)
        );

    UMUL_125 : complex_multiplier
    generic map(
            re_multiplicator=>7900, --- 0.482177734375 + j-0.876037597656
            im_multiplicator=>-14353,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(125),
            data_im_in=>first_stage_im_out(125),
            product_re_out=>mul_re_out(125),
            product_im_out=>mul_im_out(125)
        );

    UMUL_126 : complex_multiplier
    generic map(
            re_multiplicator=>7366, --- 0.449584960938 + j-0.893188476562
            im_multiplicator=>-14634,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(126),
            data_im_in=>first_stage_im_out(126),
            product_re_out=>mul_re_out(126),
            product_im_out=>mul_im_out(126)
        );

    UMUL_127 : complex_multiplier
    generic map(
            re_multiplicator=>6822, --- 0.416381835938 + j-0.909118652344
            im_multiplicator=>-14895,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(127),
            data_im_in=>first_stage_im_out(127),
            product_re_out=>mul_re_out(127),
            product_im_out=>mul_im_out(127)
        );

    UDELAY_128_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(128),
            clk=>clk,
            Q=>shifter_re(128)
        );
    UDELAY_128_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(128),
            clk=>clk,
            Q=>shifter_im(128)
        );
    USHIFTER_128_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(128),
            data_out=>mul_re_out(128)
        );
    USHIFTER_128_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(128),
            data_out=>mul_im_out(128)
        );

    UMUL_129 : complex_multiplier
    generic map(
            re_multiplicator=>16364, --- 0.998779296875 + j-0.0490112304688
            im_multiplicator=>-803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(129),
            data_im_in=>first_stage_im_out(129),
            product_re_out=>mul_re_out(129),
            product_im_out=>mul_im_out(129)
        );

    UMUL_130 : complex_multiplier
    generic map(
            re_multiplicator=>16305, --- 0.995178222656 + j-0.0979614257812
            im_multiplicator=>-1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(130),
            data_im_in=>first_stage_im_out(130),
            product_re_out=>mul_re_out(130),
            product_im_out=>mul_im_out(130)
        );

    UMUL_131 : complex_multiplier
    generic map(
            re_multiplicator=>16206, --- 0.989135742188 + j-0.146728515625
            im_multiplicator=>-2404,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(131),
            data_im_in=>first_stage_im_out(131),
            product_re_out=>mul_re_out(131),
            product_im_out=>mul_im_out(131)
        );

    UMUL_132 : complex_multiplier
    generic map(
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(132),
            data_im_in=>first_stage_im_out(132),
            product_re_out=>mul_re_out(132),
            product_im_out=>mul_im_out(132)
        );

    UMUL_133 : complex_multiplier
    generic map(
            re_multiplicator=>15892, --- 0.969970703125 + j-0.242919921875
            im_multiplicator=>-3980,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(133),
            data_im_in=>first_stage_im_out(133),
            product_re_out=>mul_re_out(133),
            product_im_out=>mul_im_out(133)
        );

    UMUL_134 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(134),
            data_im_in=>first_stage_im_out(134),
            product_re_out=>mul_re_out(134),
            product_im_out=>mul_im_out(134)
        );

    UMUL_135 : complex_multiplier
    generic map(
            re_multiplicator=>15426, --- 0.941528320312 + j-0.336853027344
            im_multiplicator=>-5519,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(135),
            data_im_in=>first_stage_im_out(135),
            product_re_out=>mul_re_out(135),
            product_im_out=>mul_im_out(135)
        );

    UMUL_136 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(136),
            data_im_in=>first_stage_im_out(136),
            product_re_out=>mul_re_out(136),
            product_im_out=>mul_im_out(136)
        );

    UMUL_137 : complex_multiplier
    generic map(
            re_multiplicator=>14810, --- 0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(137),
            data_im_in=>first_stage_im_out(137),
            product_re_out=>mul_re_out(137),
            product_im_out=>mul_im_out(137)
        );

    UMUL_138 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(138),
            data_im_in=>first_stage_im_out(138),
            product_re_out=>mul_re_out(138),
            product_im_out=>mul_im_out(138)
        );

    UMUL_139 : complex_multiplier
    generic map(
            re_multiplicator=>14053, --- 0.857727050781 + j-0.514099121094
            im_multiplicator=>-8423,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(139),
            data_im_in=>first_stage_im_out(139),
            product_re_out=>mul_re_out(139),
            product_im_out=>mul_im_out(139)
        );

    UMUL_140 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(140),
            data_im_in=>first_stage_im_out(140),
            product_re_out=>mul_re_out(140),
            product_im_out=>mul_im_out(140)
        );

    UMUL_141 : complex_multiplier
    generic map(
            re_multiplicator=>13159, --- 0.803161621094 + j-0.595642089844
            im_multiplicator=>-9759,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(141),
            data_im_in=>first_stage_im_out(141),
            product_re_out=>mul_re_out(141),
            product_im_out=>mul_im_out(141)
        );

    UMUL_142 : complex_multiplier
    generic map(
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(142),
            data_im_in=>first_stage_im_out(142),
            product_re_out=>mul_re_out(142),
            product_im_out=>mul_im_out(142)
        );

    UMUL_143 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(143),
            data_im_in=>first_stage_im_out(143),
            product_re_out=>mul_re_out(143),
            product_im_out=>mul_im_out(143)
        );

    UMUL_144 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(144),
            data_im_in=>first_stage_im_out(144),
            product_re_out=>mul_re_out(144),
            product_im_out=>mul_im_out(144)
        );

    UMUL_145 : complex_multiplier
    generic map(
            re_multiplicator=>11002, --- 0.671508789062 + j-0.740905761719
            im_multiplicator=>-12139,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(145),
            data_im_in=>first_stage_im_out(145),
            product_re_out=>mul_re_out(145),
            product_im_out=>mul_im_out(145)
        );

    UMUL_146 : complex_multiplier
    generic map(
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(146),
            data_im_in=>first_stage_im_out(146),
            product_re_out=>mul_re_out(146),
            product_im_out=>mul_im_out(146)
        );

    UMUL_147 : complex_multiplier
    generic map(
            re_multiplicator=>9759, --- 0.595642089844 + j-0.803161621094
            im_multiplicator=>-13159,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(147),
            data_im_in=>first_stage_im_out(147),
            product_re_out=>mul_re_out(147),
            product_im_out=>mul_im_out(147)
        );

    UMUL_148 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(148),
            data_im_in=>first_stage_im_out(148),
            product_re_out=>mul_re_out(148),
            product_im_out=>mul_im_out(148)
        );

    UMUL_149 : complex_multiplier
    generic map(
            re_multiplicator=>8423, --- 0.514099121094 + j-0.857727050781
            im_multiplicator=>-14053,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(149),
            data_im_in=>first_stage_im_out(149),
            product_re_out=>mul_re_out(149),
            product_im_out=>mul_im_out(149)
        );

    UMUL_150 : complex_multiplier
    generic map(
            re_multiplicator=>7723, --- 0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(150),
            data_im_in=>first_stage_im_out(150),
            product_re_out=>mul_re_out(150),
            product_im_out=>mul_im_out(150)
        );

    UMUL_151 : complex_multiplier
    generic map(
            re_multiplicator=>7005, --- 0.427551269531 + j-0.903930664062
            im_multiplicator=>-14810,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(151),
            data_im_in=>first_stage_im_out(151),
            product_re_out=>mul_re_out(151),
            product_im_out=>mul_im_out(151)
        );

    UMUL_152 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(152),
            data_im_in=>first_stage_im_out(152),
            product_re_out=>mul_re_out(152),
            product_im_out=>mul_im_out(152)
        );

    UMUL_153 : complex_multiplier
    generic map(
            re_multiplicator=>5519, --- 0.336853027344 + j-0.941528320312
            im_multiplicator=>-15426,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(153),
            data_im_in=>first_stage_im_out(153),
            product_re_out=>mul_re_out(153),
            product_im_out=>mul_im_out(153)
        );

    UMUL_154 : complex_multiplier
    generic map(
            re_multiplicator=>4756, --- 0.290283203125 + j-0.956909179688
            im_multiplicator=>-15678,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(154),
            data_im_in=>first_stage_im_out(154),
            product_re_out=>mul_re_out(154),
            product_im_out=>mul_im_out(154)
        );

    UMUL_155 : complex_multiplier
    generic map(
            re_multiplicator=>3980, --- 0.242919921875 + j-0.969970703125
            im_multiplicator=>-15892,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(155),
            data_im_in=>first_stage_im_out(155),
            product_re_out=>mul_re_out(155),
            product_im_out=>mul_im_out(155)
        );

    UMUL_156 : complex_multiplier
    generic map(
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(156),
            data_im_in=>first_stage_im_out(156),
            product_re_out=>mul_re_out(156),
            product_im_out=>mul_im_out(156)
        );

    UMUL_157 : complex_multiplier
    generic map(
            re_multiplicator=>2404, --- 0.146728515625 + j-0.989135742188
            im_multiplicator=>-16206,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(157),
            data_im_in=>first_stage_im_out(157),
            product_re_out=>mul_re_out(157),
            product_im_out=>mul_im_out(157)
        );

    UMUL_158 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(158),
            data_im_in=>first_stage_im_out(158),
            product_re_out=>mul_re_out(158),
            product_im_out=>mul_im_out(158)
        );

    UMUL_159 : complex_multiplier
    generic map(
            re_multiplicator=>803, --- 0.0490112304688 + j-0.998779296875
            im_multiplicator=>-16364,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(159),
            data_im_in=>first_stage_im_out(159),
            product_re_out=>mul_re_out(159),
            product_im_out=>mul_im_out(159)
        );

    UDELAY_160_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(160),
            clk=>clk,
            Q=>shifter_re(160)
        );
    UDELAY_160_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(160),
            clk=>clk,
            Q=>shifter_im(160)
        );
    USHIFTER_160_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(160),
            data_out=>mul_re_out(160)
        );
    USHIFTER_160_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(160),
            data_out=>mul_im_out(160)
        );

    UMUL_161 : complex_multiplier
    generic map(
            re_multiplicator=>16353, --- 0.998107910156 + j-0.061279296875
            im_multiplicator=>-1004,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(161),
            data_im_in=>first_stage_im_out(161),
            product_re_out=>mul_re_out(161),
            product_im_out=>mul_im_out(161)
        );

    UMUL_162 : complex_multiplier
    generic map(
            re_multiplicator=>16260, --- 0.992431640625 + j-0.122375488281
            im_multiplicator=>-2005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(162),
            data_im_in=>first_stage_im_out(162),
            product_re_out=>mul_re_out(162),
            product_im_out=>mul_im_out(162)
        );

    UMUL_163 : complex_multiplier
    generic map(
            re_multiplicator=>16107, --- 0.983093261719 + j-0.182983398438
            im_multiplicator=>-2998,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(163),
            data_im_in=>first_stage_im_out(163),
            product_re_out=>mul_re_out(163),
            product_im_out=>mul_im_out(163)
        );

    UMUL_164 : complex_multiplier
    generic map(
            re_multiplicator=>15892, --- 0.969970703125 + j-0.242919921875
            im_multiplicator=>-3980,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(164),
            data_im_in=>first_stage_im_out(164),
            product_re_out=>mul_re_out(164),
            product_im_out=>mul_im_out(164)
        );

    UMUL_165 : complex_multiplier
    generic map(
            re_multiplicator=>15618, --- 0.953247070312 + j-0.302001953125
            im_multiplicator=>-4948,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(165),
            data_im_in=>first_stage_im_out(165),
            product_re_out=>mul_re_out(165),
            product_im_out=>mul_im_out(165)
        );

    UMUL_166 : complex_multiplier
    generic map(
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(166),
            data_im_in=>first_stage_im_out(166),
            product_re_out=>mul_re_out(166),
            product_im_out=>mul_im_out(166)
        );

    UMUL_167 : complex_multiplier
    generic map(
            re_multiplicator=>14895, --- 0.909118652344 + j-0.416381835938
            im_multiplicator=>-6822,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(167),
            data_im_in=>first_stage_im_out(167),
            product_re_out=>mul_re_out(167),
            product_im_out=>mul_im_out(167)
        );

    UMUL_168 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(168),
            data_im_in=>first_stage_im_out(168),
            product_re_out=>mul_re_out(168),
            product_im_out=>mul_im_out(168)
        );

    UMUL_169 : complex_multiplier
    generic map(
            re_multiplicator=>13948, --- 0.851318359375 + j-0.524536132812
            im_multiplicator=>-8594,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(169),
            data_im_in=>first_stage_im_out(169),
            product_re_out=>mul_re_out(169),
            product_im_out=>mul_im_out(169)
        );

    UMUL_170 : complex_multiplier
    generic map(
            re_multiplicator=>13395, --- 0.817565917969 + j-0.575805664062
            im_multiplicator=>-9434,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(170),
            data_im_in=>first_stage_im_out(170),
            product_re_out=>mul_re_out(170),
            product_im_out=>mul_im_out(170)
        );

    UMUL_171 : complex_multiplier
    generic map(
            re_multiplicator=>12791, --- 0.780700683594 + j-0.624816894531
            im_multiplicator=>-10237,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(171),
            data_im_in=>first_stage_im_out(171),
            product_re_out=>mul_re_out(171),
            product_im_out=>mul_im_out(171)
        );

    UMUL_172 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(172),
            data_im_in=>first_stage_im_out(172),
            product_re_out=>mul_re_out(172),
            product_im_out=>mul_im_out(172)
        );

    UMUL_173 : complex_multiplier
    generic map(
            re_multiplicator=>11442, --- 0.698364257812 + j-0.715698242188
            im_multiplicator=>-11726,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(173),
            data_im_in=>first_stage_im_out(173),
            product_re_out=>mul_re_out(173),
            product_im_out=>mul_im_out(173)
        );

    UMUL_174 : complex_multiplier
    generic map(
            re_multiplicator=>10701, --- 0.653137207031 + j-0.757202148438
            im_multiplicator=>-12406,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(174),
            data_im_in=>first_stage_im_out(174),
            product_re_out=>mul_re_out(174),
            product_im_out=>mul_im_out(174)
        );

    UMUL_175 : complex_multiplier
    generic map(
            re_multiplicator=>9920, --- 0.60546875 + j-0.795776367188
            im_multiplicator=>-13038,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(175),
            data_im_in=>first_stage_im_out(175),
            product_re_out=>mul_re_out(175),
            product_im_out=>mul_im_out(175)
        );

    UMUL_176 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(176),
            data_im_in=>first_stage_im_out(176),
            product_re_out=>mul_re_out(176),
            product_im_out=>mul_im_out(176)
        );

    UMUL_177 : complex_multiplier
    generic map(
            re_multiplicator=>8249, --- 0.503479003906 + j-0.863952636719
            im_multiplicator=>-14155,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(177),
            data_im_in=>first_stage_im_out(177),
            product_re_out=>mul_re_out(177),
            product_im_out=>mul_im_out(177)
        );

    UMUL_178 : complex_multiplier
    generic map(
            re_multiplicator=>7366, --- 0.449584960938 + j-0.893188476562
            im_multiplicator=>-14634,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(178),
            data_im_in=>first_stage_im_out(178),
            product_re_out=>mul_re_out(178),
            product_im_out=>mul_im_out(178)
        );

    UMUL_179 : complex_multiplier
    generic map(
            re_multiplicator=>6455, --- 0.393981933594 + j-0.919067382812
            im_multiplicator=>-15058,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(179),
            data_im_in=>first_stage_im_out(179),
            product_re_out=>mul_re_out(179),
            product_im_out=>mul_im_out(179)
        );

    UMUL_180 : complex_multiplier
    generic map(
            re_multiplicator=>5519, --- 0.336853027344 + j-0.941528320312
            im_multiplicator=>-15426,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(180),
            data_im_in=>first_stage_im_out(180),
            product_re_out=>mul_re_out(180),
            product_im_out=>mul_im_out(180)
        );

    UMUL_181 : complex_multiplier
    generic map(
            re_multiplicator=>4563, --- 0.278503417969 + j-0.960388183594
            im_multiplicator=>-15735,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(181),
            data_im_in=>first_stage_im_out(181),
            product_re_out=>mul_re_out(181),
            product_im_out=>mul_im_out(181)
        );

    UMUL_182 : complex_multiplier
    generic map(
            re_multiplicator=>3589, --- 0.219055175781 + j-0.975646972656
            im_multiplicator=>-15985,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(182),
            data_im_in=>first_stage_im_out(182),
            product_re_out=>mul_re_out(182),
            product_im_out=>mul_im_out(182)
        );

    UMUL_183 : complex_multiplier
    generic map(
            re_multiplicator=>2602, --- 0.158813476562 + j-0.987243652344
            im_multiplicator=>-16175,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(183),
            data_im_in=>first_stage_im_out(183),
            product_re_out=>mul_re_out(183),
            product_im_out=>mul_im_out(183)
        );

    UMUL_184 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(184),
            data_im_in=>first_stage_im_out(184),
            product_re_out=>mul_re_out(184),
            product_im_out=>mul_im_out(184)
        );

    UMUL_185 : complex_multiplier
    generic map(
            re_multiplicator=>603, --- 0.0368041992188 + j-0.999267578125
            im_multiplicator=>-16372,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(185),
            data_im_in=>first_stage_im_out(185),
            product_re_out=>mul_re_out(185),
            product_im_out=>mul_im_out(185)
        );

    UMUL_186 : complex_multiplier
    generic map(
            re_multiplicator=>-402, --- -0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(186),
            data_im_in=>first_stage_im_out(186),
            product_re_out=>mul_re_out(186),
            product_im_out=>mul_im_out(186)
        );

    UMUL_187 : complex_multiplier
    generic map(
            re_multiplicator=>-1405, --- -0.0857543945312 + j-0.996276855469
            im_multiplicator=>-16323,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(187),
            data_im_in=>first_stage_im_out(187),
            product_re_out=>mul_re_out(187),
            product_im_out=>mul_im_out(187)
        );

    UMUL_188 : complex_multiplier
    generic map(
            re_multiplicator=>-2404, --- -0.146728515625 + j-0.989135742188
            im_multiplicator=>-16206,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(188),
            data_im_in=>first_stage_im_out(188),
            product_re_out=>mul_re_out(188),
            product_im_out=>mul_im_out(188)
        );

    UMUL_189 : complex_multiplier
    generic map(
            re_multiplicator=>-3393, --- -0.207092285156 + j-0.978271484375
            im_multiplicator=>-16028,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(189),
            data_im_in=>first_stage_im_out(189),
            product_re_out=>mul_re_out(189),
            product_im_out=>mul_im_out(189)
        );

    UMUL_190 : complex_multiplier
    generic map(
            re_multiplicator=>-4369, --- -0.266662597656 + j-0.963745117188
            im_multiplicator=>-15790,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(190),
            data_im_in=>first_stage_im_out(190),
            product_re_out=>mul_re_out(190),
            product_im_out=>mul_im_out(190)
        );

    UMUL_191 : complex_multiplier
    generic map(
            re_multiplicator=>-5329, --- -0.325256347656 + j-0.945556640625
            im_multiplicator=>-15492,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(191),
            data_im_in=>first_stage_im_out(191),
            product_re_out=>mul_re_out(191),
            product_im_out=>mul_im_out(191)
        );

    UDELAY_192_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(192),
            clk=>clk,
            Q=>shifter_re(192)
        );
    UDELAY_192_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(192),
            clk=>clk,
            Q=>shifter_im(192)
        );
    USHIFTER_192_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(192),
            data_out=>mul_re_out(192)
        );
    USHIFTER_192_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(192),
            data_out=>mul_im_out(192)
        );

    UMUL_193 : complex_multiplier
    generic map(
            re_multiplicator=>16339, --- 0.997253417969 + j-0.0735473632812
            im_multiplicator=>-1205,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(193),
            data_im_in=>first_stage_im_out(193),
            product_re_out=>mul_re_out(193),
            product_im_out=>mul_im_out(193)
        );

    UMUL_194 : complex_multiplier
    generic map(
            re_multiplicator=>16206, --- 0.989135742188 + j-0.146728515625
            im_multiplicator=>-2404,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(194),
            data_im_in=>first_stage_im_out(194),
            product_re_out=>mul_re_out(194),
            product_im_out=>mul_im_out(194)
        );

    UMUL_195 : complex_multiplier
    generic map(
            re_multiplicator=>15985, --- 0.975646972656 + j-0.219055175781
            im_multiplicator=>-3589,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(195),
            data_im_in=>first_stage_im_out(195),
            product_re_out=>mul_re_out(195),
            product_im_out=>mul_im_out(195)
        );

    UMUL_196 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(196),
            data_im_in=>first_stage_im_out(196),
            product_re_out=>mul_re_out(196),
            product_im_out=>mul_im_out(196)
        );

    UMUL_197 : complex_multiplier
    generic map(
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(197),
            data_im_in=>first_stage_im_out(197),
            product_re_out=>mul_re_out(197),
            product_im_out=>mul_im_out(197)
        );

    UMUL_198 : complex_multiplier
    generic map(
            re_multiplicator=>14810, --- 0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(198),
            data_im_in=>first_stage_im_out(198),
            product_re_out=>mul_re_out(198),
            product_im_out=>mul_im_out(198)
        );

    UMUL_199 : complex_multiplier
    generic map(
            re_multiplicator=>14255, --- 0.870056152344 + j-0.492858886719
            im_multiplicator=>-8075,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(199),
            data_im_in=>first_stage_im_out(199),
            product_re_out=>mul_re_out(199),
            product_im_out=>mul_im_out(199)
        );

    UMUL_200 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(200),
            data_im_in=>first_stage_im_out(200),
            product_re_out=>mul_re_out(200),
            product_im_out=>mul_im_out(200)
        );

    UMUL_201 : complex_multiplier
    generic map(
            re_multiplicator=>12916, --- 0.788330078125 + j-0.615173339844
            im_multiplicator=>-10079,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(201),
            data_im_in=>first_stage_im_out(201),
            product_re_out=>mul_re_out(201),
            product_im_out=>mul_im_out(201)
        );

    UMUL_202 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(202),
            data_im_in=>first_stage_im_out(202),
            product_re_out=>mul_re_out(202),
            product_im_out=>mul_im_out(202)
        );

    UMUL_203 : complex_multiplier
    generic map(
            re_multiplicator=>11297, --- 0.689514160156 + j-0.724243164062
            im_multiplicator=>-11866,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(203),
            data_im_in=>first_stage_im_out(203),
            product_re_out=>mul_re_out(203),
            product_im_out=>mul_im_out(203)
        );

    UMUL_204 : complex_multiplier
    generic map(
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(204),
            data_im_in=>first_stage_im_out(204),
            product_re_out=>mul_re_out(204),
            product_im_out=>mul_im_out(204)
        );

    UMUL_205 : complex_multiplier
    generic map(
            re_multiplicator=>9434, --- 0.575805664062 + j-0.817565917969
            im_multiplicator=>-13395,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(205),
            data_im_in=>first_stage_im_out(205),
            product_re_out=>mul_re_out(205),
            product_im_out=>mul_im_out(205)
        );

    UMUL_206 : complex_multiplier
    generic map(
            re_multiplicator=>8423, --- 0.514099121094 + j-0.857727050781
            im_multiplicator=>-14053,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(206),
            data_im_in=>first_stage_im_out(206),
            product_re_out=>mul_re_out(206),
            product_im_out=>mul_im_out(206)
        );

    UMUL_207 : complex_multiplier
    generic map(
            re_multiplicator=>7366, --- 0.449584960938 + j-0.893188476562
            im_multiplicator=>-14634,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(207),
            data_im_in=>first_stage_im_out(207),
            product_re_out=>mul_re_out(207),
            product_im_out=>mul_im_out(207)
        );

    UMUL_208 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(208),
            data_im_in=>first_stage_im_out(208),
            product_re_out=>mul_re_out(208),
            product_im_out=>mul_im_out(208)
        );

    UMUL_209 : complex_multiplier
    generic map(
            re_multiplicator=>5139, --- 0.313659667969 + j-0.949523925781
            im_multiplicator=>-15557,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(209),
            data_im_in=>first_stage_im_out(209),
            product_re_out=>mul_re_out(209),
            product_im_out=>mul_im_out(209)
        );

    UMUL_210 : complex_multiplier
    generic map(
            re_multiplicator=>3980, --- 0.242919921875 + j-0.969970703125
            im_multiplicator=>-15892,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(210),
            data_im_in=>first_stage_im_out(210),
            product_re_out=>mul_re_out(210),
            product_im_out=>mul_im_out(210)
        );

    UMUL_211 : complex_multiplier
    generic map(
            re_multiplicator=>2801, --- 0.170959472656 + j-0.985229492188
            im_multiplicator=>-16142,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(211),
            data_im_in=>first_stage_im_out(211),
            product_re_out=>mul_re_out(211),
            product_im_out=>mul_im_out(211)
        );

    UMUL_212 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(212),
            data_im_in=>first_stage_im_out(212),
            product_re_out=>mul_re_out(212),
            product_im_out=>mul_im_out(212)
        );

    UMUL_213 : complex_multiplier
    generic map(
            re_multiplicator=>402, --- 0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(213),
            data_im_in=>first_stage_im_out(213),
            product_re_out=>mul_re_out(213),
            product_im_out=>mul_im_out(213)
        );

    UMUL_214 : complex_multiplier
    generic map(
            re_multiplicator=>-803, --- -0.0490112304688 + j-0.998779296875
            im_multiplicator=>-16364,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(214),
            data_im_in=>first_stage_im_out(214),
            product_re_out=>mul_re_out(214),
            product_im_out=>mul_im_out(214)
        );

    UMUL_215 : complex_multiplier
    generic map(
            re_multiplicator=>-2005, --- -0.122375488281 + j-0.992431640625
            im_multiplicator=>-16260,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(215),
            data_im_in=>first_stage_im_out(215),
            product_re_out=>mul_re_out(215),
            product_im_out=>mul_im_out(215)
        );

    UMUL_216 : complex_multiplier
    generic map(
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(216),
            data_im_in=>first_stage_im_out(216),
            product_re_out=>mul_re_out(216),
            product_im_out=>mul_im_out(216)
        );

    UMUL_217 : complex_multiplier
    generic map(
            re_multiplicator=>-4369, --- -0.266662597656 + j-0.963745117188
            im_multiplicator=>-15790,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(217),
            data_im_in=>first_stage_im_out(217),
            product_re_out=>mul_re_out(217),
            product_im_out=>mul_im_out(217)
        );

    UMUL_218 : complex_multiplier
    generic map(
            re_multiplicator=>-5519, --- -0.336853027344 + j-0.941528320312
            im_multiplicator=>-15426,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(218),
            data_im_in=>first_stage_im_out(218),
            product_re_out=>mul_re_out(218),
            product_im_out=>mul_im_out(218)
        );

    UMUL_219 : complex_multiplier
    generic map(
            re_multiplicator=>-6639, --- -0.405212402344 + j-0.914184570312
            im_multiplicator=>-14978,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(219),
            data_im_in=>first_stage_im_out(219),
            product_re_out=>mul_re_out(219),
            product_im_out=>mul_im_out(219)
        );

    UMUL_220 : complex_multiplier
    generic map(
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(220),
            data_im_in=>first_stage_im_out(220),
            product_re_out=>mul_re_out(220),
            product_im_out=>mul_im_out(220)
        );

    UMUL_221 : complex_multiplier
    generic map(
            re_multiplicator=>-8765, --- -0.534973144531 + j-0.844848632812
            im_multiplicator=>-13842,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(221),
            data_im_in=>first_stage_im_out(221),
            product_re_out=>mul_re_out(221),
            product_im_out=>mul_im_out(221)
        );

    UMUL_222 : complex_multiplier
    generic map(
            re_multiplicator=>-9759, --- -0.595642089844 + j-0.803161621094
            im_multiplicator=>-13159,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(222),
            data_im_in=>first_stage_im_out(222),
            product_re_out=>mul_re_out(222),
            product_im_out=>mul_im_out(222)
        );

    UMUL_223 : complex_multiplier
    generic map(
            re_multiplicator=>-10701, --- -0.653137207031 + j-0.757202148438
            im_multiplicator=>-12406,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(223),
            data_im_in=>first_stage_im_out(223),
            product_re_out=>mul_re_out(223),
            product_im_out=>mul_im_out(223)
        );

    UDELAY_224_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(224),
            clk=>clk,
            Q=>shifter_re(224)
        );
    UDELAY_224_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(224),
            clk=>clk,
            Q=>shifter_im(224)
        );
    USHIFTER_224_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(224),
            data_out=>mul_re_out(224)
        );
    USHIFTER_224_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(224),
            data_out=>mul_im_out(224)
        );

    UMUL_225 : complex_multiplier
    generic map(
            re_multiplicator=>16323, --- 0.996276855469 + j-0.0857543945312
            im_multiplicator=>-1405,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(225),
            data_im_in=>first_stage_im_out(225),
            product_re_out=>mul_re_out(225),
            product_im_out=>mul_im_out(225)
        );

    UMUL_226 : complex_multiplier
    generic map(
            re_multiplicator=>16142, --- 0.985229492188 + j-0.170959472656
            im_multiplicator=>-2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(226),
            data_im_in=>first_stage_im_out(226),
            product_re_out=>mul_re_out(226),
            product_im_out=>mul_im_out(226)
        );

    UMUL_227 : complex_multiplier
    generic map(
            re_multiplicator=>15842, --- 0.966918945312 + j-0.254821777344
            im_multiplicator=>-4175,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(227),
            data_im_in=>first_stage_im_out(227),
            product_re_out=>mul_re_out(227),
            product_im_out=>mul_im_out(227)
        );

    UMUL_228 : complex_multiplier
    generic map(
            re_multiplicator=>15426, --- 0.941528320312 + j-0.336853027344
            im_multiplicator=>-5519,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(228),
            data_im_in=>first_stage_im_out(228),
            product_re_out=>mul_re_out(228),
            product_im_out=>mul_im_out(228)
        );

    UMUL_229 : complex_multiplier
    generic map(
            re_multiplicator=>14895, --- 0.909118652344 + j-0.416381835938
            im_multiplicator=>-6822,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(229),
            data_im_in=>first_stage_im_out(229),
            product_re_out=>mul_re_out(229),
            product_im_out=>mul_im_out(229)
        );

    UMUL_230 : complex_multiplier
    generic map(
            re_multiplicator=>14255, --- 0.870056152344 + j-0.492858886719
            im_multiplicator=>-8075,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(230),
            data_im_in=>first_stage_im_out(230),
            product_re_out=>mul_re_out(230),
            product_im_out=>mul_im_out(230)
        );

    UMUL_231 : complex_multiplier
    generic map(
            re_multiplicator=>13510, --- 0.824584960938 + j-0.565673828125
            im_multiplicator=>-9268,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(231),
            data_im_in=>first_stage_im_out(231),
            product_re_out=>mul_re_out(231),
            product_im_out=>mul_im_out(231)
        );

    UMUL_232 : complex_multiplier
    generic map(
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(232),
            data_im_in=>first_stage_im_out(232),
            product_re_out=>mul_re_out(232),
            product_im_out=>mul_im_out(232)
        );

    UMUL_233 : complex_multiplier
    generic map(
            re_multiplicator=>11726, --- 0.715698242188 + j-0.698364257812
            im_multiplicator=>-11442,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(233),
            data_im_in=>first_stage_im_out(233),
            product_re_out=>mul_re_out(233),
            product_im_out=>mul_im_out(233)
        );

    UMUL_234 : complex_multiplier
    generic map(
            re_multiplicator=>10701, --- 0.653137207031 + j-0.757202148438
            im_multiplicator=>-12406,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(234),
            data_im_in=>first_stage_im_out(234),
            product_re_out=>mul_re_out(234),
            product_im_out=>mul_im_out(234)
        );

    UMUL_235 : complex_multiplier
    generic map(
            re_multiplicator=>9597, --- 0.585754394531 + j-0.810424804688
            im_multiplicator=>-13278,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(235),
            data_im_in=>first_stage_im_out(235),
            product_re_out=>mul_re_out(235),
            product_im_out=>mul_im_out(235)
        );

    UMUL_236 : complex_multiplier
    generic map(
            re_multiplicator=>8423, --- 0.514099121094 + j-0.857727050781
            im_multiplicator=>-14053,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(236),
            data_im_in=>first_stage_im_out(236),
            product_re_out=>mul_re_out(236),
            product_im_out=>mul_im_out(236)
        );

    UMUL_237 : complex_multiplier
    generic map(
            re_multiplicator=>7186, --- 0.438598632812 + j-0.898620605469
            im_multiplicator=>-14723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(237),
            data_im_in=>first_stage_im_out(237),
            product_re_out=>mul_re_out(237),
            product_im_out=>mul_im_out(237)
        );

    UMUL_238 : complex_multiplier
    generic map(
            re_multiplicator=>5896, --- 0.35986328125 + j-0.932983398438
            im_multiplicator=>-15286,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(238),
            data_im_in=>first_stage_im_out(238),
            product_re_out=>mul_re_out(238),
            product_im_out=>mul_im_out(238)
        );

    UMUL_239 : complex_multiplier
    generic map(
            re_multiplicator=>4563, --- 0.278503417969 + j-0.960388183594
            im_multiplicator=>-15735,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(239),
            data_im_in=>first_stage_im_out(239),
            product_re_out=>mul_re_out(239),
            product_im_out=>mul_im_out(239)
        );

    UMUL_240 : complex_multiplier
    generic map(
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(240),
            data_im_in=>first_stage_im_out(240),
            product_re_out=>mul_re_out(240),
            product_im_out=>mul_im_out(240)
        );

    UMUL_241 : complex_multiplier
    generic map(
            re_multiplicator=>1805, --- 0.110168457031 + j-0.993896484375
            im_multiplicator=>-16284,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(241),
            data_im_in=>first_stage_im_out(241),
            product_re_out=>mul_re_out(241),
            product_im_out=>mul_im_out(241)
        );

    UMUL_242 : complex_multiplier
    generic map(
            re_multiplicator=>402, --- 0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(242),
            data_im_in=>first_stage_im_out(242),
            product_re_out=>mul_re_out(242),
            product_im_out=>mul_im_out(242)
        );

    UMUL_243 : complex_multiplier
    generic map(
            re_multiplicator=>-1004, --- -0.061279296875 + j-0.998107910156
            im_multiplicator=>-16353,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(243),
            data_im_in=>first_stage_im_out(243),
            product_re_out=>mul_re_out(243),
            product_im_out=>mul_im_out(243)
        );

    UMUL_244 : complex_multiplier
    generic map(
            re_multiplicator=>-2404, --- -0.146728515625 + j-0.989135742188
            im_multiplicator=>-16206,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(244),
            data_im_in=>first_stage_im_out(244),
            product_re_out=>mul_re_out(244),
            product_im_out=>mul_im_out(244)
        );

    UMUL_245 : complex_multiplier
    generic map(
            re_multiplicator=>-3785, --- -0.231018066406 + j-0.972900390625
            im_multiplicator=>-15940,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(245),
            data_im_in=>first_stage_im_out(245),
            product_re_out=>mul_re_out(245),
            product_im_out=>mul_im_out(245)
        );

    UMUL_246 : complex_multiplier
    generic map(
            re_multiplicator=>-5139, --- -0.313659667969 + j-0.949523925781
            im_multiplicator=>-15557,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(246),
            data_im_in=>first_stage_im_out(246),
            product_re_out=>mul_re_out(246),
            product_im_out=>mul_im_out(246)
        );

    UMUL_247 : complex_multiplier
    generic map(
            re_multiplicator=>-6455, --- -0.393981933594 + j-0.919067382812
            im_multiplicator=>-15058,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(247),
            data_im_in=>first_stage_im_out(247),
            product_re_out=>mul_re_out(247),
            product_im_out=>mul_im_out(247)
        );

    UMUL_248 : complex_multiplier
    generic map(
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(248),
            data_im_in=>first_stage_im_out(248),
            product_re_out=>mul_re_out(248),
            product_im_out=>mul_im_out(248)
        );

    UMUL_249 : complex_multiplier
    generic map(
            re_multiplicator=>-8934, --- -0.545288085938 + j-0.838195800781
            im_multiplicator=>-13733,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(249),
            data_im_in=>first_stage_im_out(249),
            product_re_out=>mul_re_out(249),
            product_im_out=>mul_im_out(249)
        );

    UMUL_250 : complex_multiplier
    generic map(
            re_multiplicator=>-10079, --- -0.615173339844 + j-0.788330078125
            im_multiplicator=>-12916,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(250),
            data_im_in=>first_stage_im_out(250),
            product_re_out=>mul_re_out(250),
            product_im_out=>mul_im_out(250)
        );

    UMUL_251 : complex_multiplier
    generic map(
            re_multiplicator=>-11150, --- -0.680541992188 + j-0.732604980469
            im_multiplicator=>-12003,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(251),
            data_im_in=>first_stage_im_out(251),
            product_re_out=>mul_re_out(251),
            product_im_out=>mul_im_out(251)
        );

    UMUL_252 : complex_multiplier
    generic map(
            re_multiplicator=>-12139, --- -0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(252),
            data_im_in=>first_stage_im_out(252),
            product_re_out=>mul_re_out(252),
            product_im_out=>mul_im_out(252)
        );

    UMUL_253 : complex_multiplier
    generic map(
            re_multiplicator=>-13038, --- -0.795776367188 + j-0.60546875
            im_multiplicator=>-9920,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(253),
            data_im_in=>first_stage_im_out(253),
            product_re_out=>mul_re_out(253),
            product_im_out=>mul_im_out(253)
        );

    UMUL_254 : complex_multiplier
    generic map(
            re_multiplicator=>-13842, --- -0.844848632812 + j-0.534973144531
            im_multiplicator=>-8765,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(254),
            data_im_in=>first_stage_im_out(254),
            product_re_out=>mul_re_out(254),
            product_im_out=>mul_im_out(254)
        );

    UMUL_255 : complex_multiplier
    generic map(
            re_multiplicator=>-14543, --- -0.887634277344 + j-0.460510253906
            im_multiplicator=>-7545,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(255),
            data_im_in=>first_stage_im_out(255),
            product_re_out=>mul_re_out(255),
            product_im_out=>mul_im_out(255)
        );

    UDELAY_256_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(256),
            clk=>clk,
            Q=>shifter_re(256)
        );
    UDELAY_256_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(256),
            clk=>clk,
            Q=>shifter_im(256)
        );
    USHIFTER_256_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(256),
            data_out=>mul_re_out(256)
        );
    USHIFTER_256_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(256),
            data_out=>mul_im_out(256)
        );

    UMUL_257 : complex_multiplier
    generic map(
            re_multiplicator=>16305, --- 0.995178222656 + j-0.0979614257812
            im_multiplicator=>-1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(257),
            data_im_in=>first_stage_im_out(257),
            product_re_out=>mul_re_out(257),
            product_im_out=>mul_im_out(257)
        );

    UMUL_258 : complex_multiplier
    generic map(
            re_multiplicator=>16069, --- 0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(258),
            data_im_in=>first_stage_im_out(258),
            product_re_out=>mul_re_out(258),
            product_im_out=>mul_im_out(258)
        );

    UMUL_259 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(259),
            data_im_in=>first_stage_im_out(259),
            product_re_out=>mul_re_out(259),
            product_im_out=>mul_im_out(259)
        );

    UMUL_260 : complex_multiplier
    generic map(
            re_multiplicator=>15136, --- 0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(260),
            data_im_in=>first_stage_im_out(260),
            product_re_out=>mul_re_out(260),
            product_im_out=>mul_im_out(260)
        );

    UMUL_261 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(261),
            data_im_in=>first_stage_im_out(261),
            product_re_out=>mul_re_out(261),
            product_im_out=>mul_im_out(261)
        );

    UMUL_262 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(262),
            data_im_in=>first_stage_im_out(262),
            product_re_out=>mul_re_out(262),
            product_im_out=>mul_im_out(262)
        );

    UMUL_263 : complex_multiplier
    generic map(
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(263),
            data_im_in=>first_stage_im_out(263),
            product_re_out=>mul_re_out(263),
            product_im_out=>mul_im_out(263)
        );

    UMUL_264 : complex_multiplier
    generic map(
            re_multiplicator=>11585, --- 0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(264),
            data_im_in=>first_stage_im_out(264),
            product_re_out=>mul_re_out(264),
            product_im_out=>mul_im_out(264)
        );

    UMUL_265 : complex_multiplier
    generic map(
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(265),
            data_im_in=>first_stage_im_out(265),
            product_re_out=>mul_re_out(265),
            product_im_out=>mul_im_out(265)
        );

    UMUL_266 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(266),
            data_im_in=>first_stage_im_out(266),
            product_re_out=>mul_re_out(266),
            product_im_out=>mul_im_out(266)
        );

    UMUL_267 : complex_multiplier
    generic map(
            re_multiplicator=>7723, --- 0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(267),
            data_im_in=>first_stage_im_out(267),
            product_re_out=>mul_re_out(267),
            product_im_out=>mul_im_out(267)
        );

    UMUL_268 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(268),
            data_im_in=>first_stage_im_out(268),
            product_re_out=>mul_re_out(268),
            product_im_out=>mul_im_out(268)
        );

    UMUL_269 : complex_multiplier
    generic map(
            re_multiplicator=>4756, --- 0.290283203125 + j-0.956909179688
            im_multiplicator=>-15678,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(269),
            data_im_in=>first_stage_im_out(269),
            product_re_out=>mul_re_out(269),
            product_im_out=>mul_im_out(269)
        );

    UMUL_270 : complex_multiplier
    generic map(
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(270),
            data_im_in=>first_stage_im_out(270),
            product_re_out=>mul_re_out(270),
            product_im_out=>mul_im_out(270)
        );

    UMUL_271 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(271),
            data_im_in=>first_stage_im_out(271),
            product_re_out=>mul_re_out(271),
            product_im_out=>mul_im_out(271)
        );

    not_first_stage_re_out(272) <= not first_stage_re_out(272);
    C_BUFF_272 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(272), 
        clk      => clk, 
        preload  => ctrl_delay((ctrl_start+3) mod 16), 
        Q        => c_buff(272)
    );
    ADDER_272 : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff(272), 
        data2_in  => not_first_stage_re_out(272), 
        sum_out   => opp_first_stage_re_out(272), 
        c_out     => c(272)
    );
    UDELAY_272_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(272),
            clk=>clk,
            Q=>shifter_re(272)
        );
    UDELAY_272_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>opp_first_stage_re_out(272),
            clk=>clk,
            Q=>shifter_im(272)
        );
    USHIFTER_272_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(272),
            data_out=>mul_re_out(272)
        );
    USHIFTER_272_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(272),
            data_out=>mul_im_out(272)
        );

    UMUL_273 : complex_multiplier
    generic map(
            re_multiplicator=>-1605, --- -0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(273),
            data_im_in=>first_stage_im_out(273),
            product_re_out=>mul_re_out(273),
            product_im_out=>mul_im_out(273)
        );

    UMUL_274 : complex_multiplier
    generic map(
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(274),
            data_im_in=>first_stage_im_out(274),
            product_re_out=>mul_re_out(274),
            product_im_out=>mul_im_out(274)
        );

    UMUL_275 : complex_multiplier
    generic map(
            re_multiplicator=>-4756, --- -0.290283203125 + j-0.956909179688
            im_multiplicator=>-15678,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(275),
            data_im_in=>first_stage_im_out(275),
            product_re_out=>mul_re_out(275),
            product_im_out=>mul_im_out(275)
        );

    UMUL_276 : complex_multiplier
    generic map(
            re_multiplicator=>-6269, --- -0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(276),
            data_im_in=>first_stage_im_out(276),
            product_re_out=>mul_re_out(276),
            product_im_out=>mul_im_out(276)
        );

    UMUL_277 : complex_multiplier
    generic map(
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(277),
            data_im_in=>first_stage_im_out(277),
            product_re_out=>mul_re_out(277),
            product_im_out=>mul_im_out(277)
        );

    UMUL_278 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(278),
            data_im_in=>first_stage_im_out(278),
            product_re_out=>mul_re_out(278),
            product_im_out=>mul_im_out(278)
        );

    UMUL_279 : complex_multiplier
    generic map(
            re_multiplicator=>-10393, --- -0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(279),
            data_im_in=>first_stage_im_out(279),
            product_re_out=>mul_re_out(279),
            product_im_out=>mul_im_out(279)
        );

    UMUL_280 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(280),
            data_im_in=>first_stage_im_out(280),
            product_re_out=>mul_re_out(280),
            product_im_out=>mul_im_out(280)
        );

    UMUL_281 : complex_multiplier
    generic map(
            re_multiplicator=>-12665, --- -0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(281),
            data_im_in=>first_stage_im_out(281),
            product_re_out=>mul_re_out(281),
            product_im_out=>mul_im_out(281)
        );

    UMUL_282 : complex_multiplier
    generic map(
            re_multiplicator=>-13622, --- -0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(282),
            data_im_in=>first_stage_im_out(282),
            product_re_out=>mul_re_out(282),
            product_im_out=>mul_im_out(282)
        );

    UMUL_283 : complex_multiplier
    generic map(
            re_multiplicator=>-14449, --- -0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(283),
            data_im_in=>first_stage_im_out(283),
            product_re_out=>mul_re_out(283),
            product_im_out=>mul_im_out(283)
        );

    UMUL_284 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(284),
            data_im_in=>first_stage_im_out(284),
            product_re_out=>mul_re_out(284),
            product_im_out=>mul_im_out(284)
        );

    UMUL_285 : complex_multiplier
    generic map(
            re_multiplicator=>-15678, --- -0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(285),
            data_im_in=>first_stage_im_out(285),
            product_re_out=>mul_re_out(285),
            product_im_out=>mul_im_out(285)
        );

    UMUL_286 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(286),
            data_im_in=>first_stage_im_out(286),
            product_re_out=>mul_re_out(286),
            product_im_out=>mul_im_out(286)
        );

    UMUL_287 : complex_multiplier
    generic map(
            re_multiplicator=>-16305, --- -0.995178222656 + j-0.0979614257812
            im_multiplicator=>-1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(287),
            data_im_in=>first_stage_im_out(287),
            product_re_out=>mul_re_out(287),
            product_im_out=>mul_im_out(287)
        );

    UDELAY_288_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(288),
            clk=>clk,
            Q=>shifter_re(288)
        );
    UDELAY_288_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(288),
            clk=>clk,
            Q=>shifter_im(288)
        );
    USHIFTER_288_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(288),
            data_out=>mul_re_out(288)
        );
    USHIFTER_288_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(288),
            data_out=>mul_im_out(288)
        );

    UMUL_289 : complex_multiplier
    generic map(
            re_multiplicator=>16284, --- 0.993896484375 + j-0.110168457031
            im_multiplicator=>-1805,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(289),
            data_im_in=>first_stage_im_out(289),
            product_re_out=>mul_re_out(289),
            product_im_out=>mul_im_out(289)
        );

    UMUL_290 : complex_multiplier
    generic map(
            re_multiplicator=>15985, --- 0.975646972656 + j-0.219055175781
            im_multiplicator=>-3589,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(290),
            data_im_in=>first_stage_im_out(290),
            product_re_out=>mul_re_out(290),
            product_im_out=>mul_im_out(290)
        );

    UMUL_291 : complex_multiplier
    generic map(
            re_multiplicator=>15492, --- 0.945556640625 + j-0.325256347656
            im_multiplicator=>-5329,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(291),
            data_im_in=>first_stage_im_out(291),
            product_re_out=>mul_re_out(291),
            product_im_out=>mul_im_out(291)
        );

    UMUL_292 : complex_multiplier
    generic map(
            re_multiplicator=>14810, --- 0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(292),
            data_im_in=>first_stage_im_out(292),
            product_re_out=>mul_re_out(292),
            product_im_out=>mul_im_out(292)
        );

    UMUL_293 : complex_multiplier
    generic map(
            re_multiplicator=>13948, --- 0.851318359375 + j-0.524536132812
            im_multiplicator=>-8594,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(293),
            data_im_in=>first_stage_im_out(293),
            product_re_out=>mul_re_out(293),
            product_im_out=>mul_im_out(293)
        );

    UMUL_294 : complex_multiplier
    generic map(
            re_multiplicator=>12916, --- 0.788330078125 + j-0.615173339844
            im_multiplicator=>-10079,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(294),
            data_im_in=>first_stage_im_out(294),
            product_re_out=>mul_re_out(294),
            product_im_out=>mul_im_out(294)
        );

    UMUL_295 : complex_multiplier
    generic map(
            re_multiplicator=>11726, --- 0.715698242188 + j-0.698364257812
            im_multiplicator=>-11442,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(295),
            data_im_in=>first_stage_im_out(295),
            product_re_out=>mul_re_out(295),
            product_im_out=>mul_im_out(295)
        );

    UMUL_296 : complex_multiplier
    generic map(
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(296),
            data_im_in=>first_stage_im_out(296),
            product_re_out=>mul_re_out(296),
            product_im_out=>mul_im_out(296)
        );

    UMUL_297 : complex_multiplier
    generic map(
            re_multiplicator=>8934, --- 0.545288085938 + j-0.838195800781
            im_multiplicator=>-13733,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(297),
            data_im_in=>first_stage_im_out(297),
            product_re_out=>mul_re_out(297),
            product_im_out=>mul_im_out(297)
        );

    UMUL_298 : complex_multiplier
    generic map(
            re_multiplicator=>7366, --- 0.449584960938 + j-0.893188476562
            im_multiplicator=>-14634,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(298),
            data_im_in=>first_stage_im_out(298),
            product_re_out=>mul_re_out(298),
            product_im_out=>mul_im_out(298)
        );

    UMUL_299 : complex_multiplier
    generic map(
            re_multiplicator=>5708, --- 0.348388671875 + j-0.937316894531
            im_multiplicator=>-15357,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(299),
            data_im_in=>first_stage_im_out(299),
            product_re_out=>mul_re_out(299),
            product_im_out=>mul_im_out(299)
        );

    UMUL_300 : complex_multiplier
    generic map(
            re_multiplicator=>3980, --- 0.242919921875 + j-0.969970703125
            im_multiplicator=>-15892,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(300),
            data_im_in=>first_stage_im_out(300),
            product_re_out=>mul_re_out(300),
            product_im_out=>mul_im_out(300)
        );

    UMUL_301 : complex_multiplier
    generic map(
            re_multiplicator=>2204, --- 0.134521484375 + j-0.990844726562
            im_multiplicator=>-16234,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(301),
            data_im_in=>first_stage_im_out(301),
            product_re_out=>mul_re_out(301),
            product_im_out=>mul_im_out(301)
        );

    UMUL_302 : complex_multiplier
    generic map(
            re_multiplicator=>402, --- 0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(302),
            data_im_in=>first_stage_im_out(302),
            product_re_out=>mul_re_out(302),
            product_im_out=>mul_im_out(302)
        );

    UMUL_303 : complex_multiplier
    generic map(
            re_multiplicator=>-1405, --- -0.0857543945312 + j-0.996276855469
            im_multiplicator=>-16323,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(303),
            data_im_in=>first_stage_im_out(303),
            product_re_out=>mul_re_out(303),
            product_im_out=>mul_im_out(303)
        );

    UMUL_304 : complex_multiplier
    generic map(
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(304),
            data_im_in=>first_stage_im_out(304),
            product_re_out=>mul_re_out(304),
            product_im_out=>mul_im_out(304)
        );

    UMUL_305 : complex_multiplier
    generic map(
            re_multiplicator=>-4948, --- -0.302001953125 + j-0.953247070312
            im_multiplicator=>-15618,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(305),
            data_im_in=>first_stage_im_out(305),
            product_re_out=>mul_re_out(305),
            product_im_out=>mul_im_out(305)
        );

    UMUL_306 : complex_multiplier
    generic map(
            re_multiplicator=>-6639, --- -0.405212402344 + j-0.914184570312
            im_multiplicator=>-14978,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(306),
            data_im_in=>first_stage_im_out(306),
            product_re_out=>mul_re_out(306),
            product_im_out=>mul_im_out(306)
        );

    UMUL_307 : complex_multiplier
    generic map(
            re_multiplicator=>-8249, --- -0.503479003906 + j-0.863952636719
            im_multiplicator=>-14155,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(307),
            data_im_in=>first_stage_im_out(307),
            product_re_out=>mul_re_out(307),
            product_im_out=>mul_im_out(307)
        );

    UMUL_308 : complex_multiplier
    generic map(
            re_multiplicator=>-9759, --- -0.595642089844 + j-0.803161621094
            im_multiplicator=>-13159,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(308),
            data_im_in=>first_stage_im_out(308),
            product_re_out=>mul_re_out(308),
            product_im_out=>mul_im_out(308)
        );

    UMUL_309 : complex_multiplier
    generic map(
            re_multiplicator=>-11150, --- -0.680541992188 + j-0.732604980469
            im_multiplicator=>-12003,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(309),
            data_im_in=>first_stage_im_out(309),
            product_re_out=>mul_re_out(309),
            product_im_out=>mul_im_out(309)
        );

    UMUL_310 : complex_multiplier
    generic map(
            re_multiplicator=>-12406, --- -0.757202148438 + j-0.653137207031
            im_multiplicator=>-10701,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(310),
            data_im_in=>first_stage_im_out(310),
            product_re_out=>mul_re_out(310),
            product_im_out=>mul_im_out(310)
        );

    UMUL_311 : complex_multiplier
    generic map(
            re_multiplicator=>-13510, --- -0.824584960938 + j-0.565673828125
            im_multiplicator=>-9268,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(311),
            data_im_in=>first_stage_im_out(311),
            product_re_out=>mul_re_out(311),
            product_im_out=>mul_im_out(311)
        );

    UMUL_312 : complex_multiplier
    generic map(
            re_multiplicator=>-14449, --- -0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(312),
            data_im_in=>first_stage_im_out(312),
            product_re_out=>mul_re_out(312),
            product_im_out=>mul_im_out(312)
        );

    UMUL_313 : complex_multiplier
    generic map(
            re_multiplicator=>-15212, --- -0.928466796875 + j-0.371276855469
            im_multiplicator=>-6083,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(313),
            data_im_in=>first_stage_im_out(313),
            product_re_out=>mul_re_out(313),
            product_im_out=>mul_im_out(313)
        );

    UMUL_314 : complex_multiplier
    generic map(
            re_multiplicator=>-15790, --- -0.963745117188 + j-0.266662597656
            im_multiplicator=>-4369,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(314),
            data_im_in=>first_stage_im_out(314),
            product_re_out=>mul_re_out(314),
            product_im_out=>mul_im_out(314)
        );

    UMUL_315 : complex_multiplier
    generic map(
            re_multiplicator=>-16175, --- -0.987243652344 + j-0.158813476562
            im_multiplicator=>-2602,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(315),
            data_im_in=>first_stage_im_out(315),
            product_re_out=>mul_re_out(315),
            product_im_out=>mul_im_out(315)
        );

    UMUL_316 : complex_multiplier
    generic map(
            re_multiplicator=>-16364, --- -0.998779296875 + j-0.0490112304688
            im_multiplicator=>-803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(316),
            data_im_in=>first_stage_im_out(316),
            product_re_out=>mul_re_out(316),
            product_im_out=>mul_im_out(316)
        );

    UMUL_317 : complex_multiplier
    generic map(
            re_multiplicator=>-16353, --- -0.998107910156 + j0.061279296875
            im_multiplicator=>1004,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(317),
            data_im_in=>first_stage_im_out(317),
            product_re_out=>mul_re_out(317),
            product_im_out=>mul_im_out(317)
        );

    UMUL_318 : complex_multiplier
    generic map(
            re_multiplicator=>-16142, --- -0.985229492188 + j0.170959472656
            im_multiplicator=>2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(318),
            data_im_in=>first_stage_im_out(318),
            product_re_out=>mul_re_out(318),
            product_im_out=>mul_im_out(318)
        );

    UMUL_319 : complex_multiplier
    generic map(
            re_multiplicator=>-15735, --- -0.960388183594 + j0.278503417969
            im_multiplicator=>4563,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(319),
            data_im_in=>first_stage_im_out(319),
            product_re_out=>mul_re_out(319),
            product_im_out=>mul_im_out(319)
        );

    UDELAY_320_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(320),
            clk=>clk,
            Q=>shifter_re(320)
        );
    UDELAY_320_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(320),
            clk=>clk,
            Q=>shifter_im(320)
        );
    USHIFTER_320_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(320),
            data_out=>mul_re_out(320)
        );
    USHIFTER_320_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(320),
            data_out=>mul_im_out(320)
        );

    UMUL_321 : complex_multiplier
    generic map(
            re_multiplicator=>16260, --- 0.992431640625 + j-0.122375488281
            im_multiplicator=>-2005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(321),
            data_im_in=>first_stage_im_out(321),
            product_re_out=>mul_re_out(321),
            product_im_out=>mul_im_out(321)
        );

    UMUL_322 : complex_multiplier
    generic map(
            re_multiplicator=>15892, --- 0.969970703125 + j-0.242919921875
            im_multiplicator=>-3980,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(322),
            data_im_in=>first_stage_im_out(322),
            product_re_out=>mul_re_out(322),
            product_im_out=>mul_im_out(322)
        );

    UMUL_323 : complex_multiplier
    generic map(
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(323),
            data_im_in=>first_stage_im_out(323),
            product_re_out=>mul_re_out(323),
            product_im_out=>mul_im_out(323)
        );

    UMUL_324 : complex_multiplier
    generic map(
            re_multiplicator=>14449, --- 0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(324),
            data_im_in=>first_stage_im_out(324),
            product_re_out=>mul_re_out(324),
            product_im_out=>mul_im_out(324)
        );

    UMUL_325 : complex_multiplier
    generic map(
            re_multiplicator=>13395, --- 0.817565917969 + j-0.575805664062
            im_multiplicator=>-9434,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(325),
            data_im_in=>first_stage_im_out(325),
            product_re_out=>mul_re_out(325),
            product_im_out=>mul_im_out(325)
        );

    UMUL_326 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(326),
            data_im_in=>first_stage_im_out(326),
            product_re_out=>mul_re_out(326),
            product_im_out=>mul_im_out(326)
        );

    UMUL_327 : complex_multiplier
    generic map(
            re_multiplicator=>10701, --- 0.653137207031 + j-0.757202148438
            im_multiplicator=>-12406,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(327),
            data_im_in=>first_stage_im_out(327),
            product_re_out=>mul_re_out(327),
            product_im_out=>mul_im_out(327)
        );

    UMUL_328 : complex_multiplier
    generic map(
            re_multiplicator=>9102, --- 0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(328),
            data_im_in=>first_stage_im_out(328),
            product_re_out=>mul_re_out(328),
            product_im_out=>mul_im_out(328)
        );

    UMUL_329 : complex_multiplier
    generic map(
            re_multiplicator=>7366, --- 0.449584960938 + j-0.893188476562
            im_multiplicator=>-14634,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(329),
            data_im_in=>first_stage_im_out(329),
            product_re_out=>mul_re_out(329),
            product_im_out=>mul_im_out(329)
        );

    UMUL_330 : complex_multiplier
    generic map(
            re_multiplicator=>5519, --- 0.336853027344 + j-0.941528320312
            im_multiplicator=>-15426,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(330),
            data_im_in=>first_stage_im_out(330),
            product_re_out=>mul_re_out(330),
            product_im_out=>mul_im_out(330)
        );

    UMUL_331 : complex_multiplier
    generic map(
            re_multiplicator=>3589, --- 0.219055175781 + j-0.975646972656
            im_multiplicator=>-15985,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(331),
            data_im_in=>first_stage_im_out(331),
            product_re_out=>mul_re_out(331),
            product_im_out=>mul_im_out(331)
        );

    UMUL_332 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(332),
            data_im_in=>first_stage_im_out(332),
            product_re_out=>mul_re_out(332),
            product_im_out=>mul_im_out(332)
        );

    UMUL_333 : complex_multiplier
    generic map(
            re_multiplicator=>-402, --- -0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(333),
            data_im_in=>first_stage_im_out(333),
            product_re_out=>mul_re_out(333),
            product_im_out=>mul_im_out(333)
        );

    UMUL_334 : complex_multiplier
    generic map(
            re_multiplicator=>-2404, --- -0.146728515625 + j-0.989135742188
            im_multiplicator=>-16206,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(334),
            data_im_in=>first_stage_im_out(334),
            product_re_out=>mul_re_out(334),
            product_im_out=>mul_im_out(334)
        );

    UMUL_335 : complex_multiplier
    generic map(
            re_multiplicator=>-4369, --- -0.266662597656 + j-0.963745117188
            im_multiplicator=>-15790,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(335),
            data_im_in=>first_stage_im_out(335),
            product_re_out=>mul_re_out(335),
            product_im_out=>mul_im_out(335)
        );

    UMUL_336 : complex_multiplier
    generic map(
            re_multiplicator=>-6269, --- -0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(336),
            data_im_in=>first_stage_im_out(336),
            product_re_out=>mul_re_out(336),
            product_im_out=>mul_im_out(336)
        );

    UMUL_337 : complex_multiplier
    generic map(
            re_multiplicator=>-8075, --- -0.492858886719 + j-0.870056152344
            im_multiplicator=>-14255,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(337),
            data_im_in=>first_stage_im_out(337),
            product_re_out=>mul_re_out(337),
            product_im_out=>mul_im_out(337)
        );

    UMUL_338 : complex_multiplier
    generic map(
            re_multiplicator=>-9759, --- -0.595642089844 + j-0.803161621094
            im_multiplicator=>-13159,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(338),
            data_im_in=>first_stage_im_out(338),
            product_re_out=>mul_re_out(338),
            product_im_out=>mul_im_out(338)
        );

    UMUL_339 : complex_multiplier
    generic map(
            re_multiplicator=>-11297, --- -0.689514160156 + j-0.724243164062
            im_multiplicator=>-11866,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(339),
            data_im_in=>first_stage_im_out(339),
            product_re_out=>mul_re_out(339),
            product_im_out=>mul_im_out(339)
        );

    UMUL_340 : complex_multiplier
    generic map(
            re_multiplicator=>-12665, --- -0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(340),
            data_im_in=>first_stage_im_out(340),
            product_re_out=>mul_re_out(340),
            product_im_out=>mul_im_out(340)
        );

    UMUL_341 : complex_multiplier
    generic map(
            re_multiplicator=>-13842, --- -0.844848632812 + j-0.534973144531
            im_multiplicator=>-8765,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(341),
            data_im_in=>first_stage_im_out(341),
            product_re_out=>mul_re_out(341),
            product_im_out=>mul_im_out(341)
        );

    UMUL_342 : complex_multiplier
    generic map(
            re_multiplicator=>-14810, --- -0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(342),
            data_im_in=>first_stage_im_out(342),
            product_re_out=>mul_re_out(342),
            product_im_out=>mul_im_out(342)
        );

    UMUL_343 : complex_multiplier
    generic map(
            re_multiplicator=>-15557, --- -0.949523925781 + j-0.313659667969
            im_multiplicator=>-5139,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(343),
            data_im_in=>first_stage_im_out(343),
            product_re_out=>mul_re_out(343),
            product_im_out=>mul_im_out(343)
        );

    UMUL_344 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(344),
            data_im_in=>first_stage_im_out(344),
            product_re_out=>mul_re_out(344),
            product_im_out=>mul_im_out(344)
        );

    UMUL_345 : complex_multiplier
    generic map(
            re_multiplicator=>-16339, --- -0.997253417969 + j-0.0735473632812
            im_multiplicator=>-1205,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(345),
            data_im_in=>first_stage_im_out(345),
            product_re_out=>mul_re_out(345),
            product_im_out=>mul_im_out(345)
        );

    UMUL_346 : complex_multiplier
    generic map(
            re_multiplicator=>-16364, --- -0.998779296875 + j0.0490112304688
            im_multiplicator=>803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(346),
            data_im_in=>first_stage_im_out(346),
            product_re_out=>mul_re_out(346),
            product_im_out=>mul_im_out(346)
        );

    UMUL_347 : complex_multiplier
    generic map(
            re_multiplicator=>-16142, --- -0.985229492188 + j0.170959472656
            im_multiplicator=>2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(347),
            data_im_in=>first_stage_im_out(347),
            product_re_out=>mul_re_out(347),
            product_im_out=>mul_im_out(347)
        );

    UMUL_348 : complex_multiplier
    generic map(
            re_multiplicator=>-15678, --- -0.956909179688 + j0.290283203125
            im_multiplicator=>4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(348),
            data_im_in=>first_stage_im_out(348),
            product_re_out=>mul_re_out(348),
            product_im_out=>mul_im_out(348)
        );

    UMUL_349 : complex_multiplier
    generic map(
            re_multiplicator=>-14978, --- -0.914184570312 + j0.405212402344
            im_multiplicator=>6639,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(349),
            data_im_in=>first_stage_im_out(349),
            product_re_out=>mul_re_out(349),
            product_im_out=>mul_im_out(349)
        );

    UMUL_350 : complex_multiplier
    generic map(
            re_multiplicator=>-14053, --- -0.857727050781 + j0.514099121094
            im_multiplicator=>8423,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(350),
            data_im_in=>first_stage_im_out(350),
            product_re_out=>mul_re_out(350),
            product_im_out=>mul_im_out(350)
        );

    UMUL_351 : complex_multiplier
    generic map(
            re_multiplicator=>-12916, --- -0.788330078125 + j0.615173339844
            im_multiplicator=>10079,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(351),
            data_im_in=>first_stage_im_out(351),
            product_re_out=>mul_re_out(351),
            product_im_out=>mul_im_out(351)
        );

    UDELAY_352_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(352),
            clk=>clk,
            Q=>shifter_re(352)
        );
    UDELAY_352_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(352),
            clk=>clk,
            Q=>shifter_im(352)
        );
    USHIFTER_352_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(352),
            data_out=>mul_re_out(352)
        );
    USHIFTER_352_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(352),
            data_out=>mul_im_out(352)
        );

    UMUL_353 : complex_multiplier
    generic map(
            re_multiplicator=>16234, --- 0.990844726562 + j-0.134521484375
            im_multiplicator=>-2204,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(353),
            data_im_in=>first_stage_im_out(353),
            product_re_out=>mul_re_out(353),
            product_im_out=>mul_im_out(353)
        );

    UMUL_354 : complex_multiplier
    generic map(
            re_multiplicator=>15790, --- 0.963745117188 + j-0.266662597656
            im_multiplicator=>-4369,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(354),
            data_im_in=>first_stage_im_out(354),
            product_re_out=>mul_re_out(354),
            product_im_out=>mul_im_out(354)
        );

    UMUL_355 : complex_multiplier
    generic map(
            re_multiplicator=>15058, --- 0.919067382812 + j-0.393981933594
            im_multiplicator=>-6455,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(355),
            data_im_in=>first_stage_im_out(355),
            product_re_out=>mul_re_out(355),
            product_im_out=>mul_im_out(355)
        );

    UMUL_356 : complex_multiplier
    generic map(
            re_multiplicator=>14053, --- 0.857727050781 + j-0.514099121094
            im_multiplicator=>-8423,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(356),
            data_im_in=>first_stage_im_out(356),
            product_re_out=>mul_re_out(356),
            product_im_out=>mul_im_out(356)
        );

    UMUL_357 : complex_multiplier
    generic map(
            re_multiplicator=>12791, --- 0.780700683594 + j-0.624816894531
            im_multiplicator=>-10237,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(357),
            data_im_in=>first_stage_im_out(357),
            product_re_out=>mul_re_out(357),
            product_im_out=>mul_im_out(357)
        );

    UMUL_358 : complex_multiplier
    generic map(
            re_multiplicator=>11297, --- 0.689514160156 + j-0.724243164062
            im_multiplicator=>-11866,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(358),
            data_im_in=>first_stage_im_out(358),
            product_re_out=>mul_re_out(358),
            product_im_out=>mul_im_out(358)
        );

    UMUL_359 : complex_multiplier
    generic map(
            re_multiplicator=>9597, --- 0.585754394531 + j-0.810424804688
            im_multiplicator=>-13278,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(359),
            data_im_in=>first_stage_im_out(359),
            product_re_out=>mul_re_out(359),
            product_im_out=>mul_im_out(359)
        );

    UMUL_360 : complex_multiplier
    generic map(
            re_multiplicator=>7723, --- 0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(360),
            data_im_in=>first_stage_im_out(360),
            product_re_out=>mul_re_out(360),
            product_im_out=>mul_im_out(360)
        );

    UMUL_361 : complex_multiplier
    generic map(
            re_multiplicator=>5708, --- 0.348388671875 + j-0.937316894531
            im_multiplicator=>-15357,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(361),
            data_im_in=>first_stage_im_out(361),
            product_re_out=>mul_re_out(361),
            product_im_out=>mul_im_out(361)
        );

    UMUL_362 : complex_multiplier
    generic map(
            re_multiplicator=>3589, --- 0.219055175781 + j-0.975646972656
            im_multiplicator=>-15985,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(362),
            data_im_in=>first_stage_im_out(362),
            product_re_out=>mul_re_out(362),
            product_im_out=>mul_im_out(362)
        );

    UMUL_363 : complex_multiplier
    generic map(
            re_multiplicator=>1405, --- 0.0857543945312 + j-0.996276855469
            im_multiplicator=>-16323,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(363),
            data_im_in=>first_stage_im_out(363),
            product_re_out=>mul_re_out(363),
            product_im_out=>mul_im_out(363)
        );

    UMUL_364 : complex_multiplier
    generic map(
            re_multiplicator=>-803, --- -0.0490112304688 + j-0.998779296875
            im_multiplicator=>-16364,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(364),
            data_im_in=>first_stage_im_out(364),
            product_re_out=>mul_re_out(364),
            product_im_out=>mul_im_out(364)
        );

    UMUL_365 : complex_multiplier
    generic map(
            re_multiplicator=>-2998, --- -0.182983398438 + j-0.983093261719
            im_multiplicator=>-16107,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(365),
            data_im_in=>first_stage_im_out(365),
            product_re_out=>mul_re_out(365),
            product_im_out=>mul_im_out(365)
        );

    UMUL_366 : complex_multiplier
    generic map(
            re_multiplicator=>-5139, --- -0.313659667969 + j-0.949523925781
            im_multiplicator=>-15557,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(366),
            data_im_in=>first_stage_im_out(366),
            product_re_out=>mul_re_out(366),
            product_im_out=>mul_im_out(366)
        );

    UMUL_367 : complex_multiplier
    generic map(
            re_multiplicator=>-7186, --- -0.438598632812 + j-0.898620605469
            im_multiplicator=>-14723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(367),
            data_im_in=>first_stage_im_out(367),
            product_re_out=>mul_re_out(367),
            product_im_out=>mul_im_out(367)
        );

    UMUL_368 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j-0.831420898438
            im_multiplicator=>-13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(368),
            data_im_in=>first_stage_im_out(368),
            product_re_out=>mul_re_out(368),
            product_im_out=>mul_im_out(368)
        );

    UMUL_369 : complex_multiplier
    generic map(
            re_multiplicator=>-10853, --- -0.662414550781 + j-0.749084472656
            im_multiplicator=>-12273,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(369),
            data_im_in=>first_stage_im_out(369),
            product_re_out=>mul_re_out(369),
            product_im_out=>mul_im_out(369)
        );

    UMUL_370 : complex_multiplier
    generic map(
            re_multiplicator=>-12406, --- -0.757202148438 + j-0.653137207031
            im_multiplicator=>-10701,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(370),
            data_im_in=>first_stage_im_out(370),
            product_re_out=>mul_re_out(370),
            product_im_out=>mul_im_out(370)
        );

    UMUL_371 : complex_multiplier
    generic map(
            re_multiplicator=>-13733, --- -0.838195800781 + j-0.545288085938
            im_multiplicator=>-8934,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(371),
            data_im_in=>first_stage_im_out(371),
            product_re_out=>mul_re_out(371),
            product_im_out=>mul_im_out(371)
        );

    UMUL_372 : complex_multiplier
    generic map(
            re_multiplicator=>-14810, --- -0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(372),
            data_im_in=>first_stage_im_out(372),
            product_re_out=>mul_re_out(372),
            product_im_out=>mul_im_out(372)
        );

    UMUL_373 : complex_multiplier
    generic map(
            re_multiplicator=>-15618, --- -0.953247070312 + j-0.302001953125
            im_multiplicator=>-4948,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(373),
            data_im_in=>first_stage_im_out(373),
            product_re_out=>mul_re_out(373),
            product_im_out=>mul_im_out(373)
        );

    UMUL_374 : complex_multiplier
    generic map(
            re_multiplicator=>-16142, --- -0.985229492188 + j-0.170959472656
            im_multiplicator=>-2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(374),
            data_im_in=>first_stage_im_out(374),
            product_re_out=>mul_re_out(374),
            product_im_out=>mul_im_out(374)
        );

    UMUL_375 : complex_multiplier
    generic map(
            re_multiplicator=>-16372, --- -0.999267578125 + j-0.0368041992188
            im_multiplicator=>-603,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(375),
            data_im_in=>first_stage_im_out(375),
            product_re_out=>mul_re_out(375),
            product_im_out=>mul_im_out(375)
        );

    UMUL_376 : complex_multiplier
    generic map(
            re_multiplicator=>-16305, --- -0.995178222656 + j0.0979614257812
            im_multiplicator=>1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(376),
            data_im_in=>first_stage_im_out(376),
            product_re_out=>mul_re_out(376),
            product_im_out=>mul_im_out(376)
        );

    UMUL_377 : complex_multiplier
    generic map(
            re_multiplicator=>-15940, --- -0.972900390625 + j0.231018066406
            im_multiplicator=>3785,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(377),
            data_im_in=>first_stage_im_out(377),
            product_re_out=>mul_re_out(377),
            product_im_out=>mul_im_out(377)
        );

    UMUL_378 : complex_multiplier
    generic map(
            re_multiplicator=>-15286, --- -0.932983398438 + j0.35986328125
            im_multiplicator=>5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(378),
            data_im_in=>first_stage_im_out(378),
            product_re_out=>mul_re_out(378),
            product_im_out=>mul_im_out(378)
        );

    UMUL_379 : complex_multiplier
    generic map(
            re_multiplicator=>-14353, --- -0.876037597656 + j0.482177734375
            im_multiplicator=>7900,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(379),
            data_im_in=>first_stage_im_out(379),
            product_re_out=>mul_re_out(379),
            product_im_out=>mul_im_out(379)
        );

    UMUL_380 : complex_multiplier
    generic map(
            re_multiplicator=>-13159, --- -0.803161621094 + j0.595642089844
            im_multiplicator=>9759,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(380),
            data_im_in=>first_stage_im_out(380),
            product_re_out=>mul_re_out(380),
            product_im_out=>mul_im_out(380)
        );

    UMUL_381 : complex_multiplier
    generic map(
            re_multiplicator=>-11726, --- -0.715698242188 + j0.698364257812
            im_multiplicator=>11442,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(381),
            data_im_in=>first_stage_im_out(381),
            product_re_out=>mul_re_out(381),
            product_im_out=>mul_im_out(381)
        );

    UMUL_382 : complex_multiplier
    generic map(
            re_multiplicator=>-10079, --- -0.615173339844 + j0.788330078125
            im_multiplicator=>12916,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(382),
            data_im_in=>first_stage_im_out(382),
            product_re_out=>mul_re_out(382),
            product_im_out=>mul_im_out(382)
        );

    UMUL_383 : complex_multiplier
    generic map(
            re_multiplicator=>-8249, --- -0.503479003906 + j0.863952636719
            im_multiplicator=>14155,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(383),
            data_im_in=>first_stage_im_out(383),
            product_re_out=>mul_re_out(383),
            product_im_out=>mul_im_out(383)
        );

    UDELAY_384_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(384),
            clk=>clk,
            Q=>shifter_re(384)
        );
    UDELAY_384_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(384),
            clk=>clk,
            Q=>shifter_im(384)
        );
    USHIFTER_384_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(384),
            data_out=>mul_re_out(384)
        );
    USHIFTER_384_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(384),
            data_out=>mul_im_out(384)
        );

    UMUL_385 : complex_multiplier
    generic map(
            re_multiplicator=>16206, --- 0.989135742188 + j-0.146728515625
            im_multiplicator=>-2404,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(385),
            data_im_in=>first_stage_im_out(385),
            product_re_out=>mul_re_out(385),
            product_im_out=>mul_im_out(385)
        );

    UMUL_386 : complex_multiplier
    generic map(
            re_multiplicator=>15678, --- 0.956909179688 + j-0.290283203125
            im_multiplicator=>-4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(386),
            data_im_in=>first_stage_im_out(386),
            product_re_out=>mul_re_out(386),
            product_im_out=>mul_im_out(386)
        );

    UMUL_387 : complex_multiplier
    generic map(
            re_multiplicator=>14810, --- 0.903930664062 + j-0.427551269531
            im_multiplicator=>-7005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(387),
            data_im_in=>first_stage_im_out(387),
            product_re_out=>mul_re_out(387),
            product_im_out=>mul_im_out(387)
        );

    UMUL_388 : complex_multiplier
    generic map(
            re_multiplicator=>13622, --- 0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(388),
            data_im_in=>first_stage_im_out(388),
            product_re_out=>mul_re_out(388),
            product_im_out=>mul_im_out(388)
        );

    UMUL_389 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(389),
            data_im_in=>first_stage_im_out(389),
            product_re_out=>mul_re_out(389),
            product_im_out=>mul_im_out(389)
        );

    UMUL_390 : complex_multiplier
    generic map(
            re_multiplicator=>10393, --- 0.634338378906 + j-0.773010253906
            im_multiplicator=>-12665,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(390),
            data_im_in=>first_stage_im_out(390),
            product_re_out=>mul_re_out(390),
            product_im_out=>mul_im_out(390)
        );

    UMUL_391 : complex_multiplier
    generic map(
            re_multiplicator=>8423, --- 0.514099121094 + j-0.857727050781
            im_multiplicator=>-14053,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(391),
            data_im_in=>first_stage_im_out(391),
            product_re_out=>mul_re_out(391),
            product_im_out=>mul_im_out(391)
        );

    UMUL_392 : complex_multiplier
    generic map(
            re_multiplicator=>6269, --- 0.382629394531 + j-0.923828125
            im_multiplicator=>-15136,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(392),
            data_im_in=>first_stage_im_out(392),
            product_re_out=>mul_re_out(392),
            product_im_out=>mul_im_out(392)
        );

    UMUL_393 : complex_multiplier
    generic map(
            re_multiplicator=>3980, --- 0.242919921875 + j-0.969970703125
            im_multiplicator=>-15892,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(393),
            data_im_in=>first_stage_im_out(393),
            product_re_out=>mul_re_out(393),
            product_im_out=>mul_im_out(393)
        );

    UMUL_394 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(394),
            data_im_in=>first_stage_im_out(394),
            product_re_out=>mul_re_out(394),
            product_im_out=>mul_im_out(394)
        );

    UMUL_395 : complex_multiplier
    generic map(
            re_multiplicator=>-803, --- -0.0490112304688 + j-0.998779296875
            im_multiplicator=>-16364,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(395),
            data_im_in=>first_stage_im_out(395),
            product_re_out=>mul_re_out(395),
            product_im_out=>mul_im_out(395)
        );

    UMUL_396 : complex_multiplier
    generic map(
            re_multiplicator=>-3196, --- -0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(396),
            data_im_in=>first_stage_im_out(396),
            product_re_out=>mul_re_out(396),
            product_im_out=>mul_im_out(396)
        );

    UMUL_397 : complex_multiplier
    generic map(
            re_multiplicator=>-5519, --- -0.336853027344 + j-0.941528320312
            im_multiplicator=>-15426,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(397),
            data_im_in=>first_stage_im_out(397),
            product_re_out=>mul_re_out(397),
            product_im_out=>mul_im_out(397)
        );

    UMUL_398 : complex_multiplier
    generic map(
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(398),
            data_im_in=>first_stage_im_out(398),
            product_re_out=>mul_re_out(398),
            product_im_out=>mul_im_out(398)
        );

    UMUL_399 : complex_multiplier
    generic map(
            re_multiplicator=>-9759, --- -0.595642089844 + j-0.803161621094
            im_multiplicator=>-13159,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(399),
            data_im_in=>first_stage_im_out(399),
            product_re_out=>mul_re_out(399),
            product_im_out=>mul_im_out(399)
        );

    UMUL_400 : complex_multiplier
    generic map(
            re_multiplicator=>-11585, --- -0.707092285156 + j-0.707092285156
            im_multiplicator=>-11585,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(400),
            data_im_in=>first_stage_im_out(400),
            product_re_out=>mul_re_out(400),
            product_im_out=>mul_im_out(400)
        );

    UMUL_401 : complex_multiplier
    generic map(
            re_multiplicator=>-13159, --- -0.803161621094 + j-0.595642089844
            im_multiplicator=>-9759,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(401),
            data_im_in=>first_stage_im_out(401),
            product_re_out=>mul_re_out(401),
            product_im_out=>mul_im_out(401)
        );

    UMUL_402 : complex_multiplier
    generic map(
            re_multiplicator=>-14449, --- -0.881896972656 + j-0.471374511719
            im_multiplicator=>-7723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(402),
            data_im_in=>first_stage_im_out(402),
            product_re_out=>mul_re_out(402),
            product_im_out=>mul_im_out(402)
        );

    UMUL_403 : complex_multiplier
    generic map(
            re_multiplicator=>-15426, --- -0.941528320312 + j-0.336853027344
            im_multiplicator=>-5519,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(403),
            data_im_in=>first_stage_im_out(403),
            product_re_out=>mul_re_out(403),
            product_im_out=>mul_im_out(403)
        );

    UMUL_404 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(404),
            data_im_in=>first_stage_im_out(404),
            product_re_out=>mul_re_out(404),
            product_im_out=>mul_im_out(404)
        );

    UMUL_405 : complex_multiplier
    generic map(
            re_multiplicator=>-16364, --- -0.998779296875 + j-0.0490112304688
            im_multiplicator=>-803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(405),
            data_im_in=>first_stage_im_out(405),
            product_re_out=>mul_re_out(405),
            product_im_out=>mul_im_out(405)
        );

    UMUL_406 : complex_multiplier
    generic map(
            re_multiplicator=>-16305, --- -0.995178222656 + j0.0979614257812
            im_multiplicator=>1605,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(406),
            data_im_in=>first_stage_im_out(406),
            product_re_out=>mul_re_out(406),
            product_im_out=>mul_im_out(406)
        );

    UMUL_407 : complex_multiplier
    generic map(
            re_multiplicator=>-15892, --- -0.969970703125 + j0.242919921875
            im_multiplicator=>3980,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(407),
            data_im_in=>first_stage_im_out(407),
            product_re_out=>mul_re_out(407),
            product_im_out=>mul_im_out(407)
        );

    UMUL_408 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j0.382629394531
            im_multiplicator=>6269,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(408),
            data_im_in=>first_stage_im_out(408),
            product_re_out=>mul_re_out(408),
            product_im_out=>mul_im_out(408)
        );

    UMUL_409 : complex_multiplier
    generic map(
            re_multiplicator=>-14053, --- -0.857727050781 + j0.514099121094
            im_multiplicator=>8423,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(409),
            data_im_in=>first_stage_im_out(409),
            product_re_out=>mul_re_out(409),
            product_im_out=>mul_im_out(409)
        );

    UMUL_410 : complex_multiplier
    generic map(
            re_multiplicator=>-12665, --- -0.773010253906 + j0.634338378906
            im_multiplicator=>10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(410),
            data_im_in=>first_stage_im_out(410),
            product_re_out=>mul_re_out(410),
            product_im_out=>mul_im_out(410)
        );

    UMUL_411 : complex_multiplier
    generic map(
            re_multiplicator=>-11002, --- -0.671508789062 + j0.740905761719
            im_multiplicator=>12139,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(411),
            data_im_in=>first_stage_im_out(411),
            product_re_out=>mul_re_out(411),
            product_im_out=>mul_im_out(411)
        );

    UMUL_412 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j0.831420898438
            im_multiplicator=>13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(412),
            data_im_in=>first_stage_im_out(412),
            product_re_out=>mul_re_out(412),
            product_im_out=>mul_im_out(412)
        );

    UMUL_413 : complex_multiplier
    generic map(
            re_multiplicator=>-7005, --- -0.427551269531 + j0.903930664062
            im_multiplicator=>14810,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(413),
            data_im_in=>first_stage_im_out(413),
            product_re_out=>mul_re_out(413),
            product_im_out=>mul_im_out(413)
        );

    UMUL_414 : complex_multiplier
    generic map(
            re_multiplicator=>-4756, --- -0.290283203125 + j0.956909179688
            im_multiplicator=>15678,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(414),
            data_im_in=>first_stage_im_out(414),
            product_re_out=>mul_re_out(414),
            product_im_out=>mul_im_out(414)
        );

    UMUL_415 : complex_multiplier
    generic map(
            re_multiplicator=>-2404, --- -0.146728515625 + j0.989135742188
            im_multiplicator=>16206,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(415),
            data_im_in=>first_stage_im_out(415),
            product_re_out=>mul_re_out(415),
            product_im_out=>mul_im_out(415)
        );

    UDELAY_416_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(416),
            clk=>clk,
            Q=>shifter_re(416)
        );
    UDELAY_416_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(416),
            clk=>clk,
            Q=>shifter_im(416)
        );
    USHIFTER_416_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(416),
            data_out=>mul_re_out(416)
        );
    USHIFTER_416_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(416),
            data_out=>mul_im_out(416)
        );

    UMUL_417 : complex_multiplier
    generic map(
            re_multiplicator=>16175, --- 0.987243652344 + j-0.158813476562
            im_multiplicator=>-2602,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(417),
            data_im_in=>first_stage_im_out(417),
            product_re_out=>mul_re_out(417),
            product_im_out=>mul_im_out(417)
        );

    UMUL_418 : complex_multiplier
    generic map(
            re_multiplicator=>15557, --- 0.949523925781 + j-0.313659667969
            im_multiplicator=>-5139,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(418),
            data_im_in=>first_stage_im_out(418),
            product_re_out=>mul_re_out(418),
            product_im_out=>mul_im_out(418)
        );

    UMUL_419 : complex_multiplier
    generic map(
            re_multiplicator=>14543, --- 0.887634277344 + j-0.460510253906
            im_multiplicator=>-7545,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(419),
            data_im_in=>first_stage_im_out(419),
            product_re_out=>mul_re_out(419),
            product_im_out=>mul_im_out(419)
        );

    UMUL_420 : complex_multiplier
    generic map(
            re_multiplicator=>13159, --- 0.803161621094 + j-0.595642089844
            im_multiplicator=>-9759,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(420),
            data_im_in=>first_stage_im_out(420),
            product_re_out=>mul_re_out(420),
            product_im_out=>mul_im_out(420)
        );

    UMUL_421 : complex_multiplier
    generic map(
            re_multiplicator=>11442, --- 0.698364257812 + j-0.715698242188
            im_multiplicator=>-11726,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(421),
            data_im_in=>first_stage_im_out(421),
            product_re_out=>mul_re_out(421),
            product_im_out=>mul_im_out(421)
        );

    UMUL_422 : complex_multiplier
    generic map(
            re_multiplicator=>9434, --- 0.575805664062 + j-0.817565917969
            im_multiplicator=>-13395,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(422),
            data_im_in=>first_stage_im_out(422),
            product_re_out=>mul_re_out(422),
            product_im_out=>mul_im_out(422)
        );

    UMUL_423 : complex_multiplier
    generic map(
            re_multiplicator=>7186, --- 0.438598632812 + j-0.898620605469
            im_multiplicator=>-14723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(423),
            data_im_in=>first_stage_im_out(423),
            product_re_out=>mul_re_out(423),
            product_im_out=>mul_im_out(423)
        );

    UMUL_424 : complex_multiplier
    generic map(
            re_multiplicator=>4756, --- 0.290283203125 + j-0.956909179688
            im_multiplicator=>-15678,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(424),
            data_im_in=>first_stage_im_out(424),
            product_re_out=>mul_re_out(424),
            product_im_out=>mul_im_out(424)
        );

    UMUL_425 : complex_multiplier
    generic map(
            re_multiplicator=>2204, --- 0.134521484375 + j-0.990844726562
            im_multiplicator=>-16234,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(425),
            data_im_in=>first_stage_im_out(425),
            product_re_out=>mul_re_out(425),
            product_im_out=>mul_im_out(425)
        );

    UMUL_426 : complex_multiplier
    generic map(
            re_multiplicator=>-402, --- -0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(426),
            data_im_in=>first_stage_im_out(426),
            product_re_out=>mul_re_out(426),
            product_im_out=>mul_im_out(426)
        );

    UMUL_427 : complex_multiplier
    generic map(
            re_multiplicator=>-2998, --- -0.182983398438 + j-0.983093261719
            im_multiplicator=>-16107,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(427),
            data_im_in=>first_stage_im_out(427),
            product_re_out=>mul_re_out(427),
            product_im_out=>mul_im_out(427)
        );

    UMUL_428 : complex_multiplier
    generic map(
            re_multiplicator=>-5519, --- -0.336853027344 + j-0.941528320312
            im_multiplicator=>-15426,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(428),
            data_im_in=>first_stage_im_out(428),
            product_re_out=>mul_re_out(428),
            product_im_out=>mul_im_out(428)
        );

    UMUL_429 : complex_multiplier
    generic map(
            re_multiplicator=>-7900, --- -0.482177734375 + j-0.876037597656
            im_multiplicator=>-14353,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(429),
            data_im_in=>first_stage_im_out(429),
            product_re_out=>mul_re_out(429),
            product_im_out=>mul_im_out(429)
        );

    UMUL_430 : complex_multiplier
    generic map(
            re_multiplicator=>-10079, --- -0.615173339844 + j-0.788330078125
            im_multiplicator=>-12916,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(430),
            data_im_in=>first_stage_im_out(430),
            product_re_out=>mul_re_out(430),
            product_im_out=>mul_im_out(430)
        );

    UMUL_431 : complex_multiplier
    generic map(
            re_multiplicator=>-12003, --- -0.732604980469 + j-0.680541992188
            im_multiplicator=>-11150,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(431),
            data_im_in=>first_stage_im_out(431),
            product_re_out=>mul_re_out(431),
            product_im_out=>mul_im_out(431)
        );

    UMUL_432 : complex_multiplier
    generic map(
            re_multiplicator=>-13622, --- -0.831420898438 + j-0.555541992188
            im_multiplicator=>-9102,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(432),
            data_im_in=>first_stage_im_out(432),
            product_re_out=>mul_re_out(432),
            product_im_out=>mul_im_out(432)
        );

    UMUL_433 : complex_multiplier
    generic map(
            re_multiplicator=>-14895, --- -0.909118652344 + j-0.416381835938
            im_multiplicator=>-6822,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(433),
            data_im_in=>first_stage_im_out(433),
            product_re_out=>mul_re_out(433),
            product_im_out=>mul_im_out(433)
        );

    UMUL_434 : complex_multiplier
    generic map(
            re_multiplicator=>-15790, --- -0.963745117188 + j-0.266662597656
            im_multiplicator=>-4369,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(434),
            data_im_in=>first_stage_im_out(434),
            product_re_out=>mul_re_out(434),
            product_im_out=>mul_im_out(434)
        );

    UMUL_435 : complex_multiplier
    generic map(
            re_multiplicator=>-16284, --- -0.993896484375 + j-0.110168457031
            im_multiplicator=>-1805,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(435),
            data_im_in=>first_stage_im_out(435),
            product_re_out=>mul_re_out(435),
            product_im_out=>mul_im_out(435)
        );

    UMUL_436 : complex_multiplier
    generic map(
            re_multiplicator=>-16364, --- -0.998779296875 + j0.0490112304688
            im_multiplicator=>803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(436),
            data_im_in=>first_stage_im_out(436),
            product_re_out=>mul_re_out(436),
            product_im_out=>mul_im_out(436)
        );

    UMUL_437 : complex_multiplier
    generic map(
            re_multiplicator=>-16028, --- -0.978271484375 + j0.207092285156
            im_multiplicator=>3393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(437),
            data_im_in=>first_stage_im_out(437),
            product_re_out=>mul_re_out(437),
            product_im_out=>mul_im_out(437)
        );

    UMUL_438 : complex_multiplier
    generic map(
            re_multiplicator=>-15286, --- -0.932983398438 + j0.35986328125
            im_multiplicator=>5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(438),
            data_im_in=>first_stage_im_out(438),
            product_re_out=>mul_re_out(438),
            product_im_out=>mul_im_out(438)
        );

    UMUL_439 : complex_multiplier
    generic map(
            re_multiplicator=>-14155, --- -0.863952636719 + j0.503479003906
            im_multiplicator=>8249,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(439),
            data_im_in=>first_stage_im_out(439),
            product_re_out=>mul_re_out(439),
            product_im_out=>mul_im_out(439)
        );

    UMUL_440 : complex_multiplier
    generic map(
            re_multiplicator=>-12665, --- -0.773010253906 + j0.634338378906
            im_multiplicator=>10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(440),
            data_im_in=>first_stage_im_out(440),
            product_re_out=>mul_re_out(440),
            product_im_out=>mul_im_out(440)
        );

    UMUL_441 : complex_multiplier
    generic map(
            re_multiplicator=>-10853, --- -0.662414550781 + j0.749084472656
            im_multiplicator=>12273,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(441),
            data_im_in=>first_stage_im_out(441),
            product_re_out=>mul_re_out(441),
            product_im_out=>mul_im_out(441)
        );

    UMUL_442 : complex_multiplier
    generic map(
            re_multiplicator=>-8765, --- -0.534973144531 + j0.844848632812
            im_multiplicator=>13842,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(442),
            data_im_in=>first_stage_im_out(442),
            product_re_out=>mul_re_out(442),
            product_im_out=>mul_im_out(442)
        );

    UMUL_443 : complex_multiplier
    generic map(
            re_multiplicator=>-6455, --- -0.393981933594 + j0.919067382812
            im_multiplicator=>15058,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(443),
            data_im_in=>first_stage_im_out(443),
            product_re_out=>mul_re_out(443),
            product_im_out=>mul_im_out(443)
        );

    UMUL_444 : complex_multiplier
    generic map(
            re_multiplicator=>-3980, --- -0.242919921875 + j0.969970703125
            im_multiplicator=>15892,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(444),
            data_im_in=>first_stage_im_out(444),
            product_re_out=>mul_re_out(444),
            product_im_out=>mul_im_out(444)
        );

    UMUL_445 : complex_multiplier
    generic map(
            re_multiplicator=>-1405, --- -0.0857543945312 + j0.996276855469
            im_multiplicator=>16323,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(445),
            data_im_in=>first_stage_im_out(445),
            product_re_out=>mul_re_out(445),
            product_im_out=>mul_im_out(445)
        );

    UMUL_446 : complex_multiplier
    generic map(
            re_multiplicator=>1205, --- 0.0735473632812 + j0.997253417969
            im_multiplicator=>16339,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(446),
            data_im_in=>first_stage_im_out(446),
            product_re_out=>mul_re_out(446),
            product_im_out=>mul_im_out(446)
        );

    UMUL_447 : complex_multiplier
    generic map(
            re_multiplicator=>3785, --- 0.231018066406 + j0.972900390625
            im_multiplicator=>15940,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(447),
            data_im_in=>first_stage_im_out(447),
            product_re_out=>mul_re_out(447),
            product_im_out=>mul_im_out(447)
        );

    UDELAY_448_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(448),
            clk=>clk,
            Q=>shifter_re(448)
        );
    UDELAY_448_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(448),
            clk=>clk,
            Q=>shifter_im(448)
        );
    USHIFTER_448_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(448),
            data_out=>mul_re_out(448)
        );
    USHIFTER_448_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(448),
            data_out=>mul_im_out(448)
        );

    UMUL_449 : complex_multiplier
    generic map(
            re_multiplicator=>16142, --- 0.985229492188 + j-0.170959472656
            im_multiplicator=>-2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(449),
            data_im_in=>first_stage_im_out(449),
            product_re_out=>mul_re_out(449),
            product_im_out=>mul_im_out(449)
        );

    UMUL_450 : complex_multiplier
    generic map(
            re_multiplicator=>15426, --- 0.941528320312 + j-0.336853027344
            im_multiplicator=>-5519,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(450),
            data_im_in=>first_stage_im_out(450),
            product_re_out=>mul_re_out(450),
            product_im_out=>mul_im_out(450)
        );

    UMUL_451 : complex_multiplier
    generic map(
            re_multiplicator=>14255, --- 0.870056152344 + j-0.492858886719
            im_multiplicator=>-8075,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(451),
            data_im_in=>first_stage_im_out(451),
            product_re_out=>mul_re_out(451),
            product_im_out=>mul_im_out(451)
        );

    UMUL_452 : complex_multiplier
    generic map(
            re_multiplicator=>12665, --- 0.773010253906 + j-0.634338378906
            im_multiplicator=>-10393,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(452),
            data_im_in=>first_stage_im_out(452),
            product_re_out=>mul_re_out(452),
            product_im_out=>mul_im_out(452)
        );

    UMUL_453 : complex_multiplier
    generic map(
            re_multiplicator=>10701, --- 0.653137207031 + j-0.757202148438
            im_multiplicator=>-12406,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(453),
            data_im_in=>first_stage_im_out(453),
            product_re_out=>mul_re_out(453),
            product_im_out=>mul_im_out(453)
        );

    UMUL_454 : complex_multiplier
    generic map(
            re_multiplicator=>8423, --- 0.514099121094 + j-0.857727050781
            im_multiplicator=>-14053,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(454),
            data_im_in=>first_stage_im_out(454),
            product_re_out=>mul_re_out(454),
            product_im_out=>mul_im_out(454)
        );

    UMUL_455 : complex_multiplier
    generic map(
            re_multiplicator=>5896, --- 0.35986328125 + j-0.932983398438
            im_multiplicator=>-15286,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(455),
            data_im_in=>first_stage_im_out(455),
            product_re_out=>mul_re_out(455),
            product_im_out=>mul_im_out(455)
        );

    UMUL_456 : complex_multiplier
    generic map(
            re_multiplicator=>3196, --- 0.195068359375 + j-0.980773925781
            im_multiplicator=>-16069,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(456),
            data_im_in=>first_stage_im_out(456),
            product_re_out=>mul_re_out(456),
            product_im_out=>mul_im_out(456)
        );

    UMUL_457 : complex_multiplier
    generic map(
            re_multiplicator=>402, --- 0.0245361328125 + j-0.999694824219
            im_multiplicator=>-16379,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(457),
            data_im_in=>first_stage_im_out(457),
            product_re_out=>mul_re_out(457),
            product_im_out=>mul_im_out(457)
        );

    UMUL_458 : complex_multiplier
    generic map(
            re_multiplicator=>-2404, --- -0.146728515625 + j-0.989135742188
            im_multiplicator=>-16206,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(458),
            data_im_in=>first_stage_im_out(458),
            product_re_out=>mul_re_out(458),
            product_im_out=>mul_im_out(458)
        );

    UMUL_459 : complex_multiplier
    generic map(
            re_multiplicator=>-5139, --- -0.313659667969 + j-0.949523925781
            im_multiplicator=>-15557,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(459),
            data_im_in=>first_stage_im_out(459),
            product_re_out=>mul_re_out(459),
            product_im_out=>mul_im_out(459)
        );

    UMUL_460 : complex_multiplier
    generic map(
            re_multiplicator=>-7723, --- -0.471374511719 + j-0.881896972656
            im_multiplicator=>-14449,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(460),
            data_im_in=>first_stage_im_out(460),
            product_re_out=>mul_re_out(460),
            product_im_out=>mul_im_out(460)
        );

    UMUL_461 : complex_multiplier
    generic map(
            re_multiplicator=>-10079, --- -0.615173339844 + j-0.788330078125
            im_multiplicator=>-12916,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(461),
            data_im_in=>first_stage_im_out(461),
            product_re_out=>mul_re_out(461),
            product_im_out=>mul_im_out(461)
        );

    UMUL_462 : complex_multiplier
    generic map(
            re_multiplicator=>-12139, --- -0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(462),
            data_im_in=>first_stage_im_out(462),
            product_re_out=>mul_re_out(462),
            product_im_out=>mul_im_out(462)
        );

    UMUL_463 : complex_multiplier
    generic map(
            re_multiplicator=>-13842, --- -0.844848632812 + j-0.534973144531
            im_multiplicator=>-8765,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(463),
            data_im_in=>first_stage_im_out(463),
            product_re_out=>mul_re_out(463),
            product_im_out=>mul_im_out(463)
        );

    UMUL_464 : complex_multiplier
    generic map(
            re_multiplicator=>-15136, --- -0.923828125 + j-0.382629394531
            im_multiplicator=>-6269,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(464),
            data_im_in=>first_stage_im_out(464),
            product_re_out=>mul_re_out(464),
            product_im_out=>mul_im_out(464)
        );

    UMUL_465 : complex_multiplier
    generic map(
            re_multiplicator=>-15985, --- -0.975646972656 + j-0.219055175781
            im_multiplicator=>-3589,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(465),
            data_im_in=>first_stage_im_out(465),
            product_re_out=>mul_re_out(465),
            product_im_out=>mul_im_out(465)
        );

    UMUL_466 : complex_multiplier
    generic map(
            re_multiplicator=>-16364, --- -0.998779296875 + j-0.0490112304688
            im_multiplicator=>-803,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(466),
            data_im_in=>first_stage_im_out(466),
            product_re_out=>mul_re_out(466),
            product_im_out=>mul_im_out(466)
        );

    UMUL_467 : complex_multiplier
    generic map(
            re_multiplicator=>-16260, --- -0.992431640625 + j0.122375488281
            im_multiplicator=>2005,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(467),
            data_im_in=>first_stage_im_out(467),
            product_re_out=>mul_re_out(467),
            product_im_out=>mul_im_out(467)
        );

    UMUL_468 : complex_multiplier
    generic map(
            re_multiplicator=>-15678, --- -0.956909179688 + j0.290283203125
            im_multiplicator=>4756,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(468),
            data_im_in=>first_stage_im_out(468),
            product_re_out=>mul_re_out(468),
            product_im_out=>mul_im_out(468)
        );

    UMUL_469 : complex_multiplier
    generic map(
            re_multiplicator=>-14634, --- -0.893188476562 + j0.449584960938
            im_multiplicator=>7366,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(469),
            data_im_in=>first_stage_im_out(469),
            product_re_out=>mul_re_out(469),
            product_im_out=>mul_im_out(469)
        );

    UMUL_470 : complex_multiplier
    generic map(
            re_multiplicator=>-13159, --- -0.803161621094 + j0.595642089844
            im_multiplicator=>9759,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(470),
            data_im_in=>first_stage_im_out(470),
            product_re_out=>mul_re_out(470),
            product_im_out=>mul_im_out(470)
        );

    UMUL_471 : complex_multiplier
    generic map(
            re_multiplicator=>-11297, --- -0.689514160156 + j0.724243164062
            im_multiplicator=>11866,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(471),
            data_im_in=>first_stage_im_out(471),
            product_re_out=>mul_re_out(471),
            product_im_out=>mul_im_out(471)
        );

    UMUL_472 : complex_multiplier
    generic map(
            re_multiplicator=>-9102, --- -0.555541992188 + j0.831420898438
            im_multiplicator=>13622,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(472),
            data_im_in=>first_stage_im_out(472),
            product_re_out=>mul_re_out(472),
            product_im_out=>mul_im_out(472)
        );

    UMUL_473 : complex_multiplier
    generic map(
            re_multiplicator=>-6639, --- -0.405212402344 + j0.914184570312
            im_multiplicator=>14978,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(473),
            data_im_in=>first_stage_im_out(473),
            product_re_out=>mul_re_out(473),
            product_im_out=>mul_im_out(473)
        );

    UMUL_474 : complex_multiplier
    generic map(
            re_multiplicator=>-3980, --- -0.242919921875 + j0.969970703125
            im_multiplicator=>15892,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(474),
            data_im_in=>first_stage_im_out(474),
            product_re_out=>mul_re_out(474),
            product_im_out=>mul_im_out(474)
        );

    UMUL_475 : complex_multiplier
    generic map(
            re_multiplicator=>-1205, --- -0.0735473632812 + j0.997253417969
            im_multiplicator=>16339,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(475),
            data_im_in=>first_stage_im_out(475),
            product_re_out=>mul_re_out(475),
            product_im_out=>mul_im_out(475)
        );

    UMUL_476 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j0.995178222656
            im_multiplicator=>16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(476),
            data_im_in=>first_stage_im_out(476),
            product_re_out=>mul_re_out(476),
            product_im_out=>mul_im_out(476)
        );

    UMUL_477 : complex_multiplier
    generic map(
            re_multiplicator=>4369, --- 0.266662597656 + j0.963745117188
            im_multiplicator=>15790,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(477),
            data_im_in=>first_stage_im_out(477),
            product_re_out=>mul_re_out(477),
            product_im_out=>mul_im_out(477)
        );

    UMUL_478 : complex_multiplier
    generic map(
            re_multiplicator=>7005, --- 0.427551269531 + j0.903930664062
            im_multiplicator=>14810,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(478),
            data_im_in=>first_stage_im_out(478),
            product_re_out=>mul_re_out(478),
            product_im_out=>mul_im_out(478)
        );

    UMUL_479 : complex_multiplier
    generic map(
            re_multiplicator=>9434, --- 0.575805664062 + j0.817565917969
            im_multiplicator=>13395,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(479),
            data_im_in=>first_stage_im_out(479),
            product_re_out=>mul_re_out(479),
            product_im_out=>mul_im_out(479)
        );

    UDELAY_480_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_re_out(480),
            clk=>clk,
            Q=>shifter_re(480)
        );
    UDELAY_480_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>first_stage_im_out(480),
            clk=>clk,
            Q=>shifter_im(480)
        );
    USHIFTER_480_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_re(480),
            data_out=>mul_re_out(480)
        );
    USHIFTER_480_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay((ctrl_start+3) mod 16),
            data_in=>shifter_im(480),
            data_out=>mul_im_out(480)
        );

    UMUL_481 : complex_multiplier
    generic map(
            re_multiplicator=>16107, --- 0.983093261719 + j-0.182983398438
            im_multiplicator=>-2998,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(481),
            data_im_in=>first_stage_im_out(481),
            product_re_out=>mul_re_out(481),
            product_im_out=>mul_im_out(481)
        );

    UMUL_482 : complex_multiplier
    generic map(
            re_multiplicator=>15286, --- 0.932983398438 + j-0.35986328125
            im_multiplicator=>-5896,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(482),
            data_im_in=>first_stage_im_out(482),
            product_re_out=>mul_re_out(482),
            product_im_out=>mul_im_out(482)
        );

    UMUL_483 : complex_multiplier
    generic map(
            re_multiplicator=>13948, --- 0.851318359375 + j-0.524536132812
            im_multiplicator=>-8594,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(483),
            data_im_in=>first_stage_im_out(483),
            product_re_out=>mul_re_out(483),
            product_im_out=>mul_im_out(483)
        );

    UMUL_484 : complex_multiplier
    generic map(
            re_multiplicator=>12139, --- 0.740905761719 + j-0.671508789062
            im_multiplicator=>-11002,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(484),
            data_im_in=>first_stage_im_out(484),
            product_re_out=>mul_re_out(484),
            product_im_out=>mul_im_out(484)
        );

    UMUL_485 : complex_multiplier
    generic map(
            re_multiplicator=>9920, --- 0.60546875 + j-0.795776367188
            im_multiplicator=>-13038,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(485),
            data_im_in=>first_stage_im_out(485),
            product_re_out=>mul_re_out(485),
            product_im_out=>mul_im_out(485)
        );

    UMUL_486 : complex_multiplier
    generic map(
            re_multiplicator=>7366, --- 0.449584960938 + j-0.893188476562
            im_multiplicator=>-14634,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(486),
            data_im_in=>first_stage_im_out(486),
            product_re_out=>mul_re_out(486),
            product_im_out=>mul_im_out(486)
        );

    UMUL_487 : complex_multiplier
    generic map(
            re_multiplicator=>4563, --- 0.278503417969 + j-0.960388183594
            im_multiplicator=>-15735,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(487),
            data_im_in=>first_stage_im_out(487),
            product_re_out=>mul_re_out(487),
            product_im_out=>mul_im_out(487)
        );

    UMUL_488 : complex_multiplier
    generic map(
            re_multiplicator=>1605, --- 0.0979614257812 + j-0.995178222656
            im_multiplicator=>-16305,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(488),
            data_im_in=>first_stage_im_out(488),
            product_re_out=>mul_re_out(488),
            product_im_out=>mul_im_out(488)
        );

    UMUL_489 : complex_multiplier
    generic map(
            re_multiplicator=>-1405, --- -0.0857543945312 + j-0.996276855469
            im_multiplicator=>-16323,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(489),
            data_im_in=>first_stage_im_out(489),
            product_re_out=>mul_re_out(489),
            product_im_out=>mul_im_out(489)
        );

    UMUL_490 : complex_multiplier
    generic map(
            re_multiplicator=>-4369, --- -0.266662597656 + j-0.963745117188
            im_multiplicator=>-15790,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(490),
            data_im_in=>first_stage_im_out(490),
            product_re_out=>mul_re_out(490),
            product_im_out=>mul_im_out(490)
        );

    UMUL_491 : complex_multiplier
    generic map(
            re_multiplicator=>-7186, --- -0.438598632812 + j-0.898620605469
            im_multiplicator=>-14723,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(491),
            data_im_in=>first_stage_im_out(491),
            product_re_out=>mul_re_out(491),
            product_im_out=>mul_im_out(491)
        );

    UMUL_492 : complex_multiplier
    generic map(
            re_multiplicator=>-9759, --- -0.595642089844 + j-0.803161621094
            im_multiplicator=>-13159,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(492),
            data_im_in=>first_stage_im_out(492),
            product_re_out=>mul_re_out(492),
            product_im_out=>mul_im_out(492)
        );

    UMUL_493 : complex_multiplier
    generic map(
            re_multiplicator=>-12003, --- -0.732604980469 + j-0.680541992188
            im_multiplicator=>-11150,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(493),
            data_im_in=>first_stage_im_out(493),
            product_re_out=>mul_re_out(493),
            product_im_out=>mul_im_out(493)
        );

    UMUL_494 : complex_multiplier
    generic map(
            re_multiplicator=>-13842, --- -0.844848632812 + j-0.534973144531
            im_multiplicator=>-8765,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(494),
            data_im_in=>first_stage_im_out(494),
            product_re_out=>mul_re_out(494),
            product_im_out=>mul_im_out(494)
        );

    UMUL_495 : complex_multiplier
    generic map(
            re_multiplicator=>-15212, --- -0.928466796875 + j-0.371276855469
            im_multiplicator=>-6083,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(495),
            data_im_in=>first_stage_im_out(495),
            product_re_out=>mul_re_out(495),
            product_im_out=>mul_im_out(495)
        );

    UMUL_496 : complex_multiplier
    generic map(
            re_multiplicator=>-16069, --- -0.980773925781 + j-0.195068359375
            im_multiplicator=>-3196,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(496),
            data_im_in=>first_stage_im_out(496),
            product_re_out=>mul_re_out(496),
            product_im_out=>mul_im_out(496)
        );

    UMUL_497 : complex_multiplier
    generic map(
            re_multiplicator=>-16382, --- -0.999877929688 + j-0.0122680664062
            im_multiplicator=>-201,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(497),
            data_im_in=>first_stage_im_out(497),
            product_re_out=>mul_re_out(497),
            product_im_out=>mul_im_out(497)
        );

    UMUL_498 : complex_multiplier
    generic map(
            re_multiplicator=>-16142, --- -0.985229492188 + j0.170959472656
            im_multiplicator=>2801,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(498),
            data_im_in=>first_stage_im_out(498),
            product_re_out=>mul_re_out(498),
            product_im_out=>mul_im_out(498)
        );

    UMUL_499 : complex_multiplier
    generic map(
            re_multiplicator=>-15357, --- -0.937316894531 + j0.348388671875
            im_multiplicator=>5708,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(499),
            data_im_in=>first_stage_im_out(499),
            product_re_out=>mul_re_out(499),
            product_im_out=>mul_im_out(499)
        );

    UMUL_500 : complex_multiplier
    generic map(
            re_multiplicator=>-14053, --- -0.857727050781 + j0.514099121094
            im_multiplicator=>8423,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(500),
            data_im_in=>first_stage_im_out(500),
            product_re_out=>mul_re_out(500),
            product_im_out=>mul_im_out(500)
        );

    UMUL_501 : complex_multiplier
    generic map(
            re_multiplicator=>-12273, --- -0.749084472656 + j0.662414550781
            im_multiplicator=>10853,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(501),
            data_im_in=>first_stage_im_out(501),
            product_re_out=>mul_re_out(501),
            product_im_out=>mul_im_out(501)
        );

    UMUL_502 : complex_multiplier
    generic map(
            re_multiplicator=>-10079, --- -0.615173339844 + j0.788330078125
            im_multiplicator=>12916,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(502),
            data_im_in=>first_stage_im_out(502),
            product_re_out=>mul_re_out(502),
            product_im_out=>mul_im_out(502)
        );

    UMUL_503 : complex_multiplier
    generic map(
            re_multiplicator=>-7545, --- -0.460510253906 + j0.887634277344
            im_multiplicator=>14543,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(503),
            data_im_in=>first_stage_im_out(503),
            product_re_out=>mul_re_out(503),
            product_im_out=>mul_im_out(503)
        );

    UMUL_504 : complex_multiplier
    generic map(
            re_multiplicator=>-4756, --- -0.290283203125 + j0.956909179688
            im_multiplicator=>15678,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(504),
            data_im_in=>first_stage_im_out(504),
            product_re_out=>mul_re_out(504),
            product_im_out=>mul_im_out(504)
        );

    UMUL_505 : complex_multiplier
    generic map(
            re_multiplicator=>-1805, --- -0.110168457031 + j0.993896484375
            im_multiplicator=>16284,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(505),
            data_im_in=>first_stage_im_out(505),
            product_re_out=>mul_re_out(505),
            product_im_out=>mul_im_out(505)
        );

    UMUL_506 : complex_multiplier
    generic map(
            re_multiplicator=>1205, --- 0.0735473632812 + j0.997253417969
            im_multiplicator=>16339,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(506),
            data_im_in=>first_stage_im_out(506),
            product_re_out=>mul_re_out(506),
            product_im_out=>mul_im_out(506)
        );

    UMUL_507 : complex_multiplier
    generic map(
            re_multiplicator=>4175, --- 0.254821777344 + j0.966918945312
            im_multiplicator=>15842,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(507),
            data_im_in=>first_stage_im_out(507),
            product_re_out=>mul_re_out(507),
            product_im_out=>mul_im_out(507)
        );

    UMUL_508 : complex_multiplier
    generic map(
            re_multiplicator=>7005, --- 0.427551269531 + j0.903930664062
            im_multiplicator=>14810,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(508),
            data_im_in=>first_stage_im_out(508),
            product_re_out=>mul_re_out(508),
            product_im_out=>mul_im_out(508)
        );

    UMUL_509 : complex_multiplier
    generic map(
            re_multiplicator=>9597, --- 0.585754394531 + j0.810424804688
            im_multiplicator=>13278,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(509),
            data_im_in=>first_stage_im_out(509),
            product_re_out=>mul_re_out(509),
            product_im_out=>mul_im_out(509)
        );

    UMUL_510 : complex_multiplier
    generic map(
            re_multiplicator=>11866, --- 0.724243164062 + j0.689514160156
            im_multiplicator=>11297,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(510),
            data_im_in=>first_stage_im_out(510),
            product_re_out=>mul_re_out(510),
            product_im_out=>mul_im_out(510)
        );

    UMUL_511 : complex_multiplier
    generic map(
            re_multiplicator=>13733, --- 0.838195800781 + j0.545288085938
            im_multiplicator=>8934,
            ctrl_start => (ctrl_start+3) mod 16
        )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in=>first_stage_re_out(511),
            data_im_in=>first_stage_im_out(511),
            product_re_out=>mul_re_out(511),
            product_im_out=>mul_im_out(511)
        );

end Behavioral;
