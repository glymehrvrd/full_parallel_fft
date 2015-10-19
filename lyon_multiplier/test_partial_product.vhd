--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:53:08 10/13/2015
-- Design Name: 
-- Module Name: d:/dell/Documents/ISE Projects/lyon_multiplier/test_partial_product.vhd
-- Project Name: lyon_multiplier
-- Target Device: 
-- Tool versions: 
-- Description: 
--
-- VHDL Test Bench Created by ISE for module: partial_product
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test. Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY test_partial_product IS
END test_partial_product;

ARCHITECTURE behavior OF test_partial_product IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT partial_product
        PORT (
            clk     : IN std_logic;
            rst     : IN std_logic;
            ce      : IN std_logic;
            ctrl    : IN std_logic;
            d1_in   : IN std_logic;
            d2_in   : IN std_logic;
            d3_in   : IN std_logic;
            pp_out  : OUT std_logic
        );
    END COMPONENT;
 
    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            rst  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC
        );
    END COMPONENT;

    --Inputs
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL ce : std_logic := '0';
    SIGNAL ctrl : std_logic := '0';
    SIGNAL d1_in : std_logic := '0';
    SIGNAL d2_in : std_logic := '0';
    SIGNAL d3_in : std_logic := '1';

    SIGNAL ctrl_buff : std_logic;
    SIGNAL d1_in_buff : std_logic;
    --Outputs
    SIGNAL pp_out : std_logic;

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    D1 : Dff_reg1
    PORT MAP(
        D    => ctrl, 
        clk  => clk, 
        rst  => rst, 
        Q    => ctrl_buff
    );
    D2 : Dff_reg1
    PORT MAP(
        D    => d1_in, 
        clk  => clk, 
        rst  => rst, 
        Q    => d1_in_buff
    );
    -- Instantiate the Unit Under Test (UUT)
    uut : partial_product
    PORT MAP(
        clk     => clk, 
        rst     => rst, 
        ce      => ce, 
        ctrl    => ctrl_buff, 
        d1_in   => d1_in_buff, 
        d2_in   => d2_in, 
        d3_in   => d3_in, 
        pp_out  => pp_out
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns.
        rst <= '0';
        ce <= '0';
        ctrl <= '0';
        WAIT FOR 95 ns; 
        rst <= '1';
        ce <= '1';
        WAIT FOR clk_period * 10;
        -- insert stimulus here
        d1_in <= '0';
        d2_in <= '1';
        ctrl <= '1';
        WAIT FOR clk_period;

        d1_in <= '0';
        d2_in <= '0';
        ctrl <= '0';
        WAIT FOR clk_period;
 
        d1_in <= '1';
        d2_in <= '0';
        ctrl <= '0';
        WAIT FOR clk_period;
 
        d1_in <= '0';
        d2_in <= '0';
        ctrl <= '0';
        WAIT FOR clk_period;
 
        d1_in <= '1';
        d2_in <= '1';
        ctrl <= '1';
        WAIT FOR clk_period;
 
        d1_in <= '0';
        d2_in <= '1';
        ctrl <= '0';
        WAIT FOR clk_period;

        d1_in <= '1';
        d2_in <= '0';
        ctrl <= '0';
        WAIT FOR clk_period;

        d1_in <= '0';
        d2_in <= '0';
        ctrl <= '0';
        WAIT FOR clk_period;
        WAIT;
    END PROCESS;

    END;
