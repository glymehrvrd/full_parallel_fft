----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:52:03 09/06/2015 
-- Design Name: 
-- Module Name:    Dff_6 - Behavioral 
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

entity Dff_6 is
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end Dff_6;

architecture Behavioral of Dff_6 is

signal reg: std_logic_vector(5 downto 0);
begin

Q<= reg(5);

process(clk,rst)
begin
	if rst='1' then
		reg<=(others=>'0');
	elsif rising_edge(clk) then
		reg<=reg(4 downto 0) & D;
	end if;
end process;

end Behavioral;

