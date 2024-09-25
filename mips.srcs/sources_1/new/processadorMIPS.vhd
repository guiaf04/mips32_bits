library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;

entity processadorMIPS is
  Port ( 
    clk, rst : in std_logic;
    ce, rw : out std_logic;
    i_address: out reg32;
    instruction: in reg32;
    data : inout reg32
  );
end processadorMIPS;

architecture Behavioral of processadorMIPS is
    signal uins: microinstruction;
    signal zero, carry : std_logic;
    signal ram_in, ram_out, ram_addr : std_logic_vector(31 downto 0);
begin
    dp: entity work.datapath
        port map(
            clk=>clk, 
            rst=>rst, 
            instruction=>instruction, 
            d_address=>ram_addr,
            uins=>uins, 
            data=>data, 
            zero => zero,
            carry => carry,
            ram_in => ram_in,
            ram_out => ram_out
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
        
   ram: entity work.ram
        port map(
            din  => ram_in  ,
            addr => ram_addr,
            dout => ram_out ,
            we   => uins.rw, 
            clk  => clk  
            );     
            
    ce<=uins.ce;
    
    rw<=uins.rw;
    
end Behavioral;