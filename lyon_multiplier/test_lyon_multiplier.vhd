--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:31:49 10/14/2015
-- Design Name:   
-- Module Name:   d:/dell/Documents/ISE Projects/lyon_multiplier/test_lyon_multiplier.vhd
-- Project Name:  lyon_multiplier
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
 
ENTITY test_lyon_multiplier IS
END test_lyon_multiplier;
 
ARCHITECTURE behavior OF test_lyon_multiplier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lyon_multiplier
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic;
         ctrl : IN  std_logic;
         d1_in : IN  std_logic;
         product_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ce : std_logic := '0';
   signal ctrl : std_logic := '0';
   signal d1_in : std_logic := '0';

 	--Outputs
   signal product_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lyon_multiplier PORT MAP (
          clk => clk,
          rst => rst,
          ce => ce,
          ctrl => ctrl,
          d1_in => d1_in,
          product_out => product_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   ctrl_proc: process
   begin
    ctrl<='0';
    wait for 95 ns;
    wait for clk_period*10;
    loop
      ctrl<='1';
      wait for clk_period;
      ctrl<='0';
      wait for clk_period*15;
    end loop;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst<='0';
      ce<='0';
      wait for 95 ns; 
      rst<='1';
      ce<='1';
      wait for clk_period*10;
      -- insert stimulus here 

      d1_in<='0';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='0';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;

      d1_in<='1';
      wait for clk_period;
      
      d1_in<='0';
      wait;
   end process;

END;
