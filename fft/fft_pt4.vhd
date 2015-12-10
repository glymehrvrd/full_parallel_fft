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
        bypass         : IN STD_LOGIC_VECTOR(1 downto 0);
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

component fft_pt2 is
    GENERIC (
        ctrl_start       : INTEGER
    );
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        bypass         : IN std_logic;
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

    COMPONENT mux_in2 IS
        PORT (
            sel       : IN STD_LOGIC;

            data1_in  : IN STD_LOGIC;
            data2_in  : IN std_logic;
            data_out  : OUT std_logic
        );
    END COMPONENT;

signal first_stage_re_out, first_stage_im_out: std_logic_vector(3 downto 0);
signal mul_re_out, mul_im_out : std_logic_vector(3 downto 0);

signal not_first_stage_re_out: std_logic;
signal c: std_logic;
signal c_buff: std_logic;
signal opp_first_stage_re_out: std_logic;

begin

    tmp_first_stage_re_out <= first_stage_re_out;
    tmp_first_stage_im_out <= first_stage_im_out;

    --- left-hand-side processors
    ULFFT_PT2_0 : fft_pt2
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            bypass=>bypass(1),
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(0),
            data_re_in(1)=>data_re_in(2),
            data_im_in(0)=>data_im_in(0),
            data_im_in(1)=>data_im_in(2),
            data_re_out=>first_stage_re_out(1 downto 0),
            data_im_out=>first_stage_im_out(1 downto 0)
        );

    ULFFT_PT2_1 : fft_pt2
    generic map(
        ctrl_start => ctrl_start
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            bypass=>bypass(1),
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>data_re_in(1),
            data_re_in(1)=>data_re_in(3),
            data_im_in(0)=>data_im_in(1),
            data_im_in(1)=>data_im_in(3),
            data_re_out=>first_stage_re_out(3 downto 2),
            data_im_out=>first_stage_im_out(3 downto 2)
        );


    --- right-hand-side processors
    URFFT_PT2_0 : fft_pt2
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            bypass=>bypass(0),
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(0),
            data_re_in(1)=>mul_re_out(2),
            data_im_in(0)=>mul_im_out(0),
            data_im_in(1)=>mul_im_out(2),
            data_re_out(0)=>data_re_out(0),
            data_re_out(1)=>data_re_out(2),
            data_im_out(0)=>data_im_out(0),
            data_im_out(1)=>data_im_out(2)
        );           

    URFFT_PT2_1 : fft_pt2
    generic map(
        ctrl_start => (ctrl_start+1) mod 16
    )
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            bypass=>bypass(0),
            ctrl_delay=>ctrl_delay,
            data_re_in(0)=>mul_re_out(1),
            data_re_in(1)=>mul_re_out(3),
            data_im_in(0)=>mul_im_out(1),
            data_im_in(1)=>mul_im_out(3),
            data_re_out(0)=>data_re_out(1),
            data_re_out(1)=>data_re_out(3),
            data_im_out(0)=>data_im_out(1),
            data_im_out(1)=>data_im_out(3)
        );           


    --- multipliers
    mul_re_out(2 downto 0) <= first_stage_re_out(2 downto 0);
    mul_im_out(2 downto 0) <= first_stage_im_out(2 downto 0);

    UMUX_RE : mux_in2
    port map(
        sel=>bypass(1),
        data1_in=>first_stage_im_out(3),
        data2_in=>first_stage_re_out(3),
        data_out=>mul_re_out(3)
    );

    UMUX_IM : mux_in2
    port map(
        sel=>bypass(1),
        data1_in=>opp_first_stage_re_out,
        data2_in=>first_stage_im_out(3),
        data_out=>mul_im_out(3)
    );
    
    not_first_stage_re_out <= not first_stage_re_out(3);
    C_BUFF_3 : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c, 
        clk      => clk, 
        preload  => ctrl_delay((ctrl_start+1) mod 16), 
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
