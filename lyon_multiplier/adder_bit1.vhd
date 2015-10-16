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

entity adder_bit1 is
    Port ( d1_in : in  STD_LOGIC;
           d2_in : in  STD_LOGIC;
           c_in : in STD_LOGIC;
           sum_out : out  STD_LOGIC;
           c_out : out  STD_LOGIC);
end adder_bit1;

architecture Behavioral of adder_bit1 is

component adder_half_bit1 is
    Port ( d1_in : in  STD_LOGIC;
           d2_in : in  STD_LOGIC;
           sum_out : out  STD_LOGIC;
           c_out : out  STD_LOGIC);
end component;

signal c1:std_logic;
signal c2:std_logic;
signal s1:std_logic;

begin

HA1 : adder_half_bit1 port map(d1_in,d2_in,s1,c1);
HA2 : adder_half_bit1 port map(s1,c_in,sum_out,c2);

c_out <= c1 or c2;


end Behavioral;

