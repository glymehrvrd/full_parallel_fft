LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY multiplier_mul1 IS
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
        data_re_out  : OUT STD_LOGIC;
        data_im_out  : OUT STD_LOGIC
    );
END multiplier_mul1;

ARCHITECTURE Behavioral OF multiplier_mul1 IS

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

signal shifter_re,shifter_im:STD_LOGIC;

BEGIN

    UDELAY_RE : Dff_regN
    generic map(N=>15)
    port map(
            D=>data_re_in,
            clk=>clk,
            Q=>shifter_re
        );
    UDELAY_IM : Dff_regN
    generic map(N=>15)
    port map(
            D=>data_im_in,
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
            data_out=>data_re_out
        );
    USHIFTER_IM: shifter
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            ctrl=>ctrl_delay(ctrl_start),
            data_in=>shifter_im,
            data_out=>data_im_out
        );

END Behavioral;
