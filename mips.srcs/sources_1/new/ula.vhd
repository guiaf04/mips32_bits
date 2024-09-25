library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.pkg_mips.all;

entity ula is
    port(
        op1, op2 : in  reg32;
        outula : out reg32;
        zero : out std_logic;
        op_ula : in inst_type
    );
end ula;

architecture Behavioral of ula is
    signal int_ula: reg32;
begin 
    outula <= int_ula;
    int_ula <=  op1 - op2           when  op_ula=SUBU 				else
                op1 and op2         when  op_ula=AAND				else 
                op1 or  op2         when  op_ula=OOR  or op_ula=ORI	else 
                op1 xor op2         when  op_ula=XXOR              	else 
                op1 nor op2         when  op_ula=NNOR             	else 
                op1 + op2;     
	
	zero <= '1' when int_ula=x"00000000" else '0';
end architecture;