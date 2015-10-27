--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:17:45 10/27/2015
-- Design Name:   
-- Module Name:   D:/dell/Documents/ISE Projects/fft/fft/test_fft_pt8.vhd
-- Project Name:  fft
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
 
ENTITY test_fft_pt8 IS
END test_fft_pt8;
 
ARCHITECTURE behavior OF test_fft_pt8 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fft_pt8
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic;
         ctrl : IN  std_logic;
         data_re_in : IN  std_logic_vector(7 downto 0);
         data_im_in : IN  std_logic_vector(7 downto 0);
         data_re_out : OUT  std_logic_vector(7 downto 0);
         data_im_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ce : std_logic := '0';
   signal ctrl : std_logic := '0';
   signal data_re_in : std_logic_vector(7 downto 0) := (others => '0');
   signal data_im_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal data_re_out : std_logic_vector(7 downto 0);
   signal data_im_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

   signal data_0_re_in:std_logic:='0';
   signal data_0_im_in:std_logic:='0';
   signal data_1_re_in:std_logic:='0';
   signal data_1_im_in:std_logic:='0';
   signal data_2_re_in:std_logic:='0';
   signal data_2_im_in:std_logic:='0';
   signal data_3_re_in:std_logic:='0';
   signal data_3_im_in:std_logic:='0';
   signal data_4_re_in:std_logic:='0';
   signal data_4_im_in:std_logic:='0';
   signal data_5_re_in:std_logic:='0';
   signal data_5_im_in:std_logic:='0';
   signal data_6_re_in:std_logic:='0';
   signal data_6_im_in:std_logic:='0';
   signal data_7_re_in:std_logic:='0';
   signal data_7_im_in:std_logic:='0';
 
BEGIN
 data_re_in<=(data_7_re_in,data_6_re_in,data_5_re_in,data_4_re_in,data_3_re_in,data_2_re_in,data_1_re_in,data_0_re_in);
 data_im_in<=(data_7_im_in,data_6_im_in,data_5_im_in,data_4_im_in,data_3_im_in,data_2_im_in,data_1_im_in,data_0_im_in);
	-- Instantiate the Unit Under Test (UUT)
   uut: fft_pt8 PORT MAP (
          clk => clk,
          rst => rst,
          ce => ce,
          ctrl => ctrl,
          data_re_in => data_re_in,
          data_im_in => data_im_in,
          data_re_out => data_re_out,
          data_im_out => data_im_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
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
data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='0';
data_1_im_in<='1';
data_2_re_in<='1';
data_2_im_in<='0';
data_3_re_in<='1';
data_3_im_in<='0';
data_4_re_in<='1';
data_4_im_in<='0';
data_5_re_in<='0';
data_5_im_in<='0';
data_6_re_in<='1';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='1';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='0';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='1';
data_3_re_in<='0';
data_3_im_in<='1';
data_4_re_in<='0';
data_4_im_in<='1';
data_5_re_in<='1';
data_5_im_in<='0';
data_6_re_in<='1';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='1';
data_0_im_in<='0';
data_1_re_in<='0';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='1';
data_3_re_in<='1';
data_3_im_in<='1';
data_4_re_in<='0';
data_4_im_in<='0';
data_5_re_in<='1';
data_5_im_in<='0';
data_6_re_in<='0';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='1';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='1';
data_1_re_in<='1';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='0';
data_3_im_in<='1';
data_4_re_in<='1';
data_4_im_in<='0';
data_5_re_in<='1';
data_5_im_in<='0';
data_6_re_in<='0';
data_6_im_in<='1';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='1';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='1';
data_3_re_in<='1';
data_3_im_in<='1';
data_4_re_in<='1';
data_4_im_in<='0';
data_5_re_in<='1';
data_5_im_in<='1';
data_6_re_in<='1';
data_6_im_in<='1';
data_7_re_in<='0';
data_7_im_in<='1';
wait for clk_period;

data_0_re_in<='1';
data_0_im_in<='0';
data_1_re_in<='1';
data_1_im_in<='0';
data_2_re_in<='1';
data_2_im_in<='0';
data_3_re_in<='1';
data_3_im_in<='0';
data_4_re_in<='1';
data_4_im_in<='0';
data_5_re_in<='1';
data_5_im_in<='0';
data_6_re_in<='0';
data_6_im_in<='1';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='1';
data_1_re_in<='1';
data_1_im_in<='1';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='1';
data_3_im_in<='0';
data_4_re_in<='1';
data_4_im_in<='1';
data_5_re_in<='0';
data_5_im_in<='0';
data_6_re_in<='1';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='1';
data_1_im_in<='1';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='0';
data_3_im_in<='0';
data_4_re_in<='0';
data_4_im_in<='0';
data_5_re_in<='0';
data_5_im_in<='0';
data_6_re_in<='1';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='1';
data_1_re_in<='1';
data_1_im_in<='1';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='0';
data_3_im_in<='0';
data_4_re_in<='0';
data_4_im_in<='1';
data_5_re_in<='0';
data_5_im_in<='1';
data_6_re_in<='1';
data_6_im_in<='1';
data_7_re_in<='1';
data_7_im_in<='1';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='0';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='1';
data_3_re_in<='1';
data_3_im_in<='1';
data_4_re_in<='0';
data_4_im_in<='0';
data_5_re_in<='1';
data_5_im_in<='1';
data_6_re_in<='0';
data_6_im_in<='1';
data_7_re_in<='1';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='1';
data_0_im_in<='1';
data_1_re_in<='0';
data_1_im_in<='1';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='0';
data_3_im_in<='1';
data_4_re_in<='0';
data_4_im_in<='1';
data_5_re_in<='1';
data_5_im_in<='1';
data_6_re_in<='0';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='1';
data_1_re_in<='1';
data_1_im_in<='1';
data_2_re_in<='1';
data_2_im_in<='1';
data_3_re_in<='1';
data_3_im_in<='1';
data_4_re_in<='1';
data_4_im_in<='1';
data_5_re_in<='0';
data_5_im_in<='1';
data_6_re_in<='0';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='1';
wait for clk_period;

data_0_re_in<='1';
data_0_im_in<='1';
data_1_re_in<='1';
data_1_im_in<='1';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='1';
data_3_im_in<='1';
data_4_re_in<='0';
data_4_im_in<='1';
data_5_re_in<='0';
data_5_im_in<='1';
data_6_re_in<='1';
data_6_im_in<='1';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='1';
data_0_im_in<='1';
data_1_re_in<='1';
data_1_im_in<='1';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='1';
data_3_im_in<='1';
data_4_re_in<='1';
data_4_im_in<='1';
data_5_re_in<='0';
data_5_im_in<='0';
data_6_re_in<='0';
data_6_im_in<='1';
data_7_re_in<='1';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='0';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='0';
data_3_im_in<='0';
data_4_re_in<='0';
data_4_im_in<='0';
data_5_re_in<='0';
data_5_im_in<='0';
data_6_re_in<='0';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

data_0_re_in<='0';
data_0_im_in<='0';
data_1_re_in<='0';
data_1_im_in<='0';
data_2_re_in<='0';
data_2_im_in<='0';
data_3_re_in<='0';
data_3_im_in<='0';
data_4_re_in<='0';
data_4_im_in<='0';
data_5_re_in<='0';
data_5_im_in<='0';
data_6_re_in<='0';
data_6_im_in<='0';
data_7_re_in<='0';
data_7_im_in<='0';
wait for clk_period;

      wait;
   end process;

END;
