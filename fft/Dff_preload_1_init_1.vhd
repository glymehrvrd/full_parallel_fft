library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dff_preload_reg1_init_1 is
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           preload: in STD_LOGIC;
           Q : out  STD_LOGIC);
end Dff_preload_reg1_init_1;

architecture Behavioral of Dff_preload_reg1_init_1 is

signal reg: std_logic_vector(0 downto 0);
begin

Q<= reg(0);

process(clk,rst,preload)
begin
    if rst='1' or preload='1' then
        reg<=(others=>'1');
    elsif clk'event and clk='1' then
        reg(0)<=D;
    end if;
end process;

end Behavioral;
