library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;


entity tb_datapath is
--  Port ( );
end tb_datapath;

architecture Behavioral of tb_datapath is
  signal clk, rst : std_logic := '0';
  signal instruction : reg32;
  signal d_address :  reg32;
  signal uins :  microinstruction;
  signal data :  reg32;
  constant clock_period : time := 200 ns;
  signal i : inst_type;
begin
  process(instruction)
  begin
     if instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100001"    then
        i <= ADDU;
     elsif instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100011" then
        i <= SUBU;
     elsif instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100100"  then
        i <= AAND;                                                                   
     elsif instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100101"  then
        i <= OOR;                                                                    
     elsif instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100110"  then
        i <= XXOR;                                                                   
     elsif instruction(31 downto 26)="000000" and instruction(10 downto 0)="00000100111"  then
        i <= NNOR;                                                                   
     elsif instruction(31 downto 26)="001101"                                             then
        i <= ORI;                                                                    
     elsif instruction(31 downto 26)="100011"                                             then
        i <= LW;                                                                     
     elsif instruction(31 downto 26)="101011"                                             then
        i <= SW;
     else
        i <= invalid_instruction;
     end if;
   end process;
   
        
   uins.i <= i;
     
     -- Geração de sinais de controle
   uins.ce    <= '1' when i=SW  or i=LW else '0';-- Controles de leitura(1)/escrita(1) da/na memória
    
   uins.rw    <= '0' when i=SW  else '1';-- Controles de leitura(1)/escrita(0) da/na memória

   uins.wreg  <= '0' when i=SW  else '1';-- Controle de escrita(0) e leitura(1) no banco de registradores
   
   
   DUT: entity work.datapath
          port map(
              clk         =>      clk,
              rst         =>      rst    ,
              instruction =>      instruction ,
              d_address   =>      d_address   ,
              uins        =>      uins        ,
              data        =>      data        
            );
            
   clk <= not clk after clock_period/2;
   
   estimulos: process
   begin
   
   rst <= '1';
   wait for clock_period;
   rst <= '0';
   wait for clock_period/2;
   
    --100011 00011 00010 1000 0000 0000 1111 lw R2, R1, 0
   instruction <= x"8c62000f";
   wait for clock_period;
   
   --000000 00011 00010 00001 00000 100001
   instruction <= x"00620821";
   wait for clock_period;
   
   --000000 00011 00010 00000 00000 100011
   instruction <= x"00620823";
   wait for clock_period;
   
   --000000 00011 00010 00000 00000 100100
   instruction <= x"00620824";
   wait for clock_period;
   
   --000000 00011 00010 00000 00000 100101
   instruction <= x"00620825";
   wait for clock_period;
   
   --000000 00011 00010 00000 00000 100110
   instruction <= x"00620826";
   wait for clock_period;
   
   --000000 00011 00010 00000 00000 100111
   instruction <= x"00620827";
   wait for clock_period;
   
   --001101 00001 00000 0000 0000 0000 0000 ori R1, R0, 0 
   instruction <= x"34200000";
   wait for clock_period;
   
   
   --101011 00001 00000 0000 0000 0000 0000 sw R1, R0, 0
   instruction <= x"ac200000";
   wait for clock_period;
   
   end process;         

end Behavioral;
