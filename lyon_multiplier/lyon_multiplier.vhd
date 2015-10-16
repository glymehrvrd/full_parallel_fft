----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:56:56 10/14/2015 
-- Design Name: 
-- Module Name:    lyon_multiplier - Behavioral 
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

entity lyon_multiplier is
port(
    clk, rst, ce  : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;
        d1_in: in std_logic;
        product_out            : OUT STD_LOGIC
        );
end lyon_multiplier;

architecture Behavioral of lyon_multiplier is

component Dff_reg1 is
      Port ( D : in  STD_LOGIC;
             clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             Q : out  STD_LOGIC);
end component;

component partial_product is
 PORT (
        clk, rst, ce  : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC; --进位信号
        d1_in: in std_logic;
        d2_in  : IN STD_LOGIC;--两路数据输入
        d3_in: in std_logic;
        pp_out            : OUT STD_LOGIC --部分积
    );
end component;

component partial_product_last is
 PORT (
        clk, rst, ce  : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC; --进位信号
        d1_in: in std_logic;
        d2_in  : IN STD_LOGIC;--两路数据输入
        d3_in: in std_logic;
        pp_out            : OUT STD_LOGIC --部分积
    );
end component;

signal d1_in_delay: std_logic_vector(15 downto 0);
signal ctrl_delay:std_logic_vector(14 downto 0);

signal pp:std_logic_vector(15 downto 0);

constant multiplicator:std_logic_vector(15 downto 0) := "1111101111011011";

begin

    d1_in_delay(0)<=d1_in;
    --- buffer for d1_in
    process(clk,rst,ce,d1_in)
    begin
        if clk'event and clk='1' then
            if rst='0' then
                d1_in_delay(15 downto 1)<=(others=>'0');
            elsif ce='1' then
                d1_in_delay(15 downto 1)<=d1_in_delay(14 downto 0);
            end if;
        end if;
    end process;

    ctrl_delay(0)<=ctrl;
    --- buffer for ctrl
    process(clk,rst,ce,ctrl)
    begin
        if clk'event and clk='1' then
            if rst='0' then
                ctrl_delay(14 downto 1)<=(others=>'0');
            elsif ce='1' then
                ctrl_delay(14 downto 1)<=ctrl_delay(13 downto 0);
            end if;
        end if;
    end process;

    pp(0)<=multiplicator(0) and d1_in;

    GEN_PP:
    for I in 0 to 13 generate
        PPX: partial_product
        port map(
                clk=>clk,
                rst=>rst,
                ce=>ce,
                d1_in=>pp(I),
                d2_in=>d1_in_delay(I+1),
                d3_in=>multiplicator(I+1),
                ctrl=>ctrl_delay(I),
                pp_out=>pp(I+1)
            );
    end generate;

    PP_LAST: partial_product_last
    port map(
            clk=>clk,
            rst=>rst,
            ce=>ce,
            d1_in=>pp(14),
            d2_in=>d1_in_delay(15),
            d3_in=>multiplicator(15),
            ctrl=>ctrl_delay(14),
            pp_out=>pp(15)
        );

    --- output
    process(clk,rst,ce)
    begin
        if clk'event and clk='1' then
            if rst='0' then
                product_out<='0';
            elsif ce='1' then
                product_out<=pp(15);
            end if;
        end if;
    end process;

end Behavioral;
