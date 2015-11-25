LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY multiplier_mulminusj IS
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
END multiplier_mulminusj;

ARCHITECTURE Behavioral OF multiplier_mulminusj IS

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

signal not_data_re_in: STD_LOGIC;
signal opp_data_re_in: STD_LOGIC;
signal c,c_buff: STD_LOGIC;
signal shifter_re,shifter_im:STD_LOGIC;

BEGIN

    not_data_re_in <= not data_re_in;
    UC_BUFF : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c, 
        clk      => clk, 
        preload  => ctrl_delay(ctrl_start), 
        Q        => c_buff
    );
    ADDER : adder_half_bit1
    PORT MAP(
        data1_in  => c_buff, 
        data2_in  => not_data_re_in, 
        sum_out   => opp_data_re_in, 
        c_out     => c
    );
    UDELAY_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>data_im_in,
            clk=>clk,
            Q=>shifter_re
        );
    UDELAY_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>opp_data_re_in,
            clk=>clk,
            Q=>shifter_im
        );
    USHIFTER_RE: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(ctrl_start),
            data_in=>shifter_re,
            data_out=>product_re_out
        );
    USHIFTER_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(ctrl_start),
            data_in=>shifter_im,
            data_out=>product_im_out
        );

END Behavioral;
