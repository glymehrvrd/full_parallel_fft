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
           ctrl : in STD_LOGIC;

           data_0_re_in : in  STD_LOGIC;
           data_0_im_in:in STD_LOGIC;
           data_1_re_in : in  STD_LOGIC;
           data_1_im_in: in STD_LOGIC;

           data_0_re_out : out  STD_LOGIC;
           data_0_im_out:out STD_LOGIC;
           data_1_re_out : out  STD_LOGIC;
           data_1_im_out: out STD_LOGIC);
end fft_pt2;

architecture Behavioral of fft_pt2 is

component adder_bit1 is
      Port ( d1_in : in  STD_LOGIC;
             d2_in : in  STD_LOGIC;
             c_in : in STD_LOGIC;
             sum_out : out  STD_LOGIC;
             c_out : out  STD_LOGIC);
end component;

component Dff_reg1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

component Dff_reg1_init_1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

signal c: std_logic_vector(3 downto 0);
signal c_buff: std_logic_vector(3 downto 0);

begin

--- Re(X[0])=Re(x[0])+Re(x[1])
C_BUFF0_RE : Dff_reg1 port map(
    D=>c(0), 
    clk=>clk, 
    rst=>rst, 
    Q=>c_buff(0));

ADDER0_RE : adder_bit1 port map (
    d1_in=>data_0_re_in,
    d2_in=>data_1_re_in,
    c_in=>c_buff(0),
    sum_out=>data_0_re_out,
    c_out=>c(0));

--- Im(X[0])=Im(x[0])+Im(x[1])
C_BUFF0_IM : Dff_reg1 port map(
    D=>c(1), 
    clk=>clk, 
    rst=>rst, 
    Q=>c_buff(1));

ADDER0_IM : adder_bit1 port map (
    d1_in=>data_0_im_in,
    d2_in=>data_1_im_in,
    c_in=>c_buff(1),
    sum_out=>data_0_im_out,
    c_out=>c(1));

--- Re(X[1])=Re(x[0])-Re(x[1])
C_BUFF1_RE : Dff_reg1_init_1 port map(
    D=>c(2), 
    clk=>clk, 
    rst=>rst, 
    Q=>c_buff(2));

ADDER1_RE : adder_bit1 port map (
    d1_in=>data_0_re_in,
    d2_in=>(not data_1_re_in),
    c_in=>c_buff(2),
    sum_out=>data_1_re_out,
    c_out=>c(2));

--- Im(X[1])=Im(x[0])-Im(x[1])
C_BUFF1_IM : Dff_reg1_init_1 port map(
    D=>c(3), 
    clk=>clk, 
    rst=>rst, 
    Q=>c_buff(3));

ADDER1_IM : adder_bit1 port map (
    d1_in=>data_0_im_in,
    d2_in=>(not data_1_im_in),
    c_in=>c_buff(3),
    sum_out=>data_1_im_out,
    c_out=>c(3));


end Behavioral;

