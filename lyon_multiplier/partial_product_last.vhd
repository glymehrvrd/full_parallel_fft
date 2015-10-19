----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:13:28 10/13/2015
-- Design Name:
-- Module Name: partial_product_last - Behavioral
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

ENTITY partial_product_last IS
    PORT (
        clk     : IN std_logic;
        rst     : IN std_logic;
        ce      : IN std_logic;
        ctrl    : IN STD_LOGIC; --进位信号
        d1_in   : IN std_logic;
        d2_in   : IN STD_LOGIC;--两路数据输入
        d3_in   : IN std_logic;
        pp_out  : OUT STD_LOGIC --部分积
    );
END partial_product_last;

ARCHITECTURE Behavioral OF partial_product_last IS

    COMPONENT adder_bit1 IS
        PORT (
            d1_in    : IN STD_LOGIC;
            d2_in    : IN STD_LOGIC;
            c_in     : IN STD_LOGIC;
            sum_out  : OUT STD_LOGIC;
            c_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            rst  : IN STD_LOGIC;
            ce   : IN STD_LOGIC;
            Q    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mux_in2 IS
        PORT (
            sel    : IN STD_LOGIC;

            d1_in  : IN STD_LOGIC;
            d2_in  : IN std_logic;
            d_out  : OUT std_logic
        );
    END COMPONENT;

    SIGNAL ctrl_delay1 : std_logic;

    SIGNAL d1_in_delay1 : std_logic;

    SIGNAL adder_in1 : std_logic;
    SIGNAL adder_in2 : std_logic;

    SIGNAL adder_c_in : std_logic;
    SIGNAL c_out : std_logic;
    SIGNAL c_buff : std_logic;

BEGIN
    BUFF_CTRL : Dff_reg1
    PORT MAP(
        D    => ctrl, 
        clk  => clk, 
        rst  => rst, 
        ce   => ce, 
        Q    => ctrl_delay1
    );

    BUFF_DIN1 : Dff_reg1
    PORT MAP(
        D    => d1_in, 
        clk  => clk, 
        rst  => rst, 
        ce   => ce, 
        Q    => d1_in_delay1
    );

    MUX_DIN1 : mux_in2
    PORT MAP(
        sel    => ctrl, 
        d1_in  => d1_in, 
        d2_in  => d1_in_delay1, 
        d_out  => adder_in1
    );

    adder_in2 <= (NOT d2_in) AND d3_in;

    BUFF_C : Dff_reg1
    PORT MAP(
        D    => c_out, 
        clk  => clk, 
        rst  => rst, 
        ce   => ce, 
        Q    => c_buff
    );

    MUX_ADDER_C_IN : mux_in2
    PORT MAP(
        sel    => ctrl_delay1, 
        d1_in  => c_buff, 
        d2_in  => d3_in, 
        d_out  => adder_c_in
    );

    ADDER : adder_bit1
    PORT MAP(
        d1_in    => adder_in1, 
        d2_in    => adder_in2, 
        c_in     => adder_c_in, 
        sum_out  => pp_out, 
        c_out    => c_out
    );

END Behavioral;

