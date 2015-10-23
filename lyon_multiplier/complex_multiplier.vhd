library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity complex_multiplier is
    generic (
        re_multiplicator: integer:=-1061;
        im_multiplicator: integer:=-1061
    );
    PORT (
        clk          : IN std_logic;
        rst          : IN std_logic;
        ce           : IN std_logic;
        ctrl         : IN STD_LOGIC;
        data_re_in        : IN std_logic;
        data_im_in        : IN std_logic;
        product_re_out  : OUT STD_LOGIC;
        product_im_out  : OUT STD_LOGIC
    );
end complex_multiplier;

architecture Behavioral of complex_multiplier is

    component lyon_multiplier is
        generic(
            multiplicator : std_logic_vector(15 DOWNTO 0)
        );
        PORT (
            clk          : IN std_logic;
            rst          : IN std_logic;
            ce           : IN std_logic;
            ctrl         : IN STD_LOGIC;
            data_in        : IN std_logic;
            product_out  : OUT STD_LOGIC
        );
    end component;

    COMPONENT adder_bit1 IS
        PORT (
            data1_in    : IN STD_LOGIC;
            data2_in    : IN STD_LOGIC;
            c_in     : IN STD_LOGIC;
            sum_out  : OUT STD_LOGIC;
            c_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_preload_reg1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            rst      : IN STD_LOGIC;
            ce       : IN STD_LOGIC;
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC
        );
    END COMPONENT;

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

----- c+d, a-b
--signal cd,ab:std_logic;
----- b*c, a*d, (c+d)*(a-b)
--signal bc,ad,cdab:std_logic;

    signal ac,bd,bc,ad:std_logic;
    signal not_bd:std_logic;

    SIGNAL c : std_logic_vector(1 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(1 DOWNTO 0);
begin

    --- (a+b*i)*(c+d*i) = (a*c - b*d) + (b*c + a*d)*i = x + y*i
    --- x = (c+d)*(a-b) + (b*c - a*d)
    --- y = (b*c + a*d)
    not_bd<=not bd;
    --- calculate a*c
    UAC : lyon_multiplier
    generic map (multiplicator=>re_multiplicator)
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_in=>data_re_in,
        product_out=>ac
    );

    --- calculate b*d
    UBD : lyon_multiplier
    generic map (multiplicator=>im_multiplicator)
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_in=>data_im_in,
        product_out=>bd
    );

    --- calculate b*c
    UBC : lyon_multiplier
    generic map (multiplicator=>re_multiplicator)
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_in=>data_im_in,
        product_out=>bc
    );

    --- calculate a*d
    UAD : lyon_multiplier
    generic map (multiplicator=>im_multiplicator)
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_in=>data_re_in,
        product_out=>ad
    );

    --- x=ac-bd
    C_BUFF_RE : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(0)
    );

    ADDER_RE : adder_bit1
    PORT MAP(
        data1_in    => ac, 
        data2_in    => not_bd, 
        c_in     => c_buff(0), 
        sum_out  => product_re_out, 
        c_out    => c(0)
    );

    --- y=bc+ad
    C_BUFF_IM : Dff_preload_reg1
    PORT MAP(
        D        => c(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(1)
    );

    ADDER_IM : adder_bit1
    PORT MAP(
        data1_in    => bc, 
        data2_in    => ad, 
        c_in     => c_buff(1), 
        sum_out  => product_im_out, 
        c_out    => c(1)
    );

end Behavioral;
