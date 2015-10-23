--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 09:31:15 10/22/2015
-- Design Name: 
-- Module Name: d:/dell/Documents/ISE Projects/fft/fft/test_fft_pt8.vhd
-- Project Name: fft
-- Target Device: 
-- Tool versions: 
-- Description: 
--
-- VHDL Test Bench Created by ISE for module: fft_pt8
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

ENTITY test_fft_pt8 IS
END test_fft_pt8;

ARCHITECTURE behavior OF test_fft_pt8 IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT fft_pt8
        PORT (
            clk          : IN std_logic;
            rst          : IN std_logic;
            ce           : IN std_logic;
            ctrl         : IN std_logic;
            data_re_in   : IN std_logic_vector(7 DOWNTO 0);
            data_im_in   : IN std_logic_vector(7 DOWNTO 0);
            data_re_out  : OUT std_logic_vector(7 DOWNTO 0);
            data_im_out  : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;
 

    --Inputs
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL ce : std_logic := '0';
    SIGNAL ctrl : std_logic := '0';
    SIGNAL data_re_in : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_im_in : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

    --Outputs
    SIGNAL data_re_out : std_logic_vector(7 DOWNTO 0);
    SIGNAL data_im_out : std_logic_vector(7 DOWNTO 0);

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : fft_pt8
    PORT MAP(
        clk          => clk, 
        rst          => rst, 
        ce           => ce, 
        ctrl         => ctrl, 
        data_re_in   => data_re_in, 
        data_im_in   => data_im_in, 
        data_re_out  => data_re_out, 
        data_im_out  => data_im_out
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
        WAIT FOR 100 ns; 

        WAIT FOR clk_period * 10;

        -- insert stimulus here

        WAIT;
    END PROCESS;

    END;
