----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:04:54 09/05/2015 
-- Design Name: 
-- Module Name:    Dff - Behavioral 
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

entity Dff_2 is
    Port (D : in  STD_LOGIC;
		   clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end Dff_2;

architecture Behavioral of Dff_2 is

signal tmp: std_logic;
begin

process(clk, rst)
begin
	if rst='1' then
		Q<='0';
        tmp<='0';
	elsif rising_edge(clk) then
        tmp<=D;
		Q<=tmp;
	end if;
end process;

end Behavioral;

