----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:07:53 10/09/2015 
-- Design Name: 
-- Module Name:    fft_pt4 - Behavioral 
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

entity fft_pt4 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ctrl : in STD_LOGIC;

           data_0_re_in : in  STD_LOGIC;
           data_0_im_in:in STD_LOGIC;
           data_1_re_in : in  STD_LOGIC;
           data_1_im_in: in STD_LOGIC;
           data_2_re_in : in  STD_LOGIC;
           data_2_im_in:in STD_LOGIC;
           data_3_re_in : in  STD_LOGIC;
           data_3_im_in: in STD_LOGIC;

           data_0_re_out : out  STD_LOGIC;
           data_0_im_out:out STD_LOGIC;
           data_1_re_out : out  STD_LOGIC;
           data_1_im_out: out STD_LOGIC;
           data_2_re_out : out  STD_LOGIC;
           data_2_im_out:out STD_LOGIC;
           data_3_re_out : out  STD_LOGIC;
           data_3_im_out: out STD_LOGIC);
end fft_pt4;

architecture Behavioral of fft_pt4 is

component adder_bit1 is
      Port ( d1_in : in  STD_LOGIC;
             d2_in : in  STD_LOGIC;
             c_in : in STD_LOGIC;
             sum_out : out  STD_LOGIC;
             c_out : out  STD_LOGIC);
end component;

component Dff_preload_reg1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
           preload: in STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

component Dff_preload_reg1_init_1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
           preload: in STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

signal c_re_0: std_logic_vector(3 downto 0);
signal c_buff_re_0: std_logic_vector(3 downto 0);
signal s_re_0: std_logic_vector(2 downto 0);

signal c_im_0: std_logic_vector(3 downto 0);
signal c_buff_im_0: std_logic_vector(3 downto 0);
signal s_im_0: std_logic_vector(2 downto 0);

signal c_re_1: std_logic_vector(3 downto 0);
signal c_buff_re_1: std_logic_vector(3 downto 0);
signal s_re_1: std_logic_vector(2 downto 0);

signal c_im_1: std_logic_vector(3 downto 0);
signal c_buff_im_1: std_logic_vector(3 downto 0);
signal s_im_1: std_logic_vector(2 downto 0);

signal c_re_2: std_logic_vector(3 downto 0);
signal c_buff_re_2: std_logic_vector(3 downto 0);
signal s_re_2: std_logic_vector(2 downto 0);

signal c_im_2: std_logic_vector(3 downto 0);
signal c_buff_im_2: std_logic_vector(3 downto 0);
signal s_im_2: std_logic_vector(2 downto 0);

signal c_re_3: std_logic_vector(3 downto 0);
signal c_buff_re_3: std_logic_vector(3 downto 0);
signal s_re_3: std_logic_vector(2 downto 0);

signal c_im_3: std_logic_vector(3 downto 0);
signal c_buff_im_3: std_logic_vector(3 downto 0);
signal s_im_3: std_logic_vector(2 downto 0);

signal not_data_0_re_in:STD_LOGIC;
signal not_data_0_im_in:STD_LOGIC;
signal not_data_1_re_in:STD_LOGIC;
signal not_data_1_im_in:STD_LOGIC;
signal not_data_2_re_in:STD_LOGIC;
signal not_data_2_im_in:STD_LOGIC;
signal not_data_3_re_in:STD_LOGIC;
signal not_data_3_im_in:STD_LOGIC;

begin

not_data_0_re_in<=not data_0_re_in;
not_data_0_im_in<=not data_0_im_in;
not_data_1_re_in<=not data_1_re_in;
not_data_1_im_in<=not data_1_im_in;
not_data_2_re_in<=not data_2_re_in;
not_data_2_im_in<=not data_2_im_in;
not_data_3_re_in<=not data_3_re_in;
not_data_3_im_in<=not data_3_im_in;

--- Re(X[0])=Re(x[0])+Re(x[1])+Re(x[2])+Re(x[3])
C_BUFF0_RE_0 : Dff_preload_reg1 port map(
    D=>c_re_0(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_0(0));
ADDER0_RE_0 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_re_in,
    c_in=>c_buff_re_0(0),
    sum_out=>s_re_0(0),
    c_out=>c_re_0(0));

