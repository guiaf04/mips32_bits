library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;

entity processadorMIPS is
  Port ( 
    clk, rst : in std_logic;
    ce, rw : out std_logic;
    i_address: out reg32;
    instruction: inout reg32;
    data : inout reg32
  );
end processadorMIPS;

architecture Behavioral of processadorMIPS is
    signal uins: microinstruction;
    signal zero, carry,  rom_en : std_logic;
    signal ram_in, ram_out, ram_addr, rom_addr, rom_dout : std_logic_vector(31 downto 0);
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
            rom_en => rom_en,
            uins=>uins, 
            i_address=>i_address,
            instruction=>instruction,
            zero => zero,
            carry => carry,
            rom_addr => rom_addr,
            rom_dout => rom_dout
        );
        
   ram: entity work.ram
        port map(
            din  => ram_in  ,
            addr => ram_addr,
            dout => ram_out ,
            we   => uins.rw, 
            clk  => clk  
            );     
       
   rom: entity work.rom
        port map(
            clk  => clk, 
            addr => rom_addr,
            en   => rom_en,
            dout => rom_dout       
            );  
            
    ce<=uins.ce;
    
    rw<=uins.rw;
 
    
end Behavioral;