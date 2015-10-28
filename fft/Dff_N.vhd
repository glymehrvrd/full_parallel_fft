library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dff_regN is
  generic (N:Integer);
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ce  : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end Dff_regN;

architecture Behavioral of Dff_regN is

signal reg: std_logic_vector(N-1 downto 0);
begin

Q<= reg(N-1);

process(clk,rst)
begin
    if clk'event and clk='1' then
        if rst='0' then
            reg<=(others=>'0');
        elsif ce='1' then
            reg<=reg(N-2 downto 0) & D;
        end if;
    end if;
end process;

end Behavioral;
