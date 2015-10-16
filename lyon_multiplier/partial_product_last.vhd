----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:13:28 10/13/2015 
-- Design Name: 
-- Module Name:    partial_product_last - Behavioral 
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

entity partial_product_last is
 PORT (
        clk, rst, ce  : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC; --进位信号
        d1_in: in std_logic;
        d2_in  : IN STD_LOGIC;--两路数据输入
        d3_in : in std_logic;
        pp_out            : OUT STD_LOGIC --部分积
    );
end partial_product_last;

architecture Behavioral of partial_product_last is

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

component mux_in2 is
port(
    sel: IN STD_LOGIC;

    d1_in: IN STD_LOGIC;
    d2_in:in std_logic;
    d_out:out std_logic
    );
end component;

signal ctrl_delay1: std_logic;

signal d1_in_delay1:std_logic;

signal adder_in1:std_logic;
signal adder_in2:std_logic;

signal adder_c_in:std_logic;
signal c_out:std_logic;
signal c_buff:std_logic;

begin

BUFF_CTRL: Dff_reg1
port map(
    D=>ctrl,
    clk=>clk,
    rst=>rst,
    Q=>ctrl_delay1
    );

BUFF_DIN1: Dff_reg1
port map(
    D=>d1_in,
    clk=>clk,
    rst=>rst,
    Q=>d1_in_delay1
    );

MUX_DIN1: mux_in2
port map(
    sel=>ctrl,
    d1_in=>d1_in,
    d2_in=>d1_in_delay1,
    d_out=>adder_in1
    );

adder_in2<=(not d2_in) and d3_in;

BUFF_C: Dff_reg1
port map(
    D=>c_out,
    clk=>clk,
    rst=>rst,
    Q=>c_buff
    );

MUX_ADDER_C_IN: mux_in2
port map(
    sel=>ctrl_delay1,
    d1_in=>c_buff,
    d2_in=>d3_in,
    d_out=>adder_c_in
    );

ADDER: adder_bit1
port map(
    d1_in=>adder_in1,
    d2_in=>adder_in2,
    c_in=>adder_c_in,
    sum_out=>pp_out,
    c_out=>c_out
    );

end Behavioral;

