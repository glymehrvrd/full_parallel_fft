----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:59:24 09/05/2015 
-- Design Name: 
-- Module Name:    one_bit_adder - Behavioral 
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

entity one_bit_full_adder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           C_IN : in STD_LOGIC;
           S : out  STD_LOGIC;
           C_OUT : out  STD_LOGIC);
end one_bit_full_adder;

architecture Behavioral of one_bit_full_adder is

component one_bit_adder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           S : out  STD_LOGIC;
           C : out  STD_LOGIC);
end component;

signal c1:std_logic;
signal c2:std_logic;
signal s1:std_logic;

begin

HA1 : one_bit_adder port map(A,B,s1,c1);
HA2 : one_bit_adder port map(s1,C_IN,S,c2);

C_OUT <= c1 or c2;


end Behavioral;

