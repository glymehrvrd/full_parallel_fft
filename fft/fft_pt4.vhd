library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fft_pt4 is
    GENERIC (
        ctrl_start     : INTEGER := 0
    );
    PORT (
        tmp_first_stage_re_out, tmp_first_stage_im_out: out std_logic_vector(3 downto 0);
        tmp_mul_re_out, tmp_mul_im_out : out std_logic_vector(3 downto 0);

        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(3 downto 0);
        data_im_in:in std_logic_vector(3 downto 0);

        data_re_out:out std_logic_vector(3 downto 0);
        data_im_out:out std_logic_vector(3 downto 0)
    );
end fft_pt4;

architecture Behavioral of fft_pt4 is

COMPONENT Dff_preload_reg1_init_1 IS
    PORT (
        D        : IN STD_LOGIC;
        clk      : IN STD_LOGIC;
        preload  : IN STD_LOGIC;
        Q        : OUT STD_LOGIC;
        QN       : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT Dff_reg1 IS
    PORT (
        D    : IN STD_LOGIC;
        clk  : IN STD_LOGIC;
        Q    : OUT STD_LOGIC
    );
END COMPONENT;

component fft_pt2_nodelay is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl_delay     : IN STD_LOGIC_VECTOR(15 downto 0);

        data_re_in:in std_logic_vector(1 downto 0);
        data_im_in:in std_logic_vector(1 downto 0);

        data_re_out:out std_logic_vector(1 downto 0);
        data_im_out:out std_logic_vector(1 downto 0)
    );
end component;

component adder_half_bit1
    PORT (
        data1_in  : IN STD_LOGIC;
        data2_in  : IN STD_LOGIC;
        sum_out   : OUT STD_LOGIC;
        c_out     : OUT STD_LOGIC
    );
end component;

signal first_stage_re_out, first_stage_im_out: std_logic_vector(3 downto 0);

signal not_first_stage_re_out: std_logic;
signal c: std_logic;
signal c_buff: std_logic;
signal opp_first_stage_re_out: std_logic;

SIGNAL data_re_out_buff : std_logic_vector(3 DOWNTO 0);
SIGNAL data_im_out_buff : std_logic_vector(3 DOWNTO 0);

begin

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;

    GEN_OUT_BUFF : for I in 0 to 3 generate
        UDFF_RE_OUT : Dff_reg1 port map(
                D=>data_re_out_buff(I),
                clk=>clk,
                Q=>data_re_out(I)
            );

        UDFF_IM_OUT : Dff_reg1 port map(
                D=>data_im_out_buff(I),
                clk=>clk,
                Q=>data_im_out(I)
            );
    end generate ; -- GEN_OUT_BUFF

    --- left-hand-side processors
    ULFFT_PT2_0 : fft_pt2_nodelay
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(0),
            data_re_in(1)=>data_re_in(2),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(2),
            data_re_out=>first_stage_re_out(1 downto 0),
            data_im_out=>first_stage_im_out(1 downto 0)
        );

    ULFFT_PT2_1 : fft_pt2_nodelay
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(1),
            data_re_in(1)=>data_re_in(3),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(3),
            data_re_out=>first_stage_re_out(3 downto 2),
            data_im_out=>first_stage_im_out(3 downto 2)
        );


    --- right-hand-side processors
    URFFT_PT2_0 : fft_pt2_nodelay
    generic map(
        ctrl_start => ctrl_start mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>first_stage_re_out(0),
            data_re_in(1)=>first_stage_re_out(2),
            data_im_in(0)=>first_stage_im_out(0),
            data_im_in(1)=>first_stage_im_out(2),
            data_re_out(0)=>data_re_out_buff(0),
            data_re_out(1)=>data_re_out_buff(2),
            data_im_out(0)=>data_im_out_buff(0),
            data_im_out(1)=>data_im_out_buff(2)
        );           

    URFFT_PT2_1 : fft_pt2_nodelay
    generic map(
        ctrl_start => ctrl_start mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>first_stage_re_out(1),
            data_re_in(1)=>first_stage_im_out(3),
            data_im_in(0)=>first_stage_im_out(1),
            data_im_in(1)=>opp_first_stage_re_out,
            data_re_out(0)=>data_re_out_buff(1),
            data_re_out(1)=>data_re_out_buff(3),
            data_im_out(0)=>data_im_out_buff(1),
            data_im_out(1)=>data_im_out_buff(3)
        );           


    --- multipliers
    not_first_stage_re_out <= not first_stage_re_out(3);
    C_BUFF_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c, 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start mod 16), 
        Q        => c_buff
    );
    ADDER_3 : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff, 
        data2_in  => not_first_stage_re_out, 
        sum_out   => opp_first_stage_re_out, 
        c_out     => c
    );

end Behavioral;
