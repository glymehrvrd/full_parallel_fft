----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:59:24 09/05/2015 
-- Design Name: 
-- Module Name:    adder_half_bit1 - Behavioral 
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

entity adder_half_bit1 is
    Port ( d1_in : in  STD_LOGIC;
           d2_in : in  STD_LOGIC;
           sum_out : out  STD_LOGIC;
           c_out : out  STD_LOGIC);
end adder_half_bit1;

architecture Behavioral of adder_half_bit1 is

begin

sum_out<=d1_in xor d2_in;
c_out<=d1_in and d2_in;

end Behavioral;

