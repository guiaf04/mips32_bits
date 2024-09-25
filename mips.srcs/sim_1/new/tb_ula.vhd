library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;

entity tb_ula is
--  Port ( );
end tb_ula;

architecture Behavioral of tb_ula is
   signal op1, op2 :  reg32;
   signal outula   :  reg32;
   signal zero     :  std_logic;
   signal op_ula   :  inst_type;
begin

  DUT: entity work.ula
      port map(
        op1     => op1,
        op2     =>  op2 ,
        outula  =>  outula   ,
        zero    =>  zero     ,
        op_ula  =>  op_ula  
      );

  estimulos: process
  begin
  
  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= SUBU;
  wait for 200 ns;
 
  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= AAND;
  wait for 200 ns;

 
  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= OOR; 
  wait for 200 ns;


  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= XXOR;
  wait for 200 ns;

  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= NNOR;
  wait for 200 ns;
  
  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= ORI;
  wait for 200 ns;
  
  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= LW;
  wait for 200 ns;
    
  op1 <= x"11111111";
  op2 <= x"00100100";
  op_ula <= SW;
  wait for 200 ns;
  
  end process;

end Behavioral;
