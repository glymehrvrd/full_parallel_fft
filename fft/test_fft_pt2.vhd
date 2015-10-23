--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 20:36:58 10/19/2015
-- Design Name:
-- Module Name: d:/dell/Documents/ISE Projects/fft/fft/test_fft_pt2.vhd
-- Project Name: fft
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: fft_pt2
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

ENTITY test_fft_pt2 IS
END test_fft_pt2;

ARCHITECTURE behavior OF test_fft_pt2 IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT fft_pt2
        PORT (
            clk            : IN std_logic;
            rst            : IN std_logic;
            ce             : IN std_logic;
            ctrl           : IN std_logic;
            data_0_re_in   : IN std_logic;
            data_0_im_in   : IN std_logic;
            data_1_re_in   : IN std_logic;
            data_1_im_in   : IN std_logic;
            data_0_re_out  : OUT std_logic;
            data_0_im_out  : OUT std_logic;
            data_1_re_out  : OUT std_logic;
            data_1_im_out  : OUT std_logic
        );
    END COMPONENT;
    --Inputs
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL ce : std_logic := '0';
    SIGNAL ctrl : std_logic := '0';
    SIGNAL data_0_re_in : std_logic := '0';
    SIGNAL data_0_im_in : std_logic := '0';
    SIGNAL data_1_re_in : std_logic := '0';
    SIGNAL data_1_im_in : std_logic := '0';

    --Outputs
    SIGNAL data_0_re_out : std_logic;
    SIGNAL data_0_im_out : std_logic;
    SIGNAL data_1_re_out : std_logic;
    SIGNAL data_1_im_out : std_logic;

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : fft_pt2
    PORT MAP(
        clk            => clk, 
        rst            => rst, 
        ce             => ce, 
        ctrl           => ctrl, 
        data_0_re_in   => data_0_re_in, 
        data_0_im_in   => data_0_im_in, 
        data_1_re_in   => data_1_re_in, 
        data_1_im_in   => data_1_im_in, 
        data_0_re_out  => data_0_re_out, 
        data_0_im_out  => data_0_im_out, 
        data_1_re_out  => data_1_re_out, 
        data_1_im_out  => data_1_im_out
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
        WAIT FOR clk_period * 9;
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
    --- data_0_re_in = 1 '0001'
    --- data_0_im_in = 2 '0010'
    --- data_1_re_in = 3 '0011'
    --- data_1_im_in = 4 '0100'
    --- data_2_re_in = 5 '0101'
    --- data_2_im_in = -6 '1010'
    --- data_3_re_in = 7 '0111'
    --- data_3_im_in = -8 '1000'

    data_0_re_in <= '1';
    data_0_im_in <= '0';
    data_1_re_in <= '1';
    data_1_im_in <= '0';
    WAIT FOR clk_period;

    data_0_re_in <= '0';
    data_0_im_in <= '1';
    data_1_re_in <= '1';
    data_1_im_in <= '0';
    WAIT FOR clk_period;

    data_0_re_in <= '0';
    data_0_im_in <= '0';
    data_1_re_in <= '0';
    data_1_im_in <= '1';
    WAIT FOR clk_period;

    data_0_re_in <= '0';
    data_0_im_in <= '0';
    data_1_re_in <= '0';
    data_1_im_in <= '0';
    WAIT FOR clk_period;
    WAIT;
END PROCESS;

END;
