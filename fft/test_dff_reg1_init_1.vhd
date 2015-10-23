--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:38:22 10/19/2015
-- Design Name:
-- Module Name: d:/dell/Documents/ISE Projects/fft/fft/test_dff_reg1_init_1.vhd
-- Project Name: fft
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: Dff_reg1_init_1
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

ENTITY test_dff_reg1_init_1 IS
END test_dff_reg1_init_1;

ARCHITECTURE behavior OF test_dff_reg1_init_1 IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT Dff_reg1_init_1
        PORT (
            D    : IN std_logic;
            clk  : IN std_logic;
            ce   : IN std_logic;
            rst  : IN std_logic;
            Q    : OUT std_logic
        );
    END COMPONENT;
    --Inputs
    SIGNAL D : std_logic := '0';
    SIGNAL clk : std_logic := '0';
    SIGNAL ce : std_logic := '0';
    SIGNAL rst : std_logic := '0';

    --Outputs
    SIGNAL Q : std_logic;

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : Dff_reg1_init_1
    PORT MAP(
        D    => D, 
        clk  => clk, 
        ce   => ce, 
        rst  => rst, 
        Q    => Q
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
        rst <= '0';
        -- hold reset state for 100 ns.
        WAIT FOR 100 ns;
        rst <= '1';
        ce <= '1';
        WAIT FOR clk_period * 10;
        -- insert stimulus here
        D <= '1';
        WAIT FOR clk_period;
        D <= '0';
        WAIT FOR clk_period;
        D <= '1';
        WAIT FOR clk_period;

        WAIT;
    END PROCESS;

    END;
