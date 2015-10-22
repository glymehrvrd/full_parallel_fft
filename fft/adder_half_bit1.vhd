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
        data1_in    : IN STD_LOGIC;
        data2_in    : IN STD_LOGIC;
        sum_out  : OUT STD_LOGIC;
        c_out    : OUT STD_LOGIC
    );
END adder_half_bit1;

ARCHITECTURE Behavioral OF adder_half_bit1 IS

BEGIN
    sum_out <= data1_in XOR data2_in;
    c_out <= data1_in AND data2_in;

END Behavioral;