C_BUFF1_RE_0 : Dff_preload_reg1 port map(
    D=>c_re_0(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_0(1));
ADDER1_RE_0 : adder_bit1 port map (
    d1_in=>s_re_0(0),
    d2_in=>data_1_re_in,
    c_in=>c_buff_re_0(1),
    sum_out=>s_re_0(1),
    c_out=>c_re_0(1));

C_BUFF2_RE_0 : Dff_preload_reg1 port map(
    D=>c_re_0(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_0(2));
ADDER2_RE_0 : adder_bit1 port map (
    d1_in=>s_re_0(1),
    d2_in=>data_2_re_in,
    c_in=>c_buff_re_0(2),
    sum_out=>s_re_0(2),
    c_out=>c_re_0(2));

C_BUFF3_RE_0 : Dff_preload_reg1 port map(
    D=>c_re_0(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_0(3));
ADDER3_RE_0 : adder_bit1 port map (
    d1_in=>s_re_0(2),
    d2_in=>data_3_re_in,
    c_in=>c_buff_re_0(3),
    sum_out=>data_0_re_out,
    c_out=>c_re_0(3));

--- Im(X[0])=Im(x[0])+Im(x[1])+Im(x[2])+Im(x[3])
C_BUFF0_IM_0 : Dff_preload_reg1 port map(
    D=>c_im_0(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_0(0));
ADDER0_IM_0 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_im_in,
    c_in=>c_buff_im_0(0),
    sum_out=>s_im_0(0),
    c_out=>c_im_0(0));

C_BUFF1_IM_0 : Dff_preload_reg1 port map(
    D=>c_im_0(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_0(1));
ADDER1_IM_0 : adder_bit1 port map (
    d1_in=>s_im_0(0),
    d2_in=>data_1_im_in,
    c_in=>c_buff_im_0(1),
    sum_out=>s_im_0(1),
    c_out=>c_im_0(1));

C_BUFF2_IM_0 : Dff_preload_reg1 port map(
    D=>c_im_0(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_0(2));
ADDER2_IM_0 : adder_bit1 port map (
    d1_in=>s_im_0(1),
    d2_in=>data_2_im_in,
    c_in=>c_buff_im_0(2),
    sum_out=>s_im_0(2),
    c_out=>c_im_0(2));

C_BUFF3_IM_0 : Dff_preload_reg1 port map(
    D=>c_im_0(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_0(3));
ADDER3_IM_0 : adder_bit1 port map (
    d1_in=>s_im_0(2),
    d2_in=>data_3_im_in,
    c_in=>c_buff_im_0(3),
    sum_out=>data_0_im_out,
    c_out=>c_im_0(3));

--- Re(X[1])=Re(x[0])+Im(x[1])-Re(x[2])-Im(x[3])
C_BUFF0_RE_1 : Dff_preload_reg1 port map(
    D=>c_re_1(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_1(0));
ADDER0_RE_1 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_re_in,
    c_in=>c_buff_re_1(0),
    sum_out=>s_re_1(0),
    c_out=>c_re_1(0));

C_BUFF1_RE_1 : Dff_preload_reg1 port map(
    D=>c_re_1(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_1(1));
ADDER1_RE_1 : adder_bit1 port map (
    d1_in=>s_re_1(0),
    d2_in=>data_1_im_in,
    c_in=>c_buff_re_1(1),
    sum_out=>s_re_1(1),
    c_out=>c_re_1(1));

C_BUFF2_RE_1 : Dff_preload_reg1_init_1 port map(
    D=>c_re_1(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_1(2));
ADDER2_RE_1 : adder_bit1 port map (
    d1_in=>s_re_1(1),
    d2_in=>not_data_2_re_in,
    c_in=>c_buff_re_1(2),
    sum_out=>s_re_1(2),
    c_out=>c_re_1(2));

C_BUFF3_RE_1 : Dff_preload_reg1_init_1 port map(
    D=>c_re_1(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_1(3));
ADDER3_RE_1 : adder_bit1 port map (
    d1_in=>s_re_1(2),
    d2_in=>not_data_3_im_in,
    c_in=>c_buff_re_1(3),
    sum_out=>data_1_re_out,
    c_out=>c_re_1(3));

--- Im(X[1])=Im(x[0])-Re(x[1])-Im(x[2])+Re(x[3])
C_BUFF0_IM_1 : Dff_preload_reg1 port map(
    D=>c_im_1(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_1(0));
ADDER0_IM_1 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_im_in,
    c_in=>c_buff_im_1(0),
    sum_out=>s_im_1(0),
    c_out=>c_im_1(0));

C_BUFF1_IM_1 : Dff_preload_reg1_init_1 port map(
    D=>c_im_1(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_1(1));
ADDER1_IM_1 : adder_bit1 port map (
    d1_in=>s_im_1(0),
    d2_in=>not_data_1_re_in,
    c_in=>c_buff_im_1(1),
    sum_out=>s_im_1(1),
    c_out=>c_im_1(1));

C_BUFF2_IM_1 : Dff_preload_reg1_init_1 port map(
    D=>c_im_1(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_1(2));
ADDER2_IM_1 : adder_bit1 port map (
    d1_in=>s_im_1(1),
    d2_in=>not_data_2_im_in,
    c_in=>c_buff_im_1(2),
    sum_out=>s_im_1(2),
    c_out=>c_im_1(2));

C_BUFF3_IM_1 : Dff_preload_reg1 port map(
    D=>c_im_1(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_1(3));
ADDER3_IM_1 : adder_bit1 port map (
    d1_in=>s_im_1(2),
    d2_in=>data_3_re_in,
    c_in=>c_buff_im_1(3),
    sum_out=>data_1_im_out,
    c_out=>c_im_1(3));

--- Re(X[2])=Re(x[0])-Re(x[1])+Re(x[2])-Re(x[3])
C_BUFF0_RE_2 : Dff_preload_reg1 port map(
    D=>c_re_2(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_2(0));
ADDER0_RE_2 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_re_in,
    c_in=>c_buff_re_2(0),
    sum_out=>s_re_2(0),
    c_out=>c_re_2(0));

C_BUFF1_RE_2 : Dff_preload_reg1_init_1 port map(
    D=>c_re_2(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_2(1));
ADDER1_RE_2 : adder_bit1 port map (
    d1_in=>s_re_2(0),
    d2_in=>not_data_1_re_in,
    c_in=>c_buff_re_2(1),
    sum_out=>s_re_2(1),
    c_out=>c_re_2(1));

C_BUFF2_RE_2 : Dff_preload_reg1 port map(
    D=>c_re_2(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_2(2));
ADDER2_RE_2 : adder_bit1 port map (
    d1_in=>s_re_2(1),
    d2_in=>data_2_re_in,
    c_in=>c_buff_re_2(2),
    sum_out=>s_re_2(2),
    c_out=>c_re_2(2));

C_BUFF3_RE_2 : Dff_preload_reg1_init_1 port map(
    D=>c_re_2(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_2(3));
ADDER3_RE_2 : adder_bit1 port map (
    d1_in=>s_re_2(2),
    d2_in=>not_data_3_re_in,
    c_in=>c_buff_re_2(3),
    sum_out=>data_2_re_out,
    c_out=>c_re_2(3));

--- Im(X[2])=Im(x[0])-Im(x[1])+Im(x[2])-Im(x[3])
C_BUFF0_IM_2 : Dff_preload_reg1 port map(
    D=>c_im_2(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_2(0));
ADDER0_IM_2 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_im_in,
    c_in=>c_buff_im_2(0),
    sum_out=>s_im_2(0),
    c_out=>c_im_2(0));

C_BUFF1_IM_2 : Dff_preload_reg1_init_1 port map(
    D=>c_im_2(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_2(1));
ADDER1_IM_2 : adder_bit1 port map (
    d1_in=>s_im_2(0),
    d2_in=>not_data_1_im_in,
    c_in=>c_buff_im_2(1),
    sum_out=>s_im_2(1),
    c_out=>c_im_2(1));

C_BUFF2_IM_2 : Dff_preload_reg1 port map(
    D=>c_im_2(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_2(2));
ADDER2_IM_2 : adder_bit1 port map (
    d1_in=>s_im_2(1),
    d2_in=>data_2_im_in,
    c_in=>c_buff_im_2(2),
    sum_out=>s_im_2(2),
    c_out=>c_im_2(2));

C_BUFF3_IM_2 : Dff_preload_reg1_init_1 port map(
    D=>c_im_2(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_2(3));
ADDER3_IM_2 : adder_bit1 port map (
    d1_in=>s_im_2(2),
    d2_in=>not_data_3_im_in,
    c_in=>c_buff_im_2(3),
    sum_out=>data_2_im_out,
    c_out=>c_im_2(3));

--- Re(X[3])=Re(x[0])-Im(x[1])-Re(x[2])+Im(x[3])
C_BUFF0_RE_3 : Dff_preload_reg1 port map(
    D=>c_re_3(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_3(0));
ADDER0_RE_3 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_re_in,
    c_in=>c_buff_re_3(0),
    sum_out=>s_re_3(0),
    c_out=>c_re_3(0));

C_BUFF1_RE_3 : Dff_preload_reg1_init_1 port map(
    D=>c_re_3(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_3(1));
ADDER1_RE_3 : adder_bit1 port map (
    d1_in=>s_re_3(0),
    d2_in=>not_data_1_im_in,
    c_in=>c_buff_re_3(1),
    sum_out=>s_re_3(1),
    c_out=>c_re_3(1));

C_BUFF2_RE_3 : Dff_preload_reg1_init_1 port map(
    D=>c_re_3(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_3(2));
ADDER2_RE_3 : adder_bit1 port map (
    d1_in=>s_re_3(1),
    d2_in=>not_data_2_re_in,
    c_in=>c_buff_re_3(2),
    sum_out=>s_re_3(2),
    c_out=>c_re_3(2));

C_BUFF3_RE_3 : Dff_preload_reg1 port map(
    D=>c_re_3(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_re_3(3));
ADDER3_RE_3 : adder_bit1 port map (
    d1_in=>s_re_3(2),
    d2_in=>data_3_im_in,
    c_in=>c_buff_re_3(3),
    sum_out=>data_3_re_out,
    c_out=>c_re_3(3));

--- Im(X[3])=Im(x[0])+Re(X[1])-Im(x[2])-Re(X[3])
C_BUFF0_IM_3 : Dff_preload_reg1 port map(
    D=>c_im_3(0), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_3(0));
ADDER0_IM_3 : adder_bit1 port map (
    d1_in=>'0',
    d2_in=>data_0_im_in,
    c_in=>c_buff_im_3(0),
    sum_out=>s_im_3(0),
    c_out=>c_im_3(0));

C_BUFF1_IM_3 : Dff_preload_reg1 port map(
    D=>c_im_3(1), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_3(1));
ADDER1_IM_3 : adder_bit1 port map (
    d1_in=>s_im_3(0),
    d2_in=>data_1_re_in,
    c_in=>c_buff_im_3(1),
    sum_out=>s_im_3(1),
    c_out=>c_im_3(1));

C_BUFF2_IM_3 : Dff_preload_reg1_init_1 port map(
    D=>c_im_3(2), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_3(2));
ADDER2_IM_3 : adder_bit1 port map (
    d1_in=>s_im_3(1),
    d2_in=>not_data_2_im_in,
    c_in=>c_buff_im_3(2),
    sum_out=>s_im_3(2),
    c_out=>c_im_3(2));

C_BUFF3_IM_3 : Dff_preload_reg1_init_1 port map(
    D=>c_im_3(3), 
    clk=>clk, 
    rst=>rst, 
    preload=>ctrl,
    Q=>c_buff_im_3(3));
ADDER3_IM_3 : adder_bit1 port map (
    d1_in=>s_im_3(2),
    d2_in=>not_data_3_re_in,
    c_in=>c_buff_im_3(3),
    sum_out=>data_3_im_out,
    c_out=>c_im_3(3));


end Behavioral;

