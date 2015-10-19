----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 22:59:24 09/05/2015
-- Design Name:
-- Module Name: adder_half_bit1 - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY adder_half_bit1 IS
    PORT (
        d1_in    : IN STD_LOGIC;
        d2_in    : IN STD_LOGIC;
        sum_out  : OUT STD_LOGIC;
        c_out    : OUT STD_LOGIC
    );
END adder_half_bit1;

ARCHITECTURE Behavioral OF adder_half_bit1 IS

BEGIN
    sum_out <= d1_in XOR d2_in;
    c_out <= d1_in AND d2_in;

END Behavioral;

