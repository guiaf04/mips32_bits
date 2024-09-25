library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_Logic_signed.all; 
use work.pkg_mips.all;

entity unidadeControle is
  Port ( 
    clk, rst : in std_logic;
    uins : out microinstruction;
    i_address : out reg32;
    instruction : in reg32;
    zero, carry: in std_logic
  );
end unidadeControle;

architecture Behavioral of unidadeControle is
    signal incpc, pc : reg32;
    signal i : inst_type;
begin
    -- PC
    rpc: entity work.registrador 
            generic map(INIT_VALUE=>x"00400000")-- Para o SPIM -> x"00400020"
                                                -- Para o MARS -> x"00400000"
            port map(
                clk=>clk, 
                rst=>rst, 
                ce=>'1', 
                D=>incpc, 
                Q=>pc);
       
    
    -- Decodificação de instrucoes (controla multiplexadores e operações da ULA)
    uins.i <= i;  
    i <= ADDU when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100001" else
         SUBU when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100011" else
         AAND when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100100" else
         OOR  when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100101" else
         XXOR when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100110" else
         NNOR when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100111" else
         SSHL when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000101000" else
         SSHR when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000101001" else
         RROL when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000101010" else
         RROR when instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000101011" else
         ORI  when instruction(31 downto 26)="001101" else
         LW   when instruction(31 downto 26)="100011" else
         SW   when instruction(31 downto 26)="101011" else
         JMP  when instruction(31 downto 26)="000001" and instruction(25 downto 21)="00001" else
         JEQ  when instruction(31 downto 26)="000001" and instruction(25 downto 21)="00010" else
         JLT  when instruction(31 downto 26)="000001" and instruction(25 downto 21)="00100" else
         JGT  when instruction(31 downto 26)="000001" and instruction(25 downto 21)="01000" else
         PSH  when instruction(31 downto 26)="000001" and instruction(25 downto 21)="11101" else
         POP  when instruction(31 downto 26)="000010" and instruction(25 downto 21)="11101" else
         invalid_instruction;
         
         
    incpc <=   ( x"FFFF" & instruction(15 downto 0)) when   i = JMP else                                  --JMP
               ( x"FFFF" & instruction(15 downto 0)) when  (i = JEQ and zero = '1' and carry = '0') else  --JEQ
               ( x"FFFF" & instruction(15 downto 0)) when  (i = JLT and zero = '0' and carry = '1') else  --JLT
               ( x"FFFF" & instruction(15 downto 0)) when  (i = JGT and zero = '0' and carry = '0') else  --JGT
               pc +4;
    
    
    i_address <= pc; 
         
    assert i /= invalid_instruction
          report "INVALID INSTRUCTION"
          severity error;
          
   -- Geração de sinais de controle
   uins.ce    <= '1' when i=SW  or i=LW else '0';-- Controles de leitura(1)/escrita(1) da/na memória
    
   uins.rw    <= '0' when i=SW  else '1';-- Controles de leitura(1)/escrita(0) da/na memória

   uins.wreg  <= '0' when i=SW  else '1';-- Controle de escrita(0) e leitura(1) no banco de registradores
end Behavioral;
