library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;

entity registrador is
    generic(INIT_VALUE : reg32 := (others=>'0'));
    port(
        clk, rst : in std_logic;
        ce : in std_logic;
        D : in reg32;
        Q : out reg32
    );
end registrador;

architecture Behavioral of registrador is

begin 
    process(clk,rst)
    begin
        if(rst='1')then
            Q<=INIT_VALUE(31 downto 0);            
        elsif(clk'event and clk='1')then
            if(ce='1')then
                Q<=D;
            end if;            
        end if;
    end process;    
end Behavioral;