----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:10:51 10/09/2015 
-- Design Name: 
-- Module Name:    fft_pt2 - Behavioral 
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

entity fft_pt2 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           data_1_re_in : in  STD_LOGIC;
           data_1_img_in:in STD_LOGIC;
           data_1_re_out : out  STD_LOGIC;
           data_1_img_out:out STD_LOGIC;

           data_2_re_in : in  STD_LOGIC;
            data_2_img_in: in STD_LOGIC;
           data_2_re_out : out  STD_LOGIC;
            data_2_img_out: out STD_LOGIC);
end fft_pt2;

architecture Behavioral of fft_pt2 is

component adder_bit1 is
      Port ( d_in1 : in  STD_LOGIC;
             d_in2 : in  STD_LOGIC;
             c_in : in STD_LOGIC;
             sum_out : out  STD_LOGIC;
             c_out : out  STD_LOGIC);
end component;

begin

ADDER{{ i }} : adder_bit1 port map (
    d_in1=>data_1_re_in,
    d_in2=>data_2_re_in,
    


end Behavioral;

