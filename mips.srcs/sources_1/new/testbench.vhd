library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;          
use STD.TEXTIO.all;
use work.pkg_mips.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
    signal reset, clock: std_logic := '0';
        
    signal ce, rw: std_logic;
    
    signal Ddata, i_cpu_address, d_cpu_address, 
           data_cpu : reg32 := (others => '0' );

    constant clock_period : time := 200 ns;
    signal instruction : reg32;
begin
    
    Ddata   <= data_cpu when (ce='1' and rw='0') else (others=>'Z'); 

    data_cpu <= Ddata when (ce='1' and rw='1') else (others=>'Z');
    
        
    cpu: entity work.processadorMIPS
        port map(
            clk=>clock, 
            rst=>reset,
            i_address => i_cpu_address,
            instruction => instruction,
            ce=>ce,  
            rw=>rw,
            d_address => d_cpu_address,
            data => data_cpu
        );
        
    -- gerando o sinal de reset
    reset <='1', '0' after 8 ns;       
    
    -- gerando o sinal de clock
   
    clock <= not clock after clock_period/2;
   
     estimulos: process
     begin
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

