--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:53:08 10/13/2015
-- Design Name:   
-- Module Name:   d:/dell/Documents/ISE Projects/lyon_multiplier/test_partial_product.vhd
-- Project Name:  lyon_multiplier
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
 
ENTITY test_partial_product IS
END test_partial_product;
 
ARCHITECTURE behavior OF test_partial_product IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT partial_product
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic;
         ctrl : IN  std_logic;
         d1_in : IN  std_logic;
         d2_in : IN  std_logic;
         d3_in : in std_logic;
         pp_out : OUT  std_logic
        );
    END COMPONENT;
    
    component Dff_reg1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
    end component;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ce : std_logic := '0';
   signal ctrl : std_logic := '0';
   signal d1_in : std_logic := '0';
   signal d2_in : std_logic := '0';
   signal d3_in : std_logic := '1';

   signal ctrl_buff:std_logic;
   signal d1_in_buff:std_logic;
 	--Outputs
   signal pp_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
  D1: Dff_reg1
  port map(
    D=>ctrl,
    clk=>clk,
    rst=>rst,
    Q=>ctrl_buff
    );
  D2: Dff_reg1
  port map(
    D=>d1_in,
    clk=>clk,
    rst=>rst,
    Q=>d1_in_buff
    );
	-- Instantiate the Unit Under Test (UUT)
   uut: partial_product PORT MAP (
          clk => clk,
          rst => rst,
          ce => ce,
          ctrl => ctrl_buff,
          d1_in => d1_in_buff,
          d2_in => d2_in,
          d3_in => d3_in,
          pp_out => pp_out
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
      ce<='0';
      ctrl<='0';
      wait for 95 ns;	
      rst<='1';
      ce<='1';
      wait for clk_period*10;
      -- insert stimulus here 
      d1_in<='0';
      d2_in<='1';
      ctrl<='1';
      wait for clk_period;

      d1_in<='0';
      d2_in<='0';
      ctrl<='0';
      wait for clk_period;
      
      d1_in<='1';
      d2_in<='0';
      ctrl<='0';
      wait for clk_period;
      
      d1_in<='0';
      d2_in<='0';
      ctrl<='0';
      wait for clk_period;
      
      d1_in<='1';
      d2_in<='1';
      ctrl<='1';
      wait for clk_period;
      
      d1_in<='0';
      d2_in<='1';
      ctrl<='0';
      wait for clk_period;

      d1_in<='1';
      d2_in<='0';
      ctrl<='0';
      wait for clk_period;

      d1_in<='0';
      d2_in<='0';
      ctrl<='0';
      wait for clk_period;
      wait;
   end process;

END;
