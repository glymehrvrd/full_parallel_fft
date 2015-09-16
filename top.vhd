library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
      Port ( A : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             B : out  STD_LOGIC);
end top;

architecture Behavioral of top is

component Dff_1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

component Dff_1_init_1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

component Dff_2 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

component Dff_6 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;


component one_bit_full_adder is
      Port ( A : in  STD_LOGIC;
             B : in  STD_LOGIC;
             C_IN : in STD_LOGIC;
             S : out  STD_LOGIC;
             C_OUT : out  STD_LOGIC);
end component;

signal data : std_logic_vector(13 downto 0);
signal s: std_logic_vector(4 downto 0);
signal s_buff: std_logic_vector(4 downto 0);
signal c: std_logic_vector(5 downto 0);
signal c_buff: std_logic_vector(5 downto 0);

begin
    --- shift register of length k
    D_DATA_1: Dff_1 port map (A, clk, rst, data(0));
    GEN_D_DATA:
    for I in 1 to 13 generate
        DX_DATA : Dff_1 port map (data(I-1), clk, rst, data(I));
    end generate GEN_D_DATA;

    C_BUFF0 : Dff_1_init_1 port map(c(0), clk, rst, c_buff(0));
    ADDER0 : one_bit_full_adder port map ('0', not A, c_buff(0), s(0), c(0));

    C_BUFF1 : Dff_1 port map(c(1), clk, rst, c_buff(1));
    ADDER1 : one_bit_full_adder port map (s(0), data(6), c_buff(1), s(1), c(1));

    C_BUFF2 : Dff_1 port map(c(2), clk, rst, c_buff(2));
    ADDER2 : one_bit_full_adder port map (s(1), data(8), c_buff(2), s(2), c(2));

    C_BUFF3 : Dff_1_init_1 port map(c(3), clk, rst, c_buff(3));
    ADDER3 : one_bit_full_adder port map (s(2), not data(10), c_buff(3), s(3), c(3));

    C_BUFF4 : Dff_1 port map(c(4), clk, rst, c_buff(4));
    ADDER4 : one_bit_full_adder port map (s(3), data(12), c_buff(4), s(4), c(4));

    C_BUFF5 : Dff_1 port map(c(5), clk, rst, c_buff(5));
    ADDER5 : one_bit_full_adder port map (s(4), data(13), c_buff(5), B, c(5));

end Behavioral;
