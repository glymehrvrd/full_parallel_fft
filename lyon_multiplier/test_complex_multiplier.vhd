--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:22:54 10/23/2015
-- Design Name:   
-- Module Name:   d:/dell/Documents/ISE Projects/fft/lyon_multiplier/test_complex_multiplier.vhd
-- Project Name:  lyon_multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: complex_multiplier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_complex_multiplier IS
END test_complex_multiplier;
 
ARCHITECTURE behavior OF test_complex_multiplier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT complex_multiplier
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic;
         ctrl : IN  std_logic;
         data_re_in : IN  std_logic;
         data_im_in : IN  std_logic;
         product_re_out : OUT  std_logic;
         product_im_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ce : std_logic := '0';
   signal ctrl : std_logic := '0';
   signal data_re_in : std_logic := '0';
   signal data_im_in : std_logic := '0';

 	--Outputs
   signal product_re_out : std_logic;
   signal product_im_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: complex_multiplier PORT MAP (
          clk => clk,
          rst => rst,
          ce => ce,
          ctrl => ctrl,
          data_re_in => data_re_in,
          data_im_in => data_im_in,
          product_re_out => product_re_out,
          product_im_out => product_im_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
