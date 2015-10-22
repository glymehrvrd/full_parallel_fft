----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 22:59:24 09/05/2015
-- Design Name:
-- Module Name: one_bit_adder - Behavioral
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

ENTITY adder_bit1 IS
    PORT (
        data1_in    : IN STD_LOGIC;
        data2_in    : IN STD_LOGIC;
        c_in     : IN STD_LOGIC;
        sum_out  : OUT STD_LOGIC;
        c_out    : OUT STD_LOGIC
    );
END adder_bit1;

ARCHITECTURE Behavioral OF adder_bit1 IS

    COMPONENT adder_half_bit1 IS
        PORT (
            data1_in    : IN STD_LOGIC;
            data2_in    : IN STD_LOGIC;
            sum_out  : OUT STD_LOGIC;
            c_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL c1 : std_logic;
    SIGNAL c2 : std_logic;
    SIGNAL s1 : std_logic;

BEGIN
    HA1 : adder_half_bit1
    PORT MAP(data1_in, data2_in, s1, c1);
    HA2 : adder_half_bit1
    PORT MAP(s1, c_in, sum_out, c2);

    c_out <= c1 OR c2;
END Behavioral;

