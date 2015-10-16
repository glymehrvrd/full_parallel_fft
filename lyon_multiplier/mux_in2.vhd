----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:36 10/13/2015 
-- Design Name: 
-- Module Name:    mux_in2 - Behavioral 
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

entity mux_in2 is
port(
    sel: IN STD_LOGIC;

    d1_in: IN STD_LOGIC;
    d2_in:in std_logic;
    d_out:out std_logic
    );
end mux_in2;

architecture Behavioral of mux_in2 is

begin

d_out<=d1_in when sel='0' else d2_in;

end Behavioral;

