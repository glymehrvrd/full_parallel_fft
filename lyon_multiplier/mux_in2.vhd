----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:21:36 10/13/2015
-- Design Name:
-- Module Name: mux_in2 - Behavioral
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

ENTITY mux_in2 IS
    PORT (
        sel    : IN STD_LOGIC;

        d1_in  : IN STD_LOGIC;
        d2_in  : IN std_logic;
        d_out  : OUT std_logic
    );
END mux_in2;

ARCHITECTURE Behavioral OF mux_in2 IS

BEGIN
    d_out <= d1_in WHEN sel = '0' ELSE d2_in;

END Behavioral;

