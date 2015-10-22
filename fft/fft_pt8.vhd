----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:03 10/21/2015 
-- Design Name: 
-- Module Name:    fft_pt8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fft_pt8 is
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in:in std_logic_vector(7 downto 0);
        data_im_in:in std_logic_vector(7 downto 0);

        data_re_out:out std_logic_vector(7 downto 0);
        data_im_out:out std_logic_vector(7 downto 0)
    );
end fft_pt8;

architecture Behavioral of fft_pt8 is

component fft_pt2 is
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in     : in std_logic_vector(1 downto 0);
        data_im_in     : in std_logic_vector(1 downto 0);

        data_re_out     : out std_logic_vector(1 downto 0);
        data_im_out     : out std_logic_vector(1 downto 0)
    );
end component;

component fft_pt4 is
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_re_in:in std_logic_vector(3 downto 0);
        data_im_in:in std_logic_vector(3 downto 0);

        data_re_out:out std_logic_vector(3 downto 0);
        data_im_out:out std_logic_vector(3 downto 0)
    );
end component;

signal first_stage_re_out, first_stage_im_out: std_logic_vector(7 downto 0);

type array2_3 is array (1 downto 0) of std_logic_vector(3 downto 0);
signal stage_1_re_in, stage_1_im_in: array2_3;

begin
    stage_1_re_in(0)<=(data_re_in(6),data_re_in(4),data_re_in(2),data_re_in(0));
    stage_1_im_in(0)<=(data_im_in(6),data_im_in(4),data_im_in(2),data_im_in(0));
    stage_1_re_in(1)<=(data_re_in(7),data_re_in(5),data_re_in(3),data_re_in(1));
    stage_1_im_in(1)<=(data_im_in(7),data_im_in(5),data_im_in(3),data_im_in(1));

    UFFT_4pt0 : fft_pt4
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_re_in=>stage_1_re_in(0),
        data_im_in=>stage_1_im_in(0),
        data_re_out=>first_stage_re_out(3 downto 0),
        data_im_out=>first_stage_im_out(3 downto 0)
        );

    UFFT_4pt1 : fft_pt4
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_re_in=>stage_1_re_in(1),
        data_im_in=>stage_1_im_in(1),
        data_re_out=>first_stage_re_out(7 downto 4),
        data_im_out=>first_stage_im_out(7 downto 4)
        );

    UFFT_2pt0 : fft_pt2
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_re_in(0)=>first_stage_re_out(0),
        data_re_in(1)=>first_stage_re_out(4),
        data_im_in(0)=>first_stage_im_out(0),
        data_im_in(1)=>first_stage_im_out(4),
        data_re_out=>data_re_out(1 downto 0),
        data_im_out=>data_im_out(1 downto 0)
        );

    UFFT_2pt1 : fft_pt2
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_re_in(0)=>first_stage_re_out(1),
        data_re_in(1)=>first_stage_re_out(5),
        data_im_in(0)=>first_stage_im_out(1),
        data_im_in(1)=>first_stage_im_out(5),
        data_re_out=>data_re_out(3 downto 2),
        data_im_out=>data_im_out(3 downto 2)
        );

    UFFT_2pt2 : fft_pt2
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_re_in(0)=>first_stage_re_out(2),
        data_re_in(1)=>first_stage_re_out(6),
        data_im_in(0)=>first_stage_im_out(2),
        data_im_in(1)=>first_stage_im_out(6),
        data_re_out=>data_re_out(5 downto 4),
        data_im_out=>data_im_out(5 downto 4)
        );

    UFFT_2pt3 : fft_pt2
    port map(
        clk=>clk,
        rst=>rst,
        ce=>ce,
        ctrl=>ctrl,
        data_re_in(0)=>first_stage_re_out(3),
        data_re_in(1)=>first_stage_re_out(7),
        data_im_in(0)=>first_stage_im_out(3),
        data_im_in(1)=>first_stage_im_out(7),
        data_re_out=>data_re_out(7 downto 6),
        data_im_out=>data_im_out(7 downto 6)
        );
end Behavioral;

