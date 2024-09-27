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
            data => data_cpu
        );
        
clk:
clock <= not clock after clock_period/2; 

rst: 
process
       begin
         reset <= '1';
         wait for 1*clock_period;
         reset <= '0';
         wait for 200*clock_period;
      
end process;  
        
end Behavioral;

