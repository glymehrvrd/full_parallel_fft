--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:07:47 10/28/2015
-- Design Name:   
-- Module Name:   d:/dell/Documents/ISE Projects/fft/fft/test_shifter.vhd
-- Project Name:  fft
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shifter
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
 
ENTITY test_shifter IS
END test_shifter;
 
ARCHITECTURE behavior OF test_shifter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shifter
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic;
         ctrl : IN  std_logic;
         data_in : IN  std_logic;
         data_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ce : std_logic := '0';
   signal ctrl : std_logic := '0';
   signal data_in : std_logic := '0';

 	--Outputs
   signal data_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shifter PORT MAP (
          clk => clk,
          rst => rst,
          ce => ce,
          ctrl => ctrl,
          data_in => data_in,
          data_out => data_out
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
    rst<='0';
    ce<='0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      rst<='1';
      ce<='1';
      ctrl<='0';
      wait for clk_period*10;

      -- insert stimulus here 
      data_in<='0';
      ctrl<='0';
      wait for clk_period;
      data_in<='1';
      wait for clk_period;
      data_in<='0';
      ctrl<='1';
      wait for clk_period;
      data_in<='1';
      wait;
   end process;

END;
