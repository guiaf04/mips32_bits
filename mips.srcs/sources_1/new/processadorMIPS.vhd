library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;

entity processadorMIPS is
  Port ( 
    clk, rst : in std_logic;
    ce, rw : out std_logic;
    i_address, d_address: out reg32;
    instruction: in reg32;
    data : inout reg32
  );
end processadorMIPS;

architecture Behavioral of processadorMIPS is
    signal uins: microinstruction;
    signal zero, carry : std_logic;
begin
    dp: entity work.datapath
        port map(
            clk=>clk, 
            rst=>rst, 
            instruction=>instruction, 
            d_address=>d_address,
            uins=>uins, 
            data=>data, 
            zero => zero,
            carry => carry
        );
        
    uc: entity work.unidadeControle
        port map(
            clk=>clk, 
            rst=>rst, 
            uins=>uins, 
            i_address=>i_address,
            instruction=>instruction,
            zero => zero,
            carry => carry
        );
        
    ce<=uins.ce;
    
    rw<=uins.rw;
    
end Behavioral;