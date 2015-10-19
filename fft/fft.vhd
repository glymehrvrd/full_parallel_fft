----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:07:11 10/09/2015
-- Design Name:
-- Module Name: fft_pt2048 - Behavioral
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

ENTITY fft_pt2048 IS
    PORT (
        clk       : IN STD_LOGIC;
        rst       : IN STD_LOGIC;
        ce        : IN STD_LOGIC;
        data_in   : IN STD_LOGIC;
        data_out  : OUT STD_LOGIC
    );
END fft_pt2048;

ARCHITECTURE Behavioral OF fft_pt2048 IS

BEGIN
END Behavioral;

