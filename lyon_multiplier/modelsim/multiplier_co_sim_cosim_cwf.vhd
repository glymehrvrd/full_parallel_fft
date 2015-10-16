
-- -- --
entity xlcosim_fli_controller is
  generic ( A: string := "port1303");
end xlcosim_fli_controller;

architecture only of xlcosim_fli_controller is
    attribute foreign : string;
    attribute foreign of only : architecture is 
      "controller_init D:/Xilinx/14.7/ISE_DS/ISE/sysgen/bin/nt64/MTIFLIcontroller.dll";
begin
end;
-- -- --


-------------------------------------------------------------------
-- System Generator version 14.6 VHDL source file.
--
-- Copyright(C) 2013 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2013 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

entity multiplier_co_sim_cosim_clk_drvr is
  port (
    ce_1: out std_logic := '1'; 
    clk: out std_logic := '0'
  );
end multiplier_co_sim_cosim_clk_drvr;

architecture behavioral of multiplier_co_sim_cosim_clk_drvr is

  constant half_sys_period : time := 500 ms;

  signal proto_clk : std_logic := '1';

begin

    process_clk : process (proto_clk)
    begin
      if (proto_clk = '0') then
        proto_clk <= '1' after (half_sys_period);
      else
        proto_clk <= '0' after (half_sys_period);
      end if;
    end process process_clk;

    clk <= transport proto_clk after (1.99 * half_sys_period);
    ce_1 <= '1';

end architecture behavioral;library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

entity multiplier_co_sim_cosim_cw is
  port (
    black_box_ctrl: in std_logic; 
    black_box_d1_in: in std_logic; 
    black_box_rst: in std_logic; 
    black_box_product_out: out std_logic
  );
end multiplier_co_sim_cosim_cw;

architecture structural of multiplier_co_sim_cosim_cw is
  component xlcosim_fli_controller
  generic ( A: string := "port1303");
  end component;
  signal black_box_ctrl_net: std_logic;
  signal black_box_d1_in_net: std_logic;
  signal black_box_product_out_net: std_logic;
  signal black_box_rst_net: std_logic;
  signal ce_1_sg_x0: std_logic;
  signal clk_1_sg_x0: std_logic;
  signal clk_net: std_logic;

begin
  black_box_ctrl_net <= black_box_ctrl;
  black_box_d1_in_net <= black_box_d1_in;
  black_box_rst_net <= black_box_rst;
  black_box_product_out <= black_box_product_out_net;

  hdlcosim_clk_driver: entity work.multiplier_co_sim_cosim_clk_drvr
    port map (
      ce_1 => ce_1_sg_x0,
      clk => clk_net
    );

  multiplier_co_sim: entity work.multiplier_co_sim_cosim
    port map (
      black_box_ctrl => black_box_ctrl_net,
      black_box_d1_in => black_box_d1_in_net,
      black_box_rst => black_box_rst_net,
      ce_1 => ce_1_sg_x0,
      clk_1 => clk_net,
      black_box_product_out => black_box_product_out_net
    );

  xlcosim_fli_controller_0 : xlcosim_fli_controller
               generic map (A => "port1303");
end structural;
