--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16:31:49 10/14/2015
-- Design Name: 
-- Module Name: d:/dell/Documents/ISE Projects/lyon_multiplier/test_lyon_multiplier.vhd
-- Project Name: lyon_multiplier
-- Target Device: 
-- Tool versions: 
-- Description: 
--
-- VHDL Test Bench Created by ISE for module: lyon_multiplier
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

ENTITY test_lyon_multiplier IS
END test_lyon_multiplier;

ARCHITECTURE behavior OF test_lyon_multiplier IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT lyon_multiplier
        PORT (
            clk          : IN std_logic;
            rst          : IN std_logic;
            ce           : IN std_logic;
            ctrl         : IN std_logic;
            data1_in        : IN std_logic;
            product_out  : OUT std_logic
        );
    END COMPONENT;
 

    --Inputs
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL ce : std_logic := '0';
    SIGNAL ctrl : std_logic := '0';
    SIGNAL data1_in : std_logic := '0';

    --Outputs
    SIGNAL product_out : std_logic;

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : lyon_multiplier
    PORT MAP(
        clk          => clk, 
        rst          => rst, 
        ce           => ce, 
        ctrl         => ctrl, 
        data1_in        => data1_in, 
        product_out  => product_out
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    ctrl_proc : PROCESS
    BEGIN
        ctrl <= '0';
        WAIT FOR 95 ns;
        WAIT FOR clk_period * 10;
        LOOP
        ctrl <= '1';
        WAIT FOR clk_period;
        ctrl <= '0';
        WAIT FOR clk_period * 15;
    END LOOP;
END PROCESS;

-- Stimulus process
stim_proc : PROCESS
BEGIN
    -- hold reset state for 100 ns.
    rst <= '0';
    ce <= '0';
    WAIT FOR 95 ns;
    rst <= '1';
    ce <= '1';
    WAIT FOR clk_period * 10;
    -- insert stimulus here

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '0';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;

    data1_in <= '1';
    WAIT FOR clk_period;
 
    data1_in <= '0';
    WAIT;
END PROCESS;

END;
