----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:56:56 10/14/2015
-- Design Name:
-- Module Name: lyon_multiplier - Behavioral
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

ENTITY lyon_multiplier IS
    PORT (
        clk          : IN std_logic;
        rst          : IN std_logic;
        ce           : IN std_logic;
        ctrl         : IN STD_LOGIC;
        d1_in        : IN std_logic;
        product_out  : OUT STD_LOGIC
    );
END lyon_multiplier;

ARCHITECTURE Behavioral OF lyon_multiplier IS

    COMPONENT partial_product IS
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
    END COMPONENT;

    COMPONENT partial_product_last IS
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
    END COMPONENT;

    SIGNAL d1_in_delay : std_logic_vector(15 DOWNTO 0);
    SIGNAL ctrl_delay : std_logic_vector(14 DOWNTO 0);

    SIGNAL pp : std_logic_vector(15 DOWNTO 0);

    CONSTANT multiplicator : std_logic_vector(15 DOWNTO 0) := "1111101111011011";

BEGIN
    d1_in_delay(0) <= d1_in;
    --- buffer for d1_in
    PROCESS (clk, rst, ce, d1_in)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                d1_in_delay(15 DOWNTO 1) <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                d1_in_delay(15 DOWNTO 1) <= d1_in_delay(14 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;

    ctrl_delay(0) <= ctrl;
    --- buffer for ctrl
    PROCESS (clk, rst, ce, ctrl)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                ctrl_delay(14 DOWNTO 1) <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                ctrl_delay(14 DOWNTO 1) <= ctrl_delay(13 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;

    pp(0) <= multiplicator(0) AND d1_in;

    GEN_PP : 
    FOR I IN 0 TO 13 GENERATE
        PPX : partial_product
        PORT MAP(
            clk     => clk, 
            rst     => rst, 
            ce      => ce, 
            d1_in   => pp(I), 
            d2_in   => d1_in_delay(I + 1), 
            d3_in   => multiplicator(I + 1), 
            ctrl    => ctrl_delay(I), 
            pp_out  => pp(I + 1)
        );
    END GENERATE;

    PP_LAST : partial_product_last
    PORT MAP(
        clk     => clk, 
        rst     => rst, 
        ce      => ce, 
        d1_in   => pp(14), 
        d2_in   => d1_in_delay(15), 
        d3_in   => multiplicator(15), 
        ctrl    => ctrl_delay(14), 
        pp_out  => pp(15)
    );

    --- output
    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                product_out <= '0';
            ELSIF ce = '1' THEN
                product_out <= pp(15);
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
