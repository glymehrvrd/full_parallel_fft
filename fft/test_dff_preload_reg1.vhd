--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:07:41 10/20/2015
-- Design Name:   
-- Module Name:   D:/dell/Documents/ISE Projects/fft/fft/test_dff_preload_reg1.vhd
-- Project Name:  fft
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Dff_preload_reg1
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
 
ENTITY test_dff_preload_reg1 IS
END test_dff_preload_reg1;
 
ARCHITECTURE behavior OF test_dff_preload_reg1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Dff_preload_reg1
    PORT(
         D : IN  std_logic;
         clk : IN  std_logic;
         ce : IN  std_logic;
         rst : IN  std_logic;
         preload : IN  std_logic;
         Q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal D : std_logic := '0';
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal rst : std_logic := '0';
   signal preload : std_logic := '0';

 	--Outputs
   signal Q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Dff_preload_reg1 PORT MAP (
          D => D,
          clk => clk,
          ce => ce,
          rst => rst,
          preload => preload,
          Q => Q
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
      rst<='0';
      wait for 95 ns;	
        rst<='1';
      wait for clk_period*10;
      ce<='1';
      D<='1';
      wait for clk_period*2;
      D<='0';
      preload<='1';
      wait for clk_period;
      D<='1';
      preload<='0';
      -- insert stimulus here 

      wait;
   end process;

END;
