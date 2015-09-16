----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:56:52 09/05/2015 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( A : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           B : out  STD_LOGIC);
end top;

architecture Behavioral of top is

component Dff is
    Port (D : in  STD_LOGIC;
		   clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end component;

component Dff_init_1 is
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end component;

component Dff_2 is
    Port (D : in  STD_LOGIC;
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

signal data : std_logic_vector(13 downto 1);
signal s: std_logic_vector(4 downto 0);
signal s_buff: std_logic_vector(4 downto 0);
signal c: std_logic_vector(5 downto 0);
signal c_buff: std_logic_vector(5 downto 0);

begin
	D_DATA_1: Dff port map (A, clk, rst, data(1));
  GEN_D_DATA:
	for I in 2 to 13 generate
		DX_DATA : Dff port map (data(I-1), clk, rst, data(I));
	end generate GEN_D_DATA;

  C_BUFF0 : Dff port map(c(0), clk, rst, c_buff(0));
  ADDER0_BUFF : Dff port map (s(0), clk, rst, s_buff(0));
  ADDER0 : one_bit_full_adder port map ('0', data(13), c_buff(0), s(0), c(0));

  C_BUFF1 : Dff port map(c(1), clk, rst, c_buff(1)); 
  ADDER1_BUFF : Dff_2 port map (s(1), clk, rst, s_buff(1));
  ADDER1 : one_bit_full_adder port map (s_buff(0), data(13), c_buff(1), s(1), c(1));

  C_BUFF2 : Dff_init_1 port map(c(2), clk, rst, c_buff(2));
  ADDER2_BUFF : Dff_2 port map (s(2), clk, rst, s_buff(2));
  ADDER2 : one_bit_full_adder port map (s_buff(1), not data(13), c_buff(2), s(2), c(2));

  C_BUFF3 : Dff port map(c(3), clk, rst, c_buff(3));
  ADDER3_BUFF : Dff_2 port map (s(3), clk, rst, s_buff(3));
  ADDER3 : one_bit_full_adder port map (s_buff(2), data(13), c_buff(3), s(3), c(3));

  C_BUFF4 : Dff port map(c(4), clk, rst, c_buff(4));
  ADDER4_BUFF : Dff_6 port map (s(4), clk, rst, s_buff(4));
  ADDER4 : one_bit_full_adder port map (s_buff(3), data(13), c_buff(4), s(4), c(4));

  C_BUFF5 : Dff_init_1 port map(c(5), clk, rst, c_buff(5));
  ADDER5 : one_bit_full_adder port map (s_buff(4), not data(13), c_buff(5), B, c(5));
end Behavioral;

