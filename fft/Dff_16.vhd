library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dff_reg16 is
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ce  : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end Dff_reg16;

architecture Behavioral of Dff_reg16 is

signal reg: std_logic_vector(15 downto 0);
begin

Q<= reg(15);

process(clk,rst)
begin
    if clk'event and clk='1' then
        if rst='0' then
            reg<=(others=>'0');
        elsif ce='1' then
            reg<=reg(14 downto 0) & D;
        end if;
    end if;
end process;

end Behavioral;
