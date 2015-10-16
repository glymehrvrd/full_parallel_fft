library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dff_reg1 is
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end Dff_reg1;

architecture Behavioral of Dff_reg1 is

begin

process(clk,rst)
begin
    if clk'event and clk='1' then
        if rst='0' then
            Q<='0';
        else
            Q<=D;
        end if;
    end if;
end process;

end Behavioral;
