--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:56 10/10/2015
-- Design Name:   
-- Module Name:   F:/Documents/FFT/fft/test_fft_pt4.vhd
-- Project Name:  fft
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fft_pt4
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
 
ENTITY test_fft_pt4 IS
END test_fft_pt4;
 
ARCHITECTURE behavior OF test_fft_pt4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fft_pt4
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ctrl : IN  std_logic;
         data_0_re_in : IN  std_logic;
         data_0_im_in : IN  std_logic;
         data_1_re_in : IN  std_logic;
         data_1_im_in : IN  std_logic;
         data_2_re_in : IN  std_logic;
         data_2_im_in : IN  std_logic;
         data_3_re_in : IN  std_logic;
         data_3_im_in : IN  std_logic;
         data_0_re_out : OUT  std_logic;
         data_0_im_out : OUT  std_logic;
         data_1_re_out : OUT  std_logic;
         data_1_im_out : OUT  std_logic;
         data_2_re_out : OUT  std_logic;
         data_2_im_out : OUT  std_logic;
         data_3_re_out : OUT  std_logic;
         data_3_im_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ctrl : std_logic := '0';
   signal data_0_re_in : std_logic := '0';
   signal data_0_im_in : std_logic := '0';
   signal data_1_re_in : std_logic := '0';
   signal data_1_im_in : std_logic := '0';
   signal data_2_re_in : std_logic := '0';
   signal data_2_im_in : std_logic := '0';
   signal data_3_re_in : std_logic := '0';
   signal data_3_im_in : std_logic := '0';

 	--Outputs
   signal data_0_re_out : std_logic;
   signal data_0_im_out : std_logic;
   signal data_1_re_out : std_logic;
   signal data_1_im_out : std_logic;
   signal data_2_re_out : std_logic;
   signal data_2_im_out : std_logic;
   signal data_3_re_out : std_logic;
   signal data_3_im_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fft_pt4 PORT MAP (
          clk => clk,
          rst => rst,
          ctrl => ctrl,
          data_0_re_in => data_0_re_in,
          data_0_im_in => data_0_im_in,
          data_1_re_in => data_1_re_in,
          data_1_im_in => data_1_im_in,
          data_2_re_in => data_2_re_in,
          data_2_im_in => data_2_im_in,
          data_3_re_in => data_3_re_in,
          data_3_im_in => data_3_im_in,
          data_0_re_out => data_0_re_out,
          data_0_im_out => data_0_im_out,
          data_1_re_out => data_1_re_out,
          data_1_im_out => data_1_im_out,
          data_2_re_out => data_2_re_out,
          data_2_im_out => data_2_im_out,
          data_3_re_out => data_3_re_out,
          data_3_im_out => data_3_im_out
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
      rst<='1';
      ctrl<='1';
      wait for 95 ns;	
      rst<='0';
      ctrl<='0';
      wait for clk_period*10;
      -- insert stimulus here 
      --- data_0_re_in = 1  '0001'
      --- data_0_im_in = 2  '0010'
      --- data_1_re_in = 3  '0011'
      --- data_1_im_in = 4  '0100'
      --- data_2_re_in = 5  '0101'
      --- data_2_im_in = -6 '1010'
      --- data_3_re_in = 7  '0111'
      --- data_3_im_in = -8 '1000'
      
        data_0_re_in<='1';
        data_0_im_in<='0';
        data_1_re_in<='1';
        data_1_im_in<='0';
        data_2_re_in<='1';
        data_2_im_in<='0';
        data_3_re_in<='1';
        data_3_im_in<='0';
        wait for clk_period;

        data_0_re_in<='0';
        data_0_im_in<='1';
        data_1_re_in<='1';
        data_1_im_in<='0';
        data_2_re_in<='0';
        data_2_im_in<='1';
        data_3_re_in<='1';
        data_3_im_in<='0';
        wait for clk_period;

        data_0_re_in<='0';
        data_0_im_in<='0';
        data_1_re_in<='0';
        data_1_im_in<='1';
        data_2_re_in<='1';
        data_2_im_in<='0';
        data_3_re_in<='1';
        data_3_im_in<='0';
        wait for clk_period;

        data_0_re_in<='0';
        data_0_im_in<='0';
        data_1_re_in<='0';
        data_1_im_in<='0';
        data_2_re_in<='0';
        data_2_im_in<='1';
        data_3_re_in<='0';
        data_3_im_in<='1';
        wait for clk_period;

      wait;
   end process;

END;
