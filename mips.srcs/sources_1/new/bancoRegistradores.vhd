library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.pkg_mips.all;

entity bancoRegistradores is
  Port ( 
         clk, rst, ce :    in std_logic;
         AdRP1, AdRP2, AdWP : in std_logic_vector(4 downto 0);
         DataWP : in reg32;
         DataRP1, DataRP2: out reg32 
  );
end bancoRegistradores;

architecture Behavioral of bancoRegistradores is
   type wirebank is array(0 to 31) of reg32;
   signal reg : wirebank ;                            
   signal wen : reg32;
begin
    g1: for i in 0 to 31 generate       
        wen(i) <= '1' when i/=0 and AdWP=i and ce='1' else '0';
        
        g2: if i=29 generate -- SP ---  x10010000 + x800 -- top da pilha
           r29: entity work.registrador 
                generic map(INIT_VALUE=>x"10010800")    
                port map(
                    clk=>clk, 
                    rst=>rst, 
                    ce=>wen(i), 
                    D=>DataWP, 
                    Q=>reg(i));
        end generate;  
                
        g3: if i/=29 generate 
           rx: entity work.registrador 
                port map(
                    clk=>clk, 
                    rst=>rst, 
                    ce=>wen(i), 
                    D=>DataWP, 
                    Q=>reg(i));                
        end generate;
    
    end generate;

    DataRP1 <= reg(CONV_INTEGER(AdRP1));  

    DataRP2 <= reg(CONV_INTEGER(AdRP2));    
end Behavioral;